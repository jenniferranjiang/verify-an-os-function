/*
* Copyright (c) 2020 AIIT XUOS Lab
* XiUOS is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*        http://license.coscl.org.cn/MulanPSL2
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
* See the Mulan PSL v2 for more details.
*/

/**
 * @file ec801e_cn.c
 * @brief Implement the connection 4G adapter function, using EC801E-CN device
 * @version 3.0
 * @author AIIT XUOS Lab
 * @date 2024.12.25
 */

#include <adapter.h>
#include <at_agent.h>

#define EC801E_AT_MODE_CMD          "+++"
#define EC801E_DATA_MODE_CMD        "ATO\r\n"
#define EC801E_ATI_CMD              "ATI\r\n"
#define EC801E_CIMI_CMD             "AT+CIMI\r\n"
#define EC801E_GET_QCCID_CMD        "AT+QCCID=?\r\n"
#define EC801E_GET_CPIN_CMD         "AT+CPIN?\r\n"
#define EC801E_GET_CREG_CMD         "AT+CREG?\r\n"
#define EC801E_CFG_TCP_CMD          "AT+QICSGP"
#define EC801E_ACTIVE_PDP_CMD       "AT+QIACT=1\r\n"
#define EC801E_DEACTIVE_PDP_CMD     "AT+QIDEACT=1\r\n"
#define EC801E_OPEN_SOCKET_CMD      "AT+QIOPEN=1,%u"
#define EC801E_CLOSE_SOCKET_CMD     "AT+QICLOSE=%u\r\n"
#define EC801E_CLOSE                "AT+QPOWD\r\n"
#define EC801E_GET_COPS_CMD         "AT+COPS?\r\n"
#define EC801E_GET_CSQ_CMD          "AT+CSQ\r\n"
#define EC801E_GET_POP_IP           "AT+CGPADDR=1\r\n"
#define EC801E_CONNECTION_STATUS_CMD "AT+QISTATE?\r\n"

#define EC801E_OK_REPLY             "OK"
#define EC801E_READY_REPLY          "READY"
#define EC801E_CREG_REPLY           ",1"
#define EC801E_CONNECT_REPLY        "CONNECT"

#define TRY_TIMES 10

extern int Ec801eMqttConnect(struct Adapter *adapter, const char *ip, const char *port, const char *client_id, const char *username, const char *password);
extern int Ec801eMqttDisconnect(struct Adapter *adapter);
extern int Ec801eMqttSend(struct Adapter *adapter, const char *topic, const void *buf, size_t len);
extern int Ec801eMqttRecv(struct Adapter *adapter, const char *topic, void *buf, size_t len);

static void Ec801ePowerSet(void)
{
#ifdef ADAPTER_EC801E_USING_PWRKEY
    int pin_fd;
    pin_fd = PrivOpen(ADAPTER_EC801E_PIN_DRIVER, O_RDWR);
    if (pin_fd < 0) {
        printf("open %s error\n", ADAPTER_EC801E_PIN_DRIVER);
        return;
    }

    struct PinParam pin_param;
    pin_param.cmd = GPIO_CONFIG_MODE;
    pin_param.mode = GPIO_CFG_OUTPUT;
    pin_param.pin = ADAPTER_EC801E_PWRKEY;

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = PIN_TYPE;
    ioctl_cfg.args = &pin_param;
    PrivIoctl(pin_fd, OPE_CFG, &ioctl_cfg);

    struct PinStat pin_stat;
    pin_stat.pin = ADAPTER_EC801E_PWRKEY;
    pin_stat.val = GPIO_LOW; //put power key at low-level state
    PrivWrite(pin_fd, &pin_stat, 1);

    PrivTaskDelay(2500); //wait at least 2s

    pin_stat.val = GPIO_HIGH; //put power key at high-level state
    PrivWrite(pin_fd, &pin_stat, 1);

    PrivClose(pin_fd);

    PrivTaskDelay(10000);
#endif
}

static int Ec801eOpen(struct Adapter *adapter)
{
    /*step1: open ec801e serial port*/
    adapter->fd = PrivOpen(ADAPTER_EC801E_DRIVER, O_RDWR);
    if (adapter->fd < 0) {
        printf("Ec801eOpen get serial %s fd error\n", ADAPTER_EC801E_DRIVER);
        return -1;
    }

    /*step2: init AT agent*/
    if (!adapter->agent) {
        char *agent_name = "4G_uart_client";
        if (0 != InitATAgent(agent_name, adapter->fd, 256)) {
            printf("at agent init failed !\n");
            return -1;
        }
        ATAgentType at_agent = GetATAgent(agent_name);

        adapter->agent = at_agent;
    }

    PrivTaskDelay(2500);

    ADAPTER_DEBUG("Ec801e open done\n");

    return 0;
}

static int Ec801eClose(struct Adapter *adapter)
{
    int ret = 0;
    uint8_t ec801e_cmd[64];
    
    if (!adapter->agent) {
        printf("Ec801eClose AT agent NULL\n");
        return -1;
    }

    AtSetReplyEndChar(adapter->agent, 0x4F, 0x4B);  //'O', 'K'
    AtSetReplyCharNum(adapter->agent, 256);

    /*step1: serial write "+++", quit transparent mode*/
    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, "+++");

    /*step2: serial write "AT+QICLOSE", close socket connect before open socket*/
    memset(ec801e_cmd, 0, sizeof(ec801e_cmd));
    sprintf(ec801e_cmd, EC801E_CLOSE_SOCKET_CMD, adapter->socket.socket_id);

    ret = AtCmdConfigAndCheck(adapter->agent, ec801e_cmd, EC801E_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step3: serial write "AT+QIDEACT", close TCP net before open socket*/
    ret = AtCmdConfigAndCheck(adapter->agent, EC801E_DEACTIVE_PDP_CMD, EC801E_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

out:
    /*step4: power down ec801e*/
    ret = AtCmdConfigAndCheck(adapter->agent, EC801E_CLOSE, EC801E_OK_REPLY);
    PrivTaskDelay(12500); //wait at least 12s

     /*step5: close ec801e serial port*/
    PrivClose(adapter->fd);
    
    return ret;
}

#ifdef ADD_RTTHREAD_FEATURES
static int Ec801eIoctl(struct Adapter *adapter, int cmd, void *args){ return 0;}
#else
static int Ec801eIoctl(struct Adapter *adapter, int cmd, void *args)
{
    if (OPE_INT != cmd) {
        printf("Ec801eIoctl only support OPE_INT, do not support %d\n", cmd);
        return -1;
    }

    uint32_t baud_rate = *((uint32_t *)args);

    struct SerialDataCfg serial_cfg;
    memset(&serial_cfg, 0 ,sizeof(struct SerialDataCfg));
    serial_cfg.serial_baud_rate = baud_rate;
    serial_cfg.serial_data_bits = DATA_BITS_8;
    serial_cfg.serial_stop_bits = STOP_BITS_1;
    serial_cfg.serial_buffer_size = SERIAL_RB_BUFSZ;
    serial_cfg.serial_parity_mode = PARITY_NONE;
    serial_cfg.serial_bit_order = STOP_BITS_1;
    serial_cfg.serial_invert_mode = NRZ_NORMAL;
#ifdef TOOL_USING_OTA
    serial_cfg.serial_timeout = OTA_RX_TIMEOUT;
#else
    //serial receive timeout 10s
    serial_cfg.serial_timeout = 100000;
#endif
    serial_cfg.is_ext_uart = 0;
#ifdef ADAPTER_EC801E_DRIVER_EXT_PORT
    serial_cfg.is_ext_uart = 1;
    serial_cfg.ext_uart_no = ADAPTER_EC801E_DRIVER_EXT_PORT;
    serial_cfg.port_configure = PORT_CFG_INIT;
#endif

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = &serial_cfg;
    PrivIoctl(adapter->fd, OPE_INT, &ioctl_cfg);

    Ec801ePowerSet();
    
    return 0;
}
#endif

static int Ec801eConnect(struct Adapter *adapter, enum NetRoleType net_role, const char *ip, const char *port, enum IpType ip_type)
{
    int ret = 0;
    int try = 0;
    uint8_t ec801e_cmd[64];

    AtSetReplyEndChar(adapter->agent, 0x4F, 0x4B);
    AtSetReplyCharNum(adapter->agent, 256);

    /*step1: serial write "+++", quit transparent mode*/
    PrivTaskDelay(1500); //before +++ command, wait at least 1s
    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, EC801E_AT_MODE_CMD);
    PrivTaskDelay(1500); //after +++ command, wait at least 1s

    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_ATI_CMD, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(300);

    /*step2: serial write "AT+CPIN?", check SIM status*/
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_GET_CPIN_CMD, EC801E_READY_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(300);

    /*step3: serial write "AT+CCID", get SIM ID*/
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_GET_QCCID_CMD, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }

    /*step4: serial write "AT+CREG?", check whether registered to GSM net*/
    PrivTaskDelay(1000); //before CREG command, wait 1s

    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_GET_CREG_CMD, EC801E_CREG_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(300);

    /*step5: serial write "AT+QICSGP", connect to China Mobile using ipv4 or ipv6*/
    memset(ec801e_cmd, 0, sizeof(ec801e_cmd));

    if (IPV4 == ip_type) {
        strcpy(ec801e_cmd, "AT+QICSGP=1,1,\"CMNET\",\"\",\"\",1\r\n");
    } else if (IPV6 == ip_type) {
        strcpy(ec801e_cmd, "AT+QICSGP=1,2,\"CMNET\",\"\",\"\",1\r\n");
    }
    
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, ec801e_cmd, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(300);

    /*step6: serial write "AT+QICLOSE", close socket connect before open socket*/
    memset(ec801e_cmd, 0, sizeof(ec801e_cmd));
    
    sprintf(ec801e_cmd, EC801E_CLOSE_SOCKET_CMD, adapter->socket.socket_id);
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, ec801e_cmd, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(300);

    /*step7: serial write "AT+QIDEACT", close TCP net before open socket*/
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_DEACTIVE_PDP_CMD, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(300);

    /*step8: serial write "AT+QIACT", open TCP net*/
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_ACTIVE_PDP_CMD, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }

    /*step9: serial write "AT+QIOPEN", connect socket using TCP*/
    memset(ec801e_cmd, 0, sizeof(ec801e_cmd));
    sprintf(ec801e_cmd, EC801E_OPEN_SOCKET_CMD, adapter->socket.socket_id);
    strcat(ec801e_cmd, ",\"TCP\",\"");
    strcat(ec801e_cmd, ip);
    strcat(ec801e_cmd, "\",");
    strcat(ec801e_cmd, port);
    strcat(ec801e_cmd, ",0,2\r\n");

    AtSetReplyEndChar(adapter->agent, 0x43, 0x54);

    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, ec801e_cmd, EC801E_CONNECT_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }

    adapter->network_info.is_connected = 1;

    ADAPTER_DEBUG("Ec801e connect TCP done\n");

    return 0;

out:
    ADAPTER_DEBUG("Ec801e connect TCP failed. Power down\n");
    ret = AtCmdConfigAndCheck(adapter->agent, EC801E_CLOSE, EC801E_OK_REPLY);
    return -1;
}

static int Ec801eSend(struct Adapter *adapter, const void *buf, size_t len)
{
    if (adapter->agent) {
        EntmSend(adapter->agent, (const char *)buf, len);
    } else {
        printf("Ec801eSend can not find agent\n");
    }
    return 0;
}

static int Ec801eRecv(struct Adapter *adapter, void *buf, size_t len)
{
    if (adapter->agent) {
        return EntmRecv(adapter->agent, (char *)buf, len, 6);
    } else {
        printf("Ec801eRecv can not find agent\n");
	}
    
    return -1;
}

static int Ec801eDisconnect(struct Adapter *adapter)
{
    int ret = 0;
    uint8_t ec801e_cmd[64];

    AtSetReplyEndChar(adapter->agent, 0x4F, 0x4B);
    AtSetReplyCharNum(adapter->agent, 256);
    
    /*step1: serial write "+++", quit transparent mode*/
    PrivTaskDelay(1500); //before +++ command, wait at least 1s
    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, "+++");
    PrivTaskDelay(1500); //after +++ command, wait at least 1s

    /*step2: serial write "AT+QICLOSE", close socket connect before open socket*/
    memset(ec801e_cmd, 0, sizeof(ec801e_cmd));
    sprintf(ec801e_cmd, EC801E_CLOSE_SOCKET_CMD, adapter->socket.socket_id);
    ret = AtCmdConfigAndCheck(adapter->agent, ec801e_cmd, EC801E_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    adapter->network_info.is_connected = 0;

    ADAPTER_DEBUG("Ec801e disconnect TCP done\n");

    return 0;

out:
    ADAPTER_DEBUG("Ec801e disconnect TCP failed. Power down\n");
    ret = AtCmdConfigAndCheck(adapter->agent, EC801E_CLOSE, EC801E_OK_REPLY);
    return -1;
}

static void extractCarrierInfo(char *response, struct NetworkInfo *networkInfo)
{
    const char *delimiter = "\"";
    const char *token;

    token = strtok(response, delimiter);
    token = strtok(NULL, delimiter);

    if (strcmp(token, "CHINA MOBILE") == 0) {
        networkInfo->carrier_type = CARRIER_CHINA_MOBILE;
    } else if (strcmp(token, "CHN-UNICOM") == 0) {
        networkInfo->carrier_type = CARRIER_CHINA_UNICOM;
    } else if (strcmp(token, "CHN-CT") == 0) {
        networkInfo->carrier_type = CARRIER_CHINA_TELECOM;
    } else {
        networkInfo->carrier_type = CARRIER_UNKNOWN;
    }
}

static int Ec801eNetstat(struct Adapter *adapter) {
    char result[64] = {0};

    struct NetworkInfo info = {
        .carrier_type = CARRIER_UNKNOWN,
        .signal_strength = 0,
        .ip_address = "192.168.1.1"
    };
    
    int ret = 0;
    int try = 0;

    AtSetReplyEndChar(adapter->agent, 0x4F, 0x4B);
    AtSetReplyCharNum(adapter->agent, 256);

    /*step1: serial write "+++", quit transparent mode*/
    PrivTaskDelay(1500); //before +++ command, wait at least 1s
    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, "+++");
    PrivTaskDelay(1500); //after +++ command, wait at least 1s

    /*step2: serial write "AT+CPIN?", check SIM status*/
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_GET_CPIN_CMD, EC801E_READY_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }

    /*step3: serial write "AT+CCID", get SIM ID*/
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_GET_QCCID_CMD, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }

    /*step4: serial write "AT+CREG?", check whether registered to GSM net*/
    PrivTaskDelay(1000); //before CREG command, wait 1s

    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_GET_CREG_CMD, EC801E_CREG_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }

    /*step5: serial write "AT+COPS?", get carrier type*/
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtGetNetworkInfoReply(adapter->agent, EC801E_GET_COPS_CMD, result);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    extractCarrierInfo(result, &info);
    adapter->network_info.carrier_type = info.carrier_type;

    /*step6: serial write "AT+CSQ", get signal strength*/
    memset(result, 0, sizeof(result));
    
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtGetNetworkInfoReply(adapter->agent, EC801E_GET_CSQ_CMD, result);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    if (sscanf(result, "AT+CSQ\n+CSQ: %d", &info.signal_strength) == 1) {
        printf("Signal Strength: %d\n", info.signal_strength);
        adapter->network_info.signal_strength = info.signal_strength;
    } else {
        printf("Failed to parse signal strength\n");
        goto out;
    }

    /*step7: serial write "AT+CSQ", get carrier type*/
    memset(result, 0, sizeof(result));
    
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtGetNetworkInfoReply(adapter->agent, EC801E_GET_POP_IP, result);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    if (sscanf(result, "AT+CGPADDR=1\n+CGPADDR: 1,\"%15[^\"]\"", info.ip_address) == 1) {
        printf("IP Address: %s\n", info.ip_address);
        strcpy(adapter->network_info.ip_address, info.ip_address);
    } else {
        printf("Failed to parse IP address\n");
        goto out;
    }

    /*step8: serial write "AT+QISTATE", get connection state*/
    memset(result, 0, sizeof(result));
    
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtGetNetworkInfoReply(adapter->agent, EC801E_CONNECTION_STATUS_CMD, result);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    if (strstr(result, "+QISTATE:") != NULL) {
        printf("Socket is connected\n");
        adapter->network_info.is_connected = 1;
    } else {
        printf("Socket is disconnected\n");
        adapter->network_info.is_connected = 0;
    }

    // return to data mode
    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, "ATO\r\n");

    return 0;

out:
    ADAPTER_DEBUG("Ec801e get netstat failed. Power down\n");
    ret = AtCmdConfigAndCheck(adapter->agent, EC801E_CLOSE, EC801E_OK_REPLY);
    return -1;
}

static const struct IpProtocolDone ec801e_done = 
{
    .open = Ec801eOpen,
    .close = Ec801eClose,
    .ioctl = Ec801eIoctl,
    .setup = NULL,
    .setdown = NULL,
    .setaddr = NULL,
    .setdns = NULL,
    .setdhcp = NULL,
    .ping = NULL,
    .netstat = Ec801eNetstat,
    .connect = Ec801eConnect,
    .send = Ec801eSend,
    .recv = Ec801eRecv,
    .disconnect = Ec801eDisconnect,
    .mqttconnect = Ec801eMqttConnect,
    .mqttdisconnect = Ec801eMqttDisconnect,
    .mqttsend = Ec801eMqttSend,
    .mqttrecv = Ec801eMqttRecv,
};

AdapterProductInfoType Ec801eAttach(struct Adapter *adapter)
{
    struct AdapterProductInfo *product_info = PrivMalloc(sizeof(struct AdapterProductInfo));
    if (!product_info) {
        printf("Ec801eAttach malloc product_info error\n");
        PrivFree(product_info);
        return NULL;
    }

    strcpy(product_info->model_name, ADAPTER_4G_EC801E);

    product_info->model_done = (void *)&ec801e_done;

    return product_info;
}
