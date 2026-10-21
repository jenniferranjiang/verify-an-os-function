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
 * @file gm800tf.c
 * @brief Implement the connection 4G adapter function, using GM800TF device
 * @author Huo Yujia (huoyujia081@126.com)
 * @version 1.0
 * @date 2024-07-05
 */

#include <adapter.h>
#include <at_agent.h>

#define GM800TF_AT_MODE_CMD "+++"
#define GM800TF_GET_ICCID_CMD "AT+ICCID\r\n"
#define GM800TF_SETUP_SOCKET_CMD "AT+SOCK%c=TCP,%s,%s\r\n"
#define GM800TF_OPEN_SOCKET_CMD "AT+SOCK%cEN=ON\r\n"
#define GM800TF_CLOSE_SOCKET_CMD "AT+SOCK%cEN=OFF\r\n"
#define GM800TF_SET_WKMOD_NET_CMD "AT+WKMOD=NET\r\n"
#define GM800TF_GET_WKMOD_CMD "AT+WKMOD?\r\n"
#define GM800TF_SAVE_CFG_CMD "AT+S\r\n"
#define GM800TF_GET_CSQ_CMD "AT+CSQ\r\n"
#define GM800TF_ENTM_MODE_CMD "AT+ENTM\r\n"
#define GM800TF_GET_SOCKET_PARAM_CMD "AT+SOCK%c?\r\n"
#define GM800TF_GET_SOCKET_STATUS_CMD "AT+SOCK%cLK\r\n"
#define GM800TF_RESET_CMD "AT+CLEAR\r\n"
#define GM800TF_SET_HEART_CMD "AT+HEARTEN=%s\r\n"
#define GM800TF_SET_HEART_DATA_CMD "AT+HEARTDT=%s\r\n"
#define GM800TF_SET_HEART_TIME_CMD "AT+HEARTTM=%d\r\n"
#define GM800TF_GET_MQTT_STATUS_CMD "AT+MQTTSTA?\r\n"
#define GM800TF_GET_MQTT_SERVER_CMD "AT+MQTTSVR?\r\n"
#define GM800TF_GET_MQTT_CLIENTID_CMD "AT+MQTTCID?\r\n"
#define GM800TF_GET_MQTT_USERNAME_CMD "AT+MQTTUSER?\r\n"
#define GM800TF_GET_MQTT_PASSWORD_CMD "AT+MQTTPSW?\r\n"

#define GM800TF_OK_REPLY "OK"
#define GM800TF_READY_REPLY "READY"
#define GM800TF_CREG_REPLY ",1"
#define GM800TF_CONNECT_REPLY "CONNECT"

#define TRY_TIMES 10

/**
 * @brief  convert string to corresponding hex string
 * @param  input  original string
 * @param  output hex string
 */
void string_to_hex(const char *input, char *output) {
    while (*input) {
        sprintf(output, "%02X", (unsigned char)*input);
        input++;
        output += 2;
    }
    *output = '\0';  // Null-terminate the output string
}

/**
 * @brief  enter the configuration mode
 * @param  adapter
 * @return int
 */
int Gm800tfEnterAtMode(struct Adapter *adapter) {
    AtSetReplyEndChar(adapter->agent, 'o', 'k');
    AtSetReplyCharNum(adapter->agent, 256);
    AtSetReplyLrEnd(adapter->agent, 1);

    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, "+++");
    PrivTaskDelay(500);

    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, "a");
    PrivTaskDelay(100);

    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, "\r\n");  // clear the "+++a", confirm it will not be added to the following command.
    PrivTaskDelay(500);
    return 0;
}

/**
 * @brief  open the GM800TF(aka. init the serial) and init the AT agent
 * @param  adapter
 * @return int
 */
static int Gm800tfOpen(struct Adapter *adapter) {
    /*step1: open gm800tf serial port*/
    adapter->fd = PrivOpen(ADAPTER_GM800TF_DEV, O_RDWR);
    if (adapter->fd < 0) {
        printf("Gm800tfOpen get serial %s fd error\n", ADAPTER_GM800TF_DEV);
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

    /* step3: reset gm800tf */
    ADAPTER_DEBUG("Gm800tf reseting configuration\n");
    Gm800tfEnterAtMode(adapter);
    AtSetReplyEndChar(adapter->agent, 'O', 'K');
    AtSetReplyCharNum(adapter->agent, 256);
    AtSetReplyLrEnd(adapter->agent, 0);
    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, "AT+CLEAR\r\n");
    PrivTaskDelay(15000);  // after reset configuration, wait at least 10s for restarting

    /* step4: communication from sockA channel only*/
    adapter->socket.socket_id = 0;

    ADAPTER_DEBUG("Gm800tf open done\n");
    return 0;
}

/**
 * @brief  close the GM800TF(aka. disable the interrupt) and disconnect the socket
 * @param  adapter
 * @return int
 */
static int Gm800tfClose(struct Adapter *adapter) {
    int ret = 0;
    uint8_t gm800tf_cmd[64];

    if (!adapter->agent) {
        printf("Gm800tfClose AT agent NULL\n");
        return -1;
    }

    AtSetReplyEndChar(adapter->agent, 0x4F, 0x4B);  //'O', 'K'

    /*step1: serial write "+++", quit transparent mode*/
    ret = Gm800tfEnterAtMode(adapter);
    if (ret < 0) {
        goto out;
    }

    /*step2: serial write "AT+SOCKAEN=OFF" or "AT+SOCKBEN=OFF", close socket connect before open socket*/
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_CLOSE_SOCKET_CMD, 'A' + adapter->socket.socket_id);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step3: serial write "AT+S", save configuration and restart 4G module*/
    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_SAVE_CFG_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(15000);  // after save configuration, wait at least 10s for restarting

out:
    /*step4: close gm800tf serial port and delete ATAgentReceiveProcess*/
    // DeleteATAgent(adapter->agent);
    // adapter->agent = NULL;
    PrivClose(adapter->fd);

    return ret;
}

/**
 * @brief  config the serial and enable the interrupt
 * @param  adapter
 * @param  cmd
 * @param  args
 * @return int
 */
static int Gm800tfIoctl(struct Adapter *adapter, int cmd, void *args) {
    if (OPE_INT != cmd) {
        printf("Gm800tfIoctl only support OPE_INT, do not support %d\n", cmd);
        return -1;
    }

    uint32_t baud_rate = *((uint32_t *)args);

    struct SerialDataCfg serial_cfg;
    memset(&serial_cfg, 0, sizeof(struct SerialDataCfg));
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
    // serial receive timeout 10s
    serial_cfg.serial_timeout = 100000;
#endif
    serial_cfg.is_ext_uart = 0;

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = &serial_cfg;
    PrivIoctl(adapter->fd, OPE_INT, &ioctl_cfg);

    return 0;
}

/**
 * @brief  connect to the server
 * @param  adapter
 * @param  net_role
 * @param  ip
 * @param  port
 * @param  ip_type
 * @return int
 */
static int Gm800tfConnect(struct Adapter *adapter, enum NetRoleType net_role, const char *ip, const char *port, enum IpType ip_type) {
    int ret = 0;
    int try = 0;
    uint8_t gm800tf_cmd[64];

    /*step0: compare ip and port with current configuration, and if they are the same there is no need to connect again*/
    AdapterDeviceNetstat(adapter);
    if (adapter->network_info.workMode == 1 && strcmp(adapter->network_info.ip_address, ip) == 0 &&
        adapter->network_info.port == atoi(port) && adapter->network_info.is_connected && adapter->network_info.signal_strength < 99) {
        return 0;
    }

    /*step1: serial write "+++" and "a", quit transparent mode*/
    ret = Gm800tfEnterAtMode(adapter);
    if (ret < 0) {
        goto out;
    }

    AtSetReplyEndChar(adapter->agent, 'O', 'K');
    AtSetReplyCharNum(adapter->agent, 256);
    AtSetReplyLrEnd(adapter->agent, 0);

    /*step2: serial write "AT+ICCID", get SIM ID*/
    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_GET_ICCID_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step3: serial write "AT+SOCKA=<protocol>,<address>,<port>" or "AT+SOCKB=<protocol>,<address>,<port>", connect
     * socket using TCP*/
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SETUP_SOCKET_CMD, 'A' + adapter->socket.socket_id, ip, port);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step4: serial write "AT+SOCKAEN=ON" or "AT+SOCKBEN=ON", connect socket using TCP*/
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_OPEN_SOCKET_CMD, 'A' + adapter->socket.socket_id);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /* step5: set up the heartbeat */
    // char *heartbeatData = "heartbeat test";
    // int heartbeatTime = 30;
    // char heartbeatDataHex[65] = {};  // 最多32个字符
    // string_to_hex(heartbeatData, heartbeatDataHex);
    // memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    // sprintf(gm800tf_cmd, GM800TF_SET_HEART_CMD, "ON");
    // ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    // if (ret < 0) {
    //     goto out;
    // }
    // memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    // sprintf(gm800tf_cmd, GM800TF_SET_HEART_DATA_CMD, heartbeatDataHex);
    // ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    // if (ret < 0) {
    //     goto out;
    // }
    // memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    // sprintf(gm800tf_cmd, GM800TF_SET_HEART_TIME_CMD, heartbeatTime);
    // ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    // if (ret < 0) {
    //     goto out;
    // }

    /* step5: set down the heartbeat */
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SET_HEART_CMD, "OFF");
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /* step6: serial write "AT+WKMOD=NET", set the working mode to network transparent transmission mode  */
    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_SET_WKMOD_NET_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step7: serial write "AT+S", save configuration and restart 4G module*/
    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_SAVE_CFG_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(15000);  // after save configuration, wait at least 10s for restarting
    ADAPTER_DEBUG("Gm800tf connect TCP done\n");

    return 0;

out:
    ADAPTER_DEBUG("Gm800tf connect TCP failed.\n");
    return -1;
}

/**
 * @brief  send the data to the server after connect to the server
 * @param  adapter
 * @param  buf
 * @param  len
 * @return int
 */
static int Gm800tfSend(struct Adapter *adapter, const void *buf, size_t len) {
    /* query for whether socket is connected successfully */
    AdapterDeviceNetstat(adapter);
    if (adapter->network_info.is_connected == 0) {
        printf("[error %s %d]socket has not been connected, please call function AdapterDeviceConnect\n", __func__, __LINE__);
        return -1;
    }

    /* send the buf data */
    if (adapter->agent) {
        EntmSend(adapter->agent, (const char *)buf, len);
    } else {
        printf("Gm800tfSend can not find agent\n");
    }
    return 0;
}

/**
 * @brief  receive the data from the server after connect to the server
 * @param  adapter
 * @param  buf
 * @param  len
 * @return int
 */
static int Gm800tfRecv(struct Adapter *adapter, void *buf, size_t len) {
    if (adapter->agent) {
        return EntmRecv(adapter->agent, (char *)buf, len, 6);
    } else {
        printf("Gm800tfRecv can not find agent\n");
    }

    return -1;
}

/**
 * @brief  disconnect the server
 * @param  adapter
 * @return int
 */
static int Gm800tfDisconnect(struct Adapter *adapter) {
    int ret = 0;
    uint8_t gm800tf_cmd[64];

    /* query for whether socket is connected successfully */
    AdapterDeviceNetstat(adapter);
    if (adapter->network_info.is_connected == 0) {
        printf("[error %s %d]socket has not been connected, please call function AdapterDeviceConnect\n", __func__, __LINE__);
        return 0;
    }

    /*step1: serial write "+++", quit transparent mode*/
    ret = Gm800tfEnterAtMode(adapter);
    if (ret < 0) {
        goto out;
    }

    AtSetReplyEndChar(adapter->agent, 'O', 'K');
    AtSetReplyCharNum(adapter->agent, 256);
    AtSetReplyLrEnd(adapter->agent, 0);

    /*step2: serial write "AT+SOCKAEN=OFF" or "AT+SOCKBEN=OFF", close socket connect before open socket*/
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_CLOSE_SOCKET_CMD, 'A' + adapter->socket.socket_id);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step3: serial write "AT+S", save configuration and restart 4G module*/
    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_SAVE_CFG_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(15000);  // after save configuration, wait at least 5s for restarting
    ADAPTER_DEBUG("Gm800tf disconnect TCP done\n");

    return 0;

out:
    ADAPTER_DEBUG("Gm800tf disconnect TCP failed. \n");
    return -1;
}

/**
 * @brief  query for the network status
 * @param  adapter
 * @return int
 */
static int Gm800tfNetstat(struct Adapter *adapter) {
    char result[96] = {0};
    uint8_t gm800tf_cmd[64];

    int ret = 0;
    int try = 0;

    /*step1: serial write "+++", quit transparent mode*/
    ret = Gm800tfEnterAtMode(adapter);
    if (ret < 0) {
        goto out;
    }

    AtSetReplyEndChar(adapter->agent, 'O', 'K');
    AtSetReplyCharNum(adapter->agent, 256);
    AtSetReplyLrEnd(adapter->agent, 0);

    /*step2: serial write "AT+ICCID", get SIM ID*/
    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_GET_ICCID_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        printf("[error %s %d]AT+ICCID failed, please check the SIM card\n", __func__, __LINE__);
        goto out;
    }

    printf("-*-*-*-*-*-*-*Gm800tfNetstat*-*-*-*-*-*-*\n");
    /*step3: serial write "AT+CSQ", get carrier type*/
    memset(result, 0, sizeof(result));
    ret = AtGetNetworkInfoReply(adapter->agent, GM800TF_GET_CSQ_CMD, result);
    if (ret < 0) {
        goto out;
    }
    if (sscanf(strstr(result, "+CSQ:"), "+CSQ: %d", &adapter->network_info.signal_strength) == 1) {
        printf("signal strength:\t%d\n", adapter->network_info.signal_strength);
    } else {
        printf("Failed to parse signal strength\n");
        goto out;
    }

    /*step4: serial write "AT+WKMOD?", get the current work mode*/
    memset(result, 0, sizeof(result));
    ret = AtGetNetworkInfoReply(adapter->agent, GM800TF_GET_WKMOD_CMD, result);
    if (ret < 0) {
        goto out;
    }
    char workMode[10] = {};
    if (sscanf(strstr(result, "+WKMOD:"), "+WKMOD:%s", workMode) == 1) {
        printf("work mode:\t\t%s\n", workMode);
        if (strcmp(workMode, "NET") == 0) {
            adapter->network_info.workMode = 1;
        } else if (strcmp(workMode, "MQTT,NOR") == 0) {
            adapter->network_info.workMode = 2;
        } else {
            adapter->network_info.workMode = 0;
        }
    } else {
        printf("Failed to parse work mode\n");
        goto out;
    }

    /*step5: serial write "AT+SOCKA=?", get the current server IP address*/
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_GET_SOCKET_PARAM_CMD, 'A' + adapter->socket.socket_id);
    ret = AtGetNetworkInfoReply(adapter->agent, gm800tf_cmd, result);
    if (ret < 0) {
        goto out;
    }
    if (sscanf(strstr(result, ",") + 1, "%15[^,],%hu", adapter->network_info.ip_address, &adapter->network_info.port) == 2) {
        printf("server ip address:\t%s\n", adapter->network_info.ip_address);
        printf("server port:\t\t%hu\n", adapter->network_info.port);
    } else {
        printf("server ip address:\t%s\n", adapter->network_info.ip_address);
        printf("server port:\t\t%d\n", adapter->network_info.port);
        printf("Failed to parse IP address and port\n");
        goto out;
    }

    /*step6: serial write "AT+SOCKALK" or "AT+SOCKBLK", get socket status*/
    memset(result, 0, sizeof(result));
    sprintf(gm800tf_cmd, GM800TF_GET_SOCKET_STATUS_CMD, 'A' + adapter->socket.socket_id);
    ret = AtGetNetworkInfoReply(adapter->agent, gm800tf_cmd, result);
    if (ret < 0) {
        goto out;
    }
    char socket_status[20] = {};
    if (sscanf(strstr(result, "LK:"), "LK: %s", socket_status) == 1) {
        printf("socket status:\t\t%s\n", socket_status);
        adapter->network_info.is_connected = strcmp(socket_status, "Connected") == 0 ? 1 : 0;
    } else {
        printf("Failed to parse socket status\n");
        goto out;
    }

    /*step7: serial write "AT+MQTTSVR=?", get the current mqtt server IP address and port*/
    memset(result, 0, sizeof(result));
    ret = AtGetNetworkInfoReply(adapter->agent, GM800TF_GET_MQTT_SERVER_CMD, result);
    if (ret < 0) {
        goto out;
    }
    if (sscanf(strstr(result, ":") + 1, "%15[^,],%hu", adapter->network_info.mqttServerIp, &adapter->network_info.mqttServerPort) == 2) {
        printf("mqtt server ip address:\t%s\n", adapter->network_info.mqttServerIp);
        printf("mqtt server port:\t%hu\n", adapter->network_info.mqttServerPort);
    } else {
        printf("mqtt server ip address:\t%s\n", adapter->network_info.mqttServerIp);
        printf("mqtt server port:\t%d\n", adapter->network_info.mqttServerPort);
        printf("Failed to parse IP address and port\n");
        goto out;
    }

    /* step8: serial write "AT+MQTTCID=?", get the current mqtt client id*/
    memset(result, 0, sizeof(result));
    ret = AtGetNetworkInfoReply(adapter->agent, GM800TF_GET_MQTT_CLIENTID_CMD, result);
    if (ret < 0) {
        goto out;
    }
    if (sscanf(strstr(result, "MQTTCID:"), "MQTTCID:%s", adapter->network_info.mqttClientId) == 1) {
        printf("mqtt clientid:\t\t%s\n", adapter->network_info.mqttClientId);
    } else {
        printf("Failed to parse mqtt clientid\n");
        goto out;
    }

    /* step9: serial write "AT+MQTTUSER=?", get the current mqtt username*/
    memset(result, 0, sizeof(result));
    ret = AtGetNetworkInfoReply(adapter->agent, GM800TF_GET_MQTT_USERNAME_CMD, result);
    if (ret < 0) {
        goto out;
    }
    if (sscanf(strstr(result, "MQTTUSER:"), "MQTTUSER:%s", adapter->network_info.mqttUsername) == 1) {
        printf("mqtt username:\t\t%s\n", adapter->network_info.mqttUsername);
    } else {
        printf("Failed to parse mqtt username\n");
        goto out;
    }

    /* step10: serial write "AT+MQTTPSW?", get the current mqtt password */
    memset(result, 0, sizeof(result));
    ret = AtGetNetworkInfoReply(adapter->agent, GM800TF_GET_MQTT_PASSWORD_CMD, result);
    if (ret < 0) {
        goto out;
    }
    if (sscanf(strstr(result, "MQTTPSW:"), "MQTTPSW:%s", adapter->network_info.mqttPassword) == 1) {
        printf("mqtt password:\t\t%s\n", adapter->network_info.mqttPassword);
    } else {
        printf("Failed to parse mqtt password\n");
        goto out;
    }

    /*step11: serial write "AT+MQTTSTA", get the status of mqtt connection*/
    memset(result, 0, sizeof(result));
    ret = AtGetNetworkInfoReply(adapter->agent, GM800TF_GET_MQTT_STATUS_CMD, result);
    if (ret < 0) {
        goto out;
    }
    char mqtt_status[20] = {};
    if (sscanf(strstr(result, "STA:"), "STA: %s", mqtt_status) == 1) {
        printf("mqtt status:\t\t%s\n", mqtt_status);
        adapter->network_info.mqttIsConnected = strcmp(mqtt_status, "\"CONNECTION\"") == 0 ? 1 : 0;
    } else {
        printf("Failed to parse mqtt status\n");
        goto out;
    }

    /* step12: serial write "AT+ENTM", enter entm mode */
    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_ENTM_MODE_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-\n");
    return 0;

out:
    printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-\n");
    ADAPTER_DEBUG("Gm800tf get netstat failed.\n");
    return -1;
}

int Gm800tfMqttConnect(struct Adapter *adapter, const char *ip, const char *port, const char *client_id, const char *username,
                       const char *password);
int Gm800tfMqttDisconnect(struct Adapter *adapter);
int Gm800tfMqttSend(struct Adapter *adapter, const char *topic, const void *buf, size_t len);
int Gm800tfMqttRecv(struct Adapter *adapter, const char *topic, void *buf, size_t len);

static const struct IpProtocolDone gm800tf_done = {
    .open = Gm800tfOpen,
    .close = Gm800tfClose,
    .ioctl = Gm800tfIoctl,
    .setup = NULL,
    .setdown = NULL,
    .setaddr = NULL,
    .setdns = NULL,
    .setdhcp = NULL,
    .ping = NULL,
    .netstat = Gm800tfNetstat,
    .connect = Gm800tfConnect,
    .send = Gm800tfSend,
    .recv = Gm800tfRecv,
    .disconnect = Gm800tfDisconnect,
    .mqttconnect = Gm800tfMqttConnect,
    .mqttdisconnect = Gm800tfMqttDisconnect,
    .mqttsend = Gm800tfMqttSend,
    .mqttrecv = Gm800tfMqttRecv,
};

/**
 * @brief  expose the behavior of GM800TF to application
 * @param  adapter
 * @return AdapterProductInfoType
 */
AdapterProductInfoType Gm800tfAttach(struct Adapter *adapter) {
    struct AdapterProductInfo *product_info = PrivMalloc(sizeof(struct AdapterProductInfo));
    if (!product_info) {
        printf("Gm800tfAttach malloc product_info error\n");
        PrivFree(product_info);
        return NULL;
    }

    strcpy(product_info->model_name, ADAPTER_4G_GM800TF);

    product_info->model_done = (void *)&gm800tf_done;

    return product_info;
}
