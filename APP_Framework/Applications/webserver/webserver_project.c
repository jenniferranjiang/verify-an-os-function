// Copyright (c) 2022 Cesanta Software Limited
// All rights reserved
//
// UI example
// It implements the following endpoints:
//    /api/config/get - respond with current config
//    /api/config/set - POST a config change
//    any other URI serves static files from s_root_dir
// Data and results are JSON strings

/**
* @file webserver_project.c
* @brief support webserver_project for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-11-07
*/

/*************************************************
File name: webserver_project.c
Description: support webserver_project for XiUOS
Others: 
History: 
1. Date: 2023-11-07
Author: AIIT XUOS Lab
Modification: 
1、support xishutong-arm32 board, using W5500 to support webserver.

2. Date: 2024-1-3
Author: AIIT XUOS Lab
Modification: 
1、support xishutong board(single ethernet port), using MAC to support webserver
*************************************************/


#include "ip_addr.h"
#include "mongoose.h"
#include "netdev.h"
#include <sys_arch.h>
#include <lwip/sockets.h>
#include "lwip/sys.h"
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
#include <adapter.h>
#endif

/*******************************************************************************
 * Local variable definitions ('static')
 ******************************************************************************/
char index_path[] = "login.html";

static const char* s_http_addr = "http://192.168.131.88:8000"; // HTTP port
static const char* s_root_dir = "webserver";
static const char* s_enable_hexdump = "no";
static const char* s_ssi_pattern = "#.html";
static const char* web_version = "XiUOS WebServer 1.0";

static const char* net_carrier_china_mobile = "中国移动";
static const char* net_carrier_china_unicom = "中国联通";
static const char* net_carrier_china_telecom = "中国电信";

static struct netdev* p_netdev_webserver;
static struct netdev* p_netdev_ethernet;
static pthread_t tid;

#define WB_EVENT_TASK_STACK_SIZE      4096
#define WB_EVENT_TASK_PRIO            20

#define WB_4G_CONNECT                 0x0001
#define WB_4G_DISCONNECT              0x0002
#define WB_MQTT_CONNECT               0x0004
#define WB_MQTT_DISCONNECT            0x0008
#define WB_LORA_CONNECT               0x0010
#define WB_LORA_DISCONNECT            0x0020
#define WB_ETHERNET_CONNECT           0x0040
#define WB_ETHERNET_DISCONNECT        0x0080
#define WB_EVENT_ALL                 (WB_4G_CONNECT | WB_4G_DISCONNECT |            \
                                      WB_MQTT_CONNECT | WB_MQTT_DISCONNECT |        \
                                      WB_LORA_CONNECT | WB_LORA_DISCONNECT |        \
                                      WB_ETHERNET_CONNECT | WB_ETHERNET_DISCONNECT) 

static int wb_event;
static unsigned int status = 0;
static pthread_t wb_event_task;

enum ModulesType            
{
    MODULES_NULL = 0,          // null
    MODULES_4G,                // support 4G modules
    MODULES_LORA,              // support LoRa modules
    MODULES_ALL,               //all
};

/*define device info*/
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
static const char* device_name = "矽数通4G"; 
static const char* device_type = "xishutong-arm32";
static const char* device_serial_num = "123456789";
static int support_module = MODULES_ALL;
#endif

#ifdef APPLICATION_WEBSERVER_XISHUTONG
static const char* device_name = "矽数通"; 
static const char* device_type = "xishutong-arm32";
static const char* device_serial_num = "123456789";
static int support_module = MODULES_LORA;
#endif

/*define webserver info*/
static struct webserver_config {
    char *ip, *mask, *gw, *dns;
} webserver_config;

/*define interface info*/
static struct rs485_config {
    int baud_rate;
    int data_bit;
    int stop_bit;
    int parity;
} rs485_config;
int rs485_uart_fd = -1;

#define RS485_DEVICE_PATH "/dev/usart4_dev4"

#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
/*define net 4G info*/
static struct net_4g_info {
    char map_ip[20];
    char connect_ip[40];
    char operator[20];
    char signal_strength[20];
    char connect_port[20];

    int net_4g_init_flag;
    int connect_status;
} net_4g_info;

struct Adapter* adapter;

static struct net_4g_mqtt_info {
    char topic[40];
    char username[40];
    char password[40];
    char client_id[40];
    int connect_status;
} net_4g_mqtt_info;
#endif

/*define net LoRa info*/
struct net_lora_info 
{
    uint32_t frequency;         // frequency
    uint8_t sf;                 // spreadfactor
    uint8_t bw;                 // bandwidth

    uint32_t connect_status;    //connect status
    uint8_t lora_init_flag;     //if 1 means already init
} net_lora_info;

/*define net Ethernet info*/
static struct net_ethernet_info {
    char ethernetIp[20];
    char ethernetNetmask[20];
    char ethernetGateway[20];
    char ethernetDNS[20];
    char targetIp[20];
    char targetPort[20];
    char targetGateway[20];
    char targetDNS[20];
    int connect_status;
} net_ethernet_info;

static int socket_fd = -1;

static char tcp_ethernet_ipaddr[] = {192, 168, 130, 77};
static char tcp_ethernet_netmask[] = {255, 255, 254, 0};
static char tcp_ethernet_gwaddr[] = {192, 168, 130, 1};

static uint16_t tcp_socket_port = 8888;

/*define PLC info*/
static char *plc_json;
#define JSON_FILE_NAME "test_recipe.json"

/*******************************************************************************
 * Function implementation - judge using 4G modules or LoRa modules
 ******************************************************************************/
static int JudgeModulesType(void)
{
    int ret;
    int retry = 5;
    
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
    extern int TestLoraRadio(int argc, char *argv[]);
    char* check_params[2] = {"TestLoraRadio", "check"};
    do {
        ret = TestLoraRadio(2, check_params);
        if (ret > 0) {
            retry = 0;
            support_module = MODULES_LORA;
        } else {
            retry--;
        }
    } while (retry > 0);
#endif

    return support_module;
}

/*******************************************************************************
 * Function implementation - define interface info
 ******************************************************************************/
static void Rs485InitConfigure(void)
{
    rs485_uart_fd = PrivOpen(RS485_DEVICE_PATH, O_RDWR);
    if (rs485_uart_fd < 0) {
        printf("open rs485 %s fd error:%d\n", RS485_DEVICE_PATH, rs485_uart_fd);
        return;
    }
    printf("uart %s open success\n", RS485_DEVICE_PATH);

    struct SerialDataCfg uart_cfg;
    memset(&uart_cfg, 0, sizeof(struct SerialDataCfg));

    rs485_config.baud_rate = BAUD_RATE_115200;
    rs485_config.data_bit = DATA_BITS_8;
    rs485_config.stop_bit = STOP_BITS_1;
    rs485_config.parity = PARITY_NONE;

    uart_cfg.serial_baud_rate = rs485_config.baud_rate;
    uart_cfg.serial_data_bits = rs485_config.data_bit;
    uart_cfg.serial_stop_bits = rs485_config.stop_bit;
    uart_cfg.serial_parity_mode = rs485_config.parity;
    uart_cfg.serial_bit_order = BIT_ORDER_LSB;
    uart_cfg.serial_invert_mode = NRZ_NORMAL;
    uart_cfg.serial_buffer_size = SERIAL_RB_BUFSZ;
    uart_cfg.serial_timeout = -1;
    uart_cfg.is_ext_uart = 0;
    uart_cfg.dev_recv_callback = NULL;

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = (void *)&uart_cfg;

    if (0 != PrivIoctl(rs485_uart_fd, OPE_INT, &ioctl_cfg)) {
        printf("ioctl uart fd error %d\n", rs485_uart_fd);
        PrivClose(rs485_uart_fd);
        return;
    }
}

static void Rs485Configure(int baud_rate, int data_bit, int stop_bit, int parity)
{
    if (rs485_uart_fd < 0) {
        rs485_uart_fd = PrivOpen(RS485_DEVICE_PATH, O_RDWR);
        if (rs485_uart_fd < 0) {
            printf("open rs485 %s fd error:%d\n", RS485_DEVICE_PATH, rs485_uart_fd);
            return;
        }
        printf("uart %s open success\n", RS485_DEVICE_PATH);
    }

    struct SerialDataCfg uart_cfg;
    memset(&uart_cfg, 0, sizeof(struct SerialDataCfg));

    uart_cfg.serial_baud_rate = baud_rate;
    uart_cfg.serial_data_bits = data_bit;
    uart_cfg.serial_stop_bits = stop_bit;
    uart_cfg.serial_parity_mode = parity;
    uart_cfg.serial_bit_order = BIT_ORDER_LSB;
    uart_cfg.serial_invert_mode = NRZ_NORMAL;
    uart_cfg.serial_buffer_size = SERIAL_RB_BUFSZ;
    uart_cfg.serial_timeout = -1;
    uart_cfg.is_ext_uart = 0;
    uart_cfg.dev_recv_callback = NULL;

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = (void *)&uart_cfg;

    if (0 != PrivIoctl(rs485_uart_fd, OPE_INT, &ioctl_cfg)) {
        printf("ioctl uart fd error %d\n", rs485_uart_fd);
        PrivClose(rs485_uart_fd);
        return;
    }

    printf("Board RS485 changed to [br: %d, data: %d, stop: %d, party: %d]\n",
        baud_rate, data_bit, stop_bit, parity);
}

/*******************************************************************************
 * Function implementation - define net 4G info
 ******************************************************************************/
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
static void Net4gGetInfo(char *ip, char *operator, char *signal_strength)
{
    if (net_4g_info.net_4g_init_flag) {
        strcpy(ip, adapter->network_info.ip_address);
        sprintf(signal_strength, "%d", adapter->network_info.signal_strength);

        switch (adapter->network_info.carrier_type)
        {
        case CARRIER_CHINA_MOBILE:
            strcpy(operator, net_carrier_china_mobile);
            break;
        case CARRIER_CHINA_UNICOM:
            strcpy(operator, net_carrier_china_unicom);
            break;
        case CARRIER_CHINA_TELECOM:
            strcpy(operator, net_carrier_china_telecom);
            break;
        default:
            break;
        }
    }
}

static void Net4gConnect(void)
{
    int ret = -1;
    int ec200a_baud_rate;
    const char *send_msg = "Adapter_4G Test";

    if (0 == net_4g_info.net_4g_init_flag) {
        adapter->socket.socket_id = 0;
        ec200a_baud_rate = 115200;
        AdapterDeviceOpen(adapter);
        AdapterDeviceControl(adapter, OPE_INT, &ec200a_baud_rate);
        AdapterDeviceNetstat(adapter);
        net_4g_info.net_4g_init_flag = 1;
    }

    if (1 == net_4g_mqtt_info.connect_status) {
        AdapterDeviceMqttDisconnect(adapter);
        net_4g_mqtt_info.connect_status = 0;
    }

    if (0 == net_4g_info.connect_status) {
        ret = AdapterDeviceConnect(adapter, CLIENT, net_4g_info.connect_ip, net_4g_info.connect_port, IPV4);
        if (ret < 0) {
            net_4g_info.connect_status = 0;
            printf("webserver %s fail\n", __func__);
        } else {
            net_4g_info.connect_status = 1;
            AdapterDeviceSend(adapter, send_msg, strlen(send_msg));
            printf("webserver %s success\n", __func__);
        }
    }
}

static void Net4gDisconnect(void)
{
    if (1 == net_4g_info.connect_status) {
        uint8_t priv_net_group = IP_PROTOCOL;
        AdapterDeviceDisconnect(adapter, &priv_net_group);
        net_4g_info.connect_status = 0;
    }
}

/*******************************************************************************
 * Function implementation - define net 4G MQTT info
 ******************************************************************************/
static void NetMqttConnect(void)
{
    int ret = -1;
    int ec200a_baud_rate = 0;

    //for test
    const char *send_msg = "Adapter_4G MQTT Test";
    char recv_msg[256] = {0};
    int send_cnt = 1;

    if (0 == net_4g_info.net_4g_init_flag) {
        adapter->socket.socket_id = 0;
        ec200a_baud_rate = 115200;
        AdapterDeviceOpen(adapter);
        AdapterDeviceControl(adapter, OPE_INT, &ec200a_baud_rate);
        AdapterDeviceNetstat(adapter);
        net_4g_info.net_4g_init_flag = 1;
    }

    if (1 == net_4g_info.connect_status) {
        uint8_t priv_net_group = IP_PROTOCOL;
        AdapterDeviceDisconnect(adapter, &priv_net_group);
        net_4g_info.connect_status = 0;
    }

    if (0 == net_4g_mqtt_info.connect_status) {
        ret = AdapterDeviceMqttConnect(adapter, net_4g_info.connect_ip, net_4g_info.connect_port, 
            net_4g_mqtt_info.client_id, net_4g_mqtt_info.username, net_4g_mqtt_info.password);
        if (ret < 0) {
            net_4g_mqtt_info.connect_status = 0;
            printf("webserver %s fail\n", __func__);
        } else {
            net_4g_mqtt_info.connect_status = 1;

            //for test
            while (send_cnt < 11) {
                AdapterDeviceMqttSend(adapter, net_4g_mqtt_info.topic, send_msg, strlen(send_msg));
                AdapterDeviceMqttRecv(adapter, net_4g_mqtt_info.topic, recv_msg, sizeof(recv_msg));
                printf("[%d]4G mqtt test recv msg %s\n", send_cnt, recv_msg);
                send_cnt++;
            }

            printf("webserver %s success\n", __func__);
        }
    }
}

static void NetMqttDisconnect(void)
{
    if (1 == net_4g_mqtt_info.connect_status) {
        AdapterDeviceMqttDisconnect(adapter);
        net_4g_mqtt_info.connect_status = 0;
    }
}
#endif

/*******************************************************************************
 * Function implementation - define net LoRa info
 ******************************************************************************/
static void NetLoraConnect(void)
{
    if (MODULES_LORA == support_module) {
        char* tx_params[5] = {"TestLoraRadio", "tx", "1", "2000", "2"};
        extern int TestLoraRadio(int argc, char *argv[]);

        if (0 == net_lora_info.lora_init_flag) {
            net_lora_info.lora_init_flag = 1;
        }
        
        TestLoraRadio(5, tx_params);
        net_lora_info.connect_status = 1;
    }
}

static void NetLoraDisconnect(void)
{
    if (MODULES_LORA == support_module) {
        net_lora_info.connect_status = 0;
    }
}

/*******************************************************************************
 * Function implementation - define net Ethernet info
 ******************************************************************************/
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
static void TcpClientConnect(void)
{
    int cnt = 20;
    int ret;
    char send_msg[128];

    sscanf(net_ethernet_info.targetPort, "%d", &tcp_socket_port);

    memset(send_msg, 0, sizeof(send_msg));
    socket_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (socket_fd < 0) {
        printf("Socket error\n");
        return;
    }

    struct sockaddr_in tcp_sock;
    tcp_sock.sin_family = AF_INET;
    tcp_sock.sin_port = htons(tcp_socket_port);
    tcp_sock.sin_addr.s_addr = inet_addr(net_ethernet_info.targetIp);

    memset(&(tcp_sock.sin_zero), 0, sizeof(tcp_sock.sin_zero));

    int keepalive = 1;
    int keepidle = 30;
    int keepinterval = 5;
    int keepcount = 5;
    setsockopt(socket_fd,
        IPPROTO_TCP,           /* set option at TCP level */
        TCP_KEEPALIVE,         /* name of option */
        (void*)&keepalive,     /* the cast is historical cruft */
        sizeof(keepalive));    /* length of option value */

    setsockopt(socket_fd,
        IPPROTO_TCP,           /* set option at TCP level */
        TCP_KEEPIDLE,          /* name of option */
        (void*)&keepidle,      /* the cast is historical cruft */
        sizeof(keepidle));     /* length of option value */

    setsockopt(socket_fd,
        IPPROTO_TCP,           /* set option at TCP level */
        TCP_KEEPINTVL,         /* name of option */
        (void*)&keepinterval,  /* the cast is historical cruft */
        sizeof(keepinterval)); /* length of option value */

    setsockopt(socket_fd,
        IPPROTO_TCP,           /* set option at TCP level */
        TCP_KEEPCNT,           /* name of option */
        (void*)&keepcount,     /* the cast is historical cruft */
        sizeof(keepcount));    /* length of option value */

    ret = connect(socket_fd, (struct sockaddr *)&tcp_sock, sizeof(struct sockaddr));
    if (ret < 0) {
        printf("Unable to connect %s:%d = %d\n", net_ethernet_info.targetIp, tcp_socket_port, ret);
        closesocket(socket_fd);
        return;
    }

    printf("TCP connect %s:%d success, start to send.\n", net_ethernet_info.targetIp, tcp_socket_port);
    net_ethernet_info.connect_status = 1;

    while (cnt --) {
        printf("Lwip client is running.\n");
        snprintf(send_msg, sizeof(send_msg), "TCP test package times %d\r\n", cnt);
        send(socket_fd, send_msg, strlen(send_msg), 0);
        printf("Send tcp msg: %s ", send_msg);
        PrivTaskDelay(1000);
    }

    return;
}

static void TcpClientDisconnect(void)
{
    printf("TCP disconnect\n");
    closesocket(socket_fd);
    net_ethernet_info.connect_status = 0;
}
#endif

/*******************************************************************************
 * Function implementation - define plc info
 ******************************************************************************/
static void PlcInfoWriteToSd(const char *json)
{
    extern int GetSdMountStatus(void);
    if(GetSdMountStatus()) {
        KPrintf("------Start download json file !------\r\n");

        FILE *fp = fopen(JSON_FILE_NAME, "w");
        if(fp == NULL) {
            printf("%s file create failed,please check!\r\n", JSON_FILE_NAME);
        } else {
            printf("%s file create success!\r\n", JSON_FILE_NAME); 
            fprintf(fp, "%s", json);
            fclose(fp);
        }
        printf("------download %s file done!------\r\n", JSON_FILE_NAME);
    }
}

/*******************************************************************************
 * Function implementation - WebserverEventTask
 ******************************************************************************/
static void *WebserverEventTask(void *arg)
{
    wb_event = PrivEventCreate(LINKLIST_FLAG_FIFO);
    while(1) {
        if (0 == PrivEventProcess(wb_event, WB_EVENT_ALL, EVENT_OR | EVENT_AUTOCLEAN, 0, &status)) {
            switch( status ) {
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
                case WB_4G_CONNECT:
                    Net4gConnect();
                    break;
                case WB_4G_DISCONNECT:
                    Net4gDisconnect();
                    break; 
                case WB_MQTT_CONNECT:
                    NetMqttConnect();
                    break;
                case WB_MQTT_DISCONNECT:
                    NetMqttDisconnect();
                    break; 
#endif
                case WB_LORA_CONNECT:
                    NetLoraConnect();
                    break;
                case WB_LORA_DISCONNECT:
                    NetLoraDisconnect();
                    break; 
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
                case WB_ETHERNET_CONNECT:
                    TcpClientConnect();
                    break;
                case WB_ETHERNET_DISCONNECT:
                    TcpClientDisconnect();
                    break;   
#endif
            }
        }
    }
}

static void WbEventInit(void)
{
    char task_name[] = "wb_event_task";
    pthread_args_t args;
    args.pthread_name = task_name;
    
    pthread_attr_t attr;
    attr.schedparam.sched_priority = WB_EVENT_TASK_PRIO;
    attr.stacksize = WB_EVENT_TASK_STACK_SIZE;

    PrivTaskCreate(&wb_event_task, &attr, &WebserverEventTask, (void *)&args);
    PrivTaskStartup(&wb_event_task);
}

/*******************************************************************************
 * Function implementation - webserver
 ******************************************************************************/
// Try to update a single configuration value
static void update_config(struct mg_str json, const char* path, char** value)
{
    char* jval;
    if ((jval = mg_json_get_str(json, path)) != NULL) {
        free(*value);
        *value = strdup(jval);
    }
}

static void update_config_array(struct mg_str json, const char* path, char* value)
{
    char* jval;
    if ((jval = mg_json_get_str(json, path)) != NULL) {
        sprintf(value, "%s", jval); 
    }
}

static void fn(struct mg_connection* c, int ev, void* ev_data, void* fn_data)
{
    if (ev == MG_EV_HTTP_MSG) {
        struct mg_http_message *hm = (struct mg_http_message*)ev_data, tmp = { 0 };
        /*define modules info*/
        if (mg_http_match_uri(hm, "/net/getModulesInfo")) {
            mg_http_reply(c, 200, "Content-Type: application/json\r\n",
                "{%m:%d}\n",
                MG_ESC("modulesStatus"), JudgeModulesType());
        } 
        /*define device info*/
        else if (mg_http_match_uri(hm, "/getSystemInfo")) {
            mg_http_reply(c, 200, "Content-Type: application/json\r\n",
                "{%m:%m, %m:%m, %m:%m, %m:%m, %m:%m, %m:%m}\n",
                MG_ESC("deviceName"), MG_ESC(device_name),
                MG_ESC("deviceType"), MG_ESC(device_type),
                MG_ESC("deviceNo"), MG_ESC(device_serial_num),
                MG_ESC("ip"), MG_ESC(webserver_config.ip),
                MG_ESC("netmask"), MG_ESC(webserver_config.mask),
                MG_ESC("gateway"), MG_ESC(webserver_config.gw));
        } 
        /*define webserver info*/
        else if (mg_http_match_uri(hm, "/setNetInfo")) {
            struct mg_str json = hm->body;
            printf("json: %s\n", json.ptr);
            update_config(json, "$.ip", &webserver_config.ip);
            update_config(json, "$.netmask", &webserver_config.mask);
            update_config(json, "$.gateway", &webserver_config.gw);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");

            ip_addr_t ipaddr, maskaddr, gwaddr;
            inet_aton(webserver_config.ip, &ipaddr);
            inet_aton(webserver_config.mask, &maskaddr);
            inet_aton(webserver_config.gw, &gwaddr);
            p_netdev_webserver->ops->set_addr_info(p_netdev_webserver, &ipaddr, &maskaddr, &gwaddr);

            printf("Board Webserver Net changed to [IP: %s, Mask: %s, GW: %s]\n",
                webserver_config.ip,
                webserver_config.mask,
                webserver_config.gw);
        }
        /*define interface info*/
        else if (mg_http_match_uri(hm, "/interface/get485Info")) {
            mg_http_reply(c, 200, "Content-Type: application/json\r\n",
                "{%m:%d, %m:%d, %m:%d, %m:%d}\n",
                MG_ESC("baudRate"), rs485_config.baud_rate,
                MG_ESC("wordLength"), rs485_config.data_bit,
                MG_ESC("stopBits"), rs485_config.stop_bit,
                MG_ESC("parity"), rs485_config.parity);
        } else if (mg_http_match_uri(hm, "/interface/set485Info")) {
            struct mg_str json = hm->body;
            printf("json: %s\n", json.ptr);
            rs485_config.baud_rate = mg_json_get_long(json, "$.baudRate", 0);
            rs485_config.data_bit = mg_json_get_long(json, "$.wordLength", 0);
            rs485_config.stop_bit = mg_json_get_long(json, "$.stopBits", 0);
            rs485_config.parity = mg_json_get_long(json, "$.parity", 0);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");

            Rs485Configure(rs485_config.baud_rate, rs485_config.data_bit, rs485_config.stop_bit, rs485_config.parity);
        }
        /*define net 4G info*/
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
        else if (mg_http_match_uri(hm, "/net/get4gInfo")) {

            Net4gGetInfo(net_4g_info.map_ip, net_4g_info.operator, net_4g_info.signal_strength);

            mg_http_reply(c, 200, "Content-Type: application/json\r\n",
                "{%m:%m, %m:%m, %m:%m, %m:%m, %m:%m, %m:%d}\n",
                MG_ESC("mapIp"), MG_ESC(net_4g_info.map_ip),
                MG_ESC("operator"), MG_ESC(net_4g_info.operator),
                MG_ESC("signalIntensity"), MG_ESC(net_4g_info.signal_strength),
                MG_ESC("publicIp"), MG_ESC(net_4g_info.connect_ip),
                MG_ESC("publicPort"), MG_ESC(net_4g_info.connect_port),
                MG_ESC("status"), net_4g_info.connect_status);
        } else if (mg_http_match_uri(hm, "/net/set4gInfo")) {
            struct mg_str json = hm->body;
            printf("json: %s\n", json.ptr);
            update_config_array(json, "$.publicIp", net_4g_info.connect_ip);
            update_config_array(json, "$.publicPort", net_4g_info.connect_port);

            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        } else if (mg_http_match_uri(hm, "/net/connect4G")) {
            //enable 4G connect function
            PrivEvenTrigger(wb_event, WB_4G_CONNECT);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        } else if (mg_http_match_uri(hm, "/net/disconnect4G")) {
            //disable 4G connect function
            PrivEvenTrigger(wb_event, WB_4G_CONNECT);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        } else if (mg_http_match_uri(hm, "/net/getMQTTInfo")) {
            mg_http_reply(c, 200, "Content-Type: application/json\r\n",
                "{%m:%m, %m:%m, %m:%m, %m:%m, %m:%d}\n",
                MG_ESC("topic"), MG_ESC(net_4g_mqtt_info.topic),
                MG_ESC("username"), MG_ESC(net_4g_mqtt_info.username),
                MG_ESC("password"), MG_ESC(net_4g_mqtt_info.password),
                MG_ESC("clientId"), MG_ESC(net_4g_mqtt_info.client_id),
                MG_ESC("status"), net_4g_mqtt_info.connect_status);
        } else if (mg_http_match_uri(hm, "/net/setMQTTInfo")) {
            struct mg_str json = hm->body;
            printf("json: %s\n", json.ptr);
            update_config_array(json, "$.topic", net_4g_mqtt_info.topic);
            update_config_array(json, "$.username", net_4g_mqtt_info.username);
            update_config_array(json, "$.password", net_4g_mqtt_info.password);
            update_config_array(json, "$.clientId", net_4g_mqtt_info.client_id);

            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        } else if (mg_http_match_uri(hm, "/net/connectMQTT")) {
            //enable 4G MQTT connect function
            PrivEvenTrigger(wb_event, WB_MQTT_CONNECT);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        } else if (mg_http_match_uri(hm, "/net/disconnectMQTT")) {
            //disable 4G MQTT connect function
            PrivEvenTrigger(wb_event, WB_MQTT_DISCONNECT);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        }
#endif
        /*define net LoRa info*/
        else if (mg_http_match_uri(hm, "/net/getLoraInfo")) {
            mg_http_reply(c, 200, "Content-Type: application/json\r\n",
                "{%m:%d, %m:%d, %m:%d, %m:%d}\n",
                MG_ESC("range"), net_lora_info.frequency,
                MG_ESC("bandwidth"), net_lora_info.bw,
                MG_ESC("factor"), net_lora_info.sf,
                MG_ESC("status"), net_lora_info.connect_status);
        }
        else if (mg_http_match_uri(hm, "/net/setLoraInfo")) {
            struct mg_str json = hm->body;
            printf("json: %s\n", json.ptr);
            net_lora_info.frequency = mg_json_get_long(json, "$.range", 0);
            net_lora_info.sf = mg_json_get_long(json, "$.factor", 0);
            net_lora_info.bw = mg_json_get_long(json, "$.bandwidth", 0);

            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");

            extern void LoraRadioParamsUpdate(uint32_t frequency, uint8_t sf, uint8_t bw);
            LoraRadioParamsUpdate(net_lora_info.frequency, net_lora_info.sf, net_lora_info.bw);
        } else if (mg_http_match_uri(hm, "/net/ConnectLora")) {
            //enable LoRa connect function
            PrivEvenTrigger(wb_event, WB_LORA_CONNECT);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        } else if (mg_http_match_uri(hm, "/net/DisonnectLora")) {
            //disable LoRa connect function
            PrivEvenTrigger(wb_event, WB_LORA_DISCONNECT);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        }
        /*define net Ethernet info*/
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
        else if (mg_http_match_uri(hm, "/net/getEthernetInfo")) {
            mg_http_reply(c, 200, "Content-Type: application/json\r\n",
                "{%m:%m, %m:%m, %m:%m, %m:%m, %m:%m, %m:%m, %m:%m, %m:%m, %m:%d}\n",
                MG_ESC("ethernetIp"), MG_ESC(net_ethernet_info.ethernetIp),
                MG_ESC("ethernetNetmask"), MG_ESC(net_ethernet_info.ethernetNetmask),
                MG_ESC("ethernetGateway"), MG_ESC(net_ethernet_info.ethernetGateway),
                MG_ESC("ethernetDNS"), MG_ESC(net_ethernet_info.ethernetDNS),
                MG_ESC("targetIp"), MG_ESC(net_ethernet_info.targetIp),
                MG_ESC("targetPort"), MG_ESC(net_ethernet_info.targetPort),
                MG_ESC("targetGateway"), MG_ESC(net_ethernet_info.targetGateway),
                MG_ESC("targetDNS"), MG_ESC(net_ethernet_info.targetDNS),
                MG_ESC("ethernetStatus"), net_ethernet_info.connect_status);
        } else if (mg_http_match_uri(hm, "/net/setEthernetInfo")) {
            struct mg_str json = hm->body;
            printf("json: %s\n", json.ptr);
            update_config_array(json, "$.ethernetIp", net_ethernet_info.ethernetIp);
            update_config_array(json, "$.ethernetNetmask", net_ethernet_info.ethernetNetmask);
            update_config_array(json, "$.ethernetGateway", net_ethernet_info.ethernetGateway);
            update_config_array(json, "$.ethernetDNS", net_ethernet_info.ethernetDNS);
            update_config_array(json, "$.targetIp", net_ethernet_info.targetIp);
            update_config_array(json, "$.targetPort", net_ethernet_info.targetPort);
            update_config_array(json, "$.targetGateway", net_ethernet_info.targetGateway);
            update_config_array(json, "$.targetDNS", net_ethernet_info.targetDNS);

            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");

            p_netdev_ethernet = netdev_get_by_name("hd");
            if (p_netdev_ethernet) {
                ip_addr_t ipaddr, maskaddr, gwaddr;
                inet_aton(net_ethernet_info.ethernetIp, &ipaddr);
                inet_aton(net_ethernet_info.ethernetNetmask, &maskaddr);
                inet_aton(net_ethernet_info.ethernetGateway, &gwaddr);
                p_netdev_ethernet->ops->set_addr_info(p_netdev_ethernet, &ipaddr, &maskaddr, &gwaddr);

                printf("Ethernet Configuration changed to [IP: %s, Mask: %s, GW: %s]\n",
                    net_ethernet_info.ethernetIp, net_ethernet_info.ethernetNetmask,
                    net_ethernet_info.ethernetGateway);
            }
        } else if (mg_http_match_uri(hm, "/net/connectEthernet")) {
            //enable Ethernet connect function
            PrivEvenTrigger(wb_event, WB_ETHERNET_CONNECT);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        } else if (mg_http_match_uri(hm, "/net/disconnectEthernet")) {
            //disable Ethernet connect function
            PrivEvenTrigger(wb_event, WB_ETHERNET_DISCONNECT);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        }
#endif
        /*define plc info*/
        else if (mg_http_match_uri(hm, "/control/setPLCInfo")) {
            struct mg_str json = hm->body;
            printf("json: %s\n", json.ptr);
            PlcInfoWriteToSd(json.ptr);
            mg_http_reply(c, 200, "Content-Type: application/json\r\n", "{\"status\":\"success\"}\r\n");
        } else {
            struct mg_str unknown = mg_str_n("?", 1), *cl;
            struct mg_http_serve_opts opts = { .root_dir = s_root_dir, .ssi_pattern = s_ssi_pattern };
            mg_http_serve_dir(c, hm, &opts);
            mg_http_parse((char*)c->send.buf, c->send.len, &tmp);
            cl = mg_http_get_header(&tmp, "Content-Length");
            if (cl == NULL)
                cl = &unknown;
            MG_INFO(("%.*s %.*s %.*s %.*s", (int)hm->method.len, hm->method.ptr,
                (int)hm->uri.len, hm->uri.ptr, (int)tmp.uri.len, tmp.uri.ptr,
                (int)cl->len, cl->ptr));
        }
    }
    (void)fn_data;
}

static void* do_webserver(void* args)
{
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
    p_netdev_webserver = netdev_get_by_name("wz");
    if (p_netdev_webserver == NULL) {
        MG_INFO(("Did not find wz netdev, use default.\n"));
        p_netdev_webserver = NETDEV_DEFAULT;
    }
#endif

#ifdef APPLICATION_WEBSERVER_XISHUTONG
    p_netdev_webserver = netdev_get_by_name("hd");
    if (p_netdev_webserver == NULL) {
        MG_INFO(("Did not find hd netdev, use default.\n"));
        p_netdev_webserver = NETDEV_DEFAULT;
    }
#endif
    MG_INFO(("Webserver Use Netdev %s", p_netdev_webserver->name));
    webserver_config.ip = strdup(inet_ntoa(*p_netdev_webserver->ip_addr));
    webserver_config.mask = strdup(inet_ntoa(*p_netdev_webserver->netmask));
    webserver_config.gw = strdup(inet_ntoa(*p_netdev_webserver->gw));
    webserver_config.dns = strdup(inet_ntoa(p_netdev_webserver->dns_servers[0]));


#ifdef BSP_USING_RS485
    Rs485InitConfigure();
#endif

#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
    adapter = AdapterDeviceFindByName(ADAPTER_4G_NAME);
#endif

    //4g init param
    net_4g_info.net_4g_init_flag = 0;
    net_4g_info.connect_status = 0;
    net_4g_mqtt_info.connect_status = 0;

    //lora init param
    net_lora_info.bw = 2;//bw 0:125 kHz 1:250 kHz 2:500 kHz,
    net_lora_info.sf = 12;//sf12
    net_lora_info.lora_init_flag = 0;

    WbEventInit();

    struct mg_mgr mgr; // Event manager
    // mg_log_set(MG_LL_INFO); // Set to 3 to enable debug
    mg_log_set(MG_LL_ERROR); // Set to 3 to enable debug
    mg_mgr_init(&mgr); // Initialise event manager
    mg_http_listen(&mgr, s_http_addr, fn, NULL); // Create HTTP listener
    for (;;)
        mg_mgr_poll(&mgr, 50); // Infinite event loop
    mg_mgr_free(&mgr);
    return NULL;
}

int webserver(void)
{
    extern void LwipNetworkActive(int argc, char* argv[]);
#ifdef APPLICATION_WEBSERVER_XISHUTONG_4G
    char* params[2] = {"LwipNetworkActive", "-a"};
    LwipNetworkActive(2, params);
#endif

#ifdef APPLICATION_WEBSERVER_XISHUTONG
    char* params[3] = {"LwipNetworkActive", "-e", "0"};
    LwipNetworkActive(3, params);

    extern void LwipSetNetwork(int argc, char* argv[]);
    char* ip_params[5] = {"LwipSetNetwork", "-d", "hd", "-i", "192.168.131.88"};
    LwipSetNetwork(5, ip_params);
    char* gw_params[5] = {"LwipSetNetwork", "-d", "hd", "-g", "192.168.131.1"};
    LwipSetNetwork(5, gw_params);
#endif

    pthread_attr_t attr;
    attr.schedparam.sched_priority = 30;
    attr.stacksize = 0x4000;

    char task_name[] = "do_webserver";
    pthread_args_t args;
    args.pthread_name = task_name;

    PrivTaskCreate(&tid, &attr, &do_webserver, (void *)&args);
    PrivTaskStartup(&tid);

    return 0;
}
SHELL_EXPORT_CMD(SHELL_CMD_PERMISSION(0) | SHELL_CMD_TYPE(SHELL_TYPE_CMD_MAIN) | SHELL_CMD_PARAM_NUM(5), 
    Webserver, webserver, webserver for project);