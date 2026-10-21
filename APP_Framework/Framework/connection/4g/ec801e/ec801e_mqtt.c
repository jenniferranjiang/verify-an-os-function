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
 * @file ec801e_mqtt.c
 * @brief Implement the connection 4G adapter function, using EC801E device
 * @version 3.0
 * @author AIIT XUOS Lab
 * @date 2025.11.22
 */
#include <adapter.h>
#include <at_agent.h>

#define EC801E_GET_QCCID_CMD           "AT+QCCID\r\n"
#define EC801E_GET_CPIN_CMD            "AT+CPIN?\r\n"
#define EC801E_GET_CREG_CMD            "AT+CREG?\r\n"
#define EC801E_CLOSE                   "AT+QPOWD\r\n"
#define EC801E_SET_MQTT_MODE_CMD       "AT+QMTCFG=\"recv/mode\",0,0,1\r\n"
#define EC801E_SET_MQTT_SERVER_CMD     "AT+QMTOPEN=0,"
#define EC801E_SET_MQTT_CONNECT_CMD    "AT+QMTCONN=0,"
#define EC801E_SET_MQTT_DISCONN_CMD    "AT+QMTDISC=0\r\n"
#define EC801E_SET_MQTT_PUBEX_CMD      "AT+QMTPUBEX=0,0,0,0,"
#define EC801E_SET_MQTT_SUB_CMD        "AT+QMTSUB=0,1,"
#define EC801E_OK_REPLY                "OK"
#define EC801E_READY_REPLY             "READY"
#define EC801E_CREG_REPLY              ",1"
#define EC801E_PUBEX_REPLY             ">"
#define TRY_TIMES 10

int Ec801eMqttConnect(struct Adapter *adapter, const char *ip, const char *port, const char *client_id, const char *username, const char *password) {
    int ret = 0;
    int try = 0;
    uint8_t ec801e_cmd[64];

    AtSetReplyEndChar(adapter->agent, 0x4F, 0x4B);
    AtSetReplyCharNum(adapter->agent, 256);

    /*step1: serial write "+++", quit transparent mode*/
    PrivTaskDelay(1500); //before +++ command, wait at least 1s
    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, "+++");
    PrivTaskDelay(1500); //after +++ command, wait at least 1s

    /*step2: serial write "AT+CCID", get SIM ID*/
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_GET_QCCID_CMD, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }

    /*step3: serial write "AT+CPIN?", check SIM status*/
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_GET_CPIN_CMD, EC801E_READY_REPLY);
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

     /*step5: serial write "AT+QMTCFG=", config mqtt params*/
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, EC801E_SET_MQTT_MODE_CMD, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }

    /*step6: serial write "AT+OPEN=", config mqtt ip and port*/
    memset(ec801e_cmd, 0, sizeof(ec801e_cmd)); 
    strcpy(ec801e_cmd, EC801E_SET_MQTT_SERVER_CMD);
    strcat(ec801e_cmd, "\"");
    strcat(ec801e_cmd, ip);
    strcat(ec801e_cmd, "\",");
    strcat(ec801e_cmd, port);
    strcat(ec801e_cmd, "\r\n");
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, ec801e_cmd, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }

    /*step7: serial write "AT+QMTCONN=", config mqtt connection*/
    PrivTaskDelay(1000); //before mqtt connect command, wait 1s

    memset(ec801e_cmd, 0, sizeof(ec801e_cmd)); 
    strcpy(ec801e_cmd, EC801E_SET_MQTT_CONNECT_CMD);
    strcat(ec801e_cmd, "\"");
    strcat(ec801e_cmd, client_id);
    strcat(ec801e_cmd, "\",\"");
    strcat(ec801e_cmd, username);
    strcat(ec801e_cmd, "\",\"");
    strcat(ec801e_cmd, password);
    strcat(ec801e_cmd, "\"\r\n");
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, ec801e_cmd, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }

    adapter->network_info.mqttIsConnected = 1;
    
    ADAPTER_DEBUG("Ec801e mqtt connect done\n");

    return 0;

out:
    ADAPTER_DEBUG("Ec801e mqtt connect failed. Power down\n");
    ret = AtCmdConfigAndCheck(adapter->agent, EC801E_CLOSE, EC801E_OK_REPLY);
    return -1;
}

int Ec801eMqttDisconnect(struct Adapter *adapter)
{
    int ret = 0;

    AtSetReplyEndChar(adapter->agent, 0x4F, 0x4B);
    AtSetReplyCharNum(adapter->agent, 256);
    
    /*step1: serial write "+++", quit transparent mode*/
    PrivTaskDelay(1500); //before +++ command, wait at least 1s
    ATOrderSend(adapter->agent, REPLY_TIME_OUT, NULL, "+++");
    PrivTaskDelay(1500); //after +++ command, wait at least 1s

    /*step2: serial write "AT+QMTDISC", close mqtt connect*/
    ret = AtCmdConfigAndCheck(adapter->agent, EC801E_SET_MQTT_DISCONN_CMD, EC801E_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    adapter->network_info.mqttIsConnected = 0;

    ADAPTER_DEBUG("Ec801e disconnect mqtt done\n");

    return 0;

out:
    ADAPTER_DEBUG("Ec801e disconnect mqtt failed. Power down\n");
    ret = AtCmdConfigAndCheck(adapter->agent, EC801E_CLOSE, EC801E_OK_REPLY);
    return -1;
}

int Ec801eMqttSend(struct Adapter *adapter, const char *topic, const void *buf, size_t len) {
    int ret = 0;
    int try = 0;
    uint8_t ec801e_cmd[64];

    AtSetReplyEndChar(adapter->agent, 0x3E, 0x20);
    AtSetReplyCharNum(adapter->agent, 256);

    char len_str[10];
    sprintf(len_str, "%u", len);
    memset(ec801e_cmd, 0, sizeof(ec801e_cmd)); 
    strcpy(ec801e_cmd, EC801E_SET_MQTT_PUBEX_CMD);
    strcat(ec801e_cmd, "\"");
    strcat(ec801e_cmd, topic);
    strcat(ec801e_cmd, "\",");
    strcat(ec801e_cmd, len_str);
    strcat(ec801e_cmd, "\r\n");
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, ec801e_cmd, EC801E_PUBEX_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    EntmSend(adapter->agent, buf, len);

    ADAPTER_DEBUG("Ec801e mqtt send done\n");

    return 0;

out:
    ADAPTER_DEBUG("Ec801e mqtt send failed. Power down\n");
    ret = AtCmdConfigAndCheck(adapter->agent, EC801E_CLOSE, EC801E_OK_REPLY);
    return -1;
}

int Ec801eMqttRecv(struct Adapter *adapter, const char *topic, void *buf, size_t len) {
    int ret = 0;
    int try = 0;
    uint8_t ec801e_cmd[64];

    AtSetReplyEndChar(adapter->agent, 0x4F, 0x4B);
    AtSetReplyCharNum(adapter->agent, 256);

    memset(ec801e_cmd, 0, sizeof(ec801e_cmd)); 
    strcpy(ec801e_cmd, EC801E_SET_MQTT_SUB_CMD);
    strcat(ec801e_cmd, "\"");
    strcat(ec801e_cmd, topic);
    strcat(ec801e_cmd, "\",0\r\n");
    
    PrivTaskDelay(1000); //before mqtt sub topic command, wait 1s
    for(try = 0; try < TRY_TIMES; try++){
        ret = AtCmdConfigAndCheck(adapter->agent, ec801e_cmd, EC801E_OK_REPLY);
        if (ret == 0) {
            break;
        }
    }
    if (ret < 0) {
        goto out;
    }
    EntmRecv(adapter->agent, buf, len, 30);

    ADAPTER_DEBUG("Ec200a mqtt recv done\n");

    return 0;

out:
    ADAPTER_DEBUG("Ec801e mqtt recv failed. Power down\n");
    ret = AtCmdConfigAndCheck(adapter->agent, EC801E_CLOSE, EC801E_OK_REPLY);
    return -1;
}