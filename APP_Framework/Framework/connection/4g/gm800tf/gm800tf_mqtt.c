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
 * @file gm800tf_mqtt.c
 * @brief  Implement the connection 4G adapter function about mqtt, using GM800TF device
 * @author Huo Yujia (huoyujia081@126.com)
 * @version 1.0
 * @date 2024-07-26
 */
#include <adapter.h>
#include <at_agent.h>

#define GM800TF_GET_ICCID_CMD "AT+ICCID\r\n"
#define GM800TF_SET_WKMOD_MQTT_CMD "AT+WKMOD=MQTT,NOR\r\n"
#define GM800TF_SET_WKMOD_CMD_CMD "AT+WKMOD=CMD\r\n"
#define GM800TF_GET_MQTT_PUBPARAM_CMD "AT+MQTTPUBTP?\r\n"
#define GM800TF_SET_MQTT_PUBPARAM_CMD "AT+MQTTPUBTP=%d,%d,%s,%d,%d\r\n"
#define GM800TF_SET_MQTT_SUBPARAM_CMD "AT+MQTTSUBTP=%d,%d,%s,%d\r\n"
#define GM800TF_SET_MQTT_SERVER_CMD "AT+MQTTSVR=%s,%s\r\n"
#define GM800TF_SET_MQTT_USERNAME_CMD "AT+MQTTUSER=%s\r\n"
#define GM800TF_SET_MQTT_PASSWORD_CMD "AT+MQTTPSW=%s\r\n"
#define GM800TF_SET_MQTT_CLIID_CMD "AT+MQTTCID=%s\r\n"
#define GM800TF_SET_MQTT_MODE_CMD "AT+MQTTMOD=%d\r\n"
#define GM800TF_SET_HEART_DATA_CMD "AT+HEARTDT=%s\r\n"
#define GM800TF_SET_HEART_TIME_CMD "AT+HEARTTM=%d\r\n"
#define GM800TF_SAVE_CFG_CMD "AT+S\r\n"
#define GM800TF_ENTM_MODE_CMD "AT+ENTM\r\n"

#define GM800TF_OK_REPLY "OK"
#define GM800TF_READY_REPLY "READY"
#define GM800TF_CREG_REPLY ",1"
#define GM800TF_PUBEX_REPLY ">"

#define TRY_TIMES 10

int Gm800tfEnterAtMode(struct Adapter *adapter);  // defined in gm800tf.c

/**
 * @brief  connect to mqtt server
 * @param  adapter
 * @param  ip    mqtt server ip address
 * @param  port  mqtt server port
 * @param  client_id mqtt client id
 * @param  username mqtt username
 * @param  password mqtt password
 * @return int 0: success, -1: failed
 */
int Gm800tfMqttConnect(struct Adapter *adapter, const char *ip, const char *port, const char *client_id, const char *username,
                       const char *password) {
    int ret = 0;
    uint8_t gm800tf_cmd[64];

    /*step0: compare ip and port with current configuration, and if they are the same there is no need to connect again*/
    AdapterDeviceNetstat(adapter);
    if (adapter->network_info.workMode == 2 && strcmp(adapter->network_info.mqttServerIp, ip) == 0 &&
        adapter->network_info.mqttServerPort == atoi(port) && strcmp(adapter->network_info.mqttClientId, client_id) == 0 &&
        strcmp(adapter->network_info.mqttUsername, username) == 0 && strcmp(adapter->network_info.mqttPassword, password) == 0 &&
        adapter->network_info.mqttIsConnected && adapter->network_info.signal_strength < 99) {
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

    /*step3: serial write "AT+MQTTSVR=<server>,<port>", config mqtt ip and port*/
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SET_MQTT_SERVER_CMD, ip, port);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step4: serial write "AT+MQTTCID=<clientid>", config mqtt client id*/
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SET_MQTT_CLIID_CMD, client_id);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step5: serial write "AT+MQTTUSER=<username>", config mqtt username*/
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SET_MQTT_USERNAME_CMD, username);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step6: serial write "AT+MQTTPSW=<password>", config mqtt password*/
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SET_MQTT_PASSWORD_CMD, password);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step7: serial write "AT+WKMOD=MQTT", set the working mode to mqtt mode*/
    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_SET_WKMOD_MQTT_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step8: serial write "AT+MQTTMOD=<mode>, set the mqtt mode*/
    /* mode-0: Send data to all preset enabled topics */
    /* mode-1: Send data separately to a specific topic */
    int mode = 1;
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SET_MQTT_MODE_CMD, mode);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step9: set the heartbeat parameter*/
    char *heartbeatData = "heartbeat test";
    int heartbeatTime = 30;
    char heartbeatDataHex[65] = {};  // 最多32个字符
    void string_to_hex(const char *input, char *output);
    string_to_hex(heartbeatData, heartbeatDataHex);
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SET_HEART_DATA_CMD, heartbeatDataHex);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SET_HEART_TIME_CMD, heartbeatTime);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    /*step10: serial write "AT+S", save configuration and restart mqtt module*/
    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_SAVE_CFG_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(20000);  // after save configuration, wait at least 10s for restarting
    ADAPTER_DEBUG("Gm800tf mqtt connect done\n");
    return 0;

out:
    ADAPTER_DEBUG("Gm800tf mqtt connect failed. Power down\n");
    return -1;
}

/**
 * @brief  this function has no use
 * @param  adapter
 * @return int
 */
int Gm800tfMqttDisconnect(struct Adapter *adapter) {
    int ret = 0;
    return 0;
}

/**
 * @brief  send data to mqtt server
 * @param  adapter
 * @param  topic  mqtt publish topic
 * @param  buf    data buffer to send to mqtt server
 * @param  len    data length
 * @return int    0: success; others: failed
 */
int Gm800tfMqttSend(struct Adapter *adapter, const char *topic, const void *buf, size_t len) {
	/* query for whether socket is connected successfully */
    AdapterDeviceNetstat(adapter);
    if (adapter->network_info.mqttIsConnected == 0) {
        printf("[error %s %d]socket has not been connected, please call function AdapterDeviceMqttConnect\n", __func__, __LINE__);
        return -1;
    }

    int ret = 0;
    char result[256] = {};
    uint8_t gm800tf_cmd[64];

    static const char *publishTopics[10] = {NULL};  // save the mqtt publish topics temporarily
    static int topicIndex = 0;                      // the index next mqtt topic to be saved

    /* step0: check if the topic in the topics array */
    for (int i = 0; i < 10; i++) {
        if (publishTopics[i] != NULL && strcmp(publishTopics[i], topic) == 0) {
            char num[10];
            sprintf(num, "%d,", i + 1);
            EntmSend(adapter->agent, num, strlen(num));
            EntmSend(adapter->agent, (const char *)buf, len);
            return 0;
        }
    }
    topicIndex = topicIndex >= 10 ? 0 : topicIndex;
    publishTopics[topicIndex] = topic;  // save the topic to the topics array

	/* step1: serial send "+++" and "a", quit transparent mode */
    ret = Gm800tfEnterAtMode(adapter);
    if (ret < 0) {
        goto out;
    }

    AtSetReplyEndChar(adapter->agent, 'O', 'K');
    AtSetReplyCharNum(adapter->agent, 256);
    AtSetReplyLrEnd(adapter->agent, 0);

    /* step2: serial write "AT+MQTTPUBTP=<pubnum>,<puben>,<topic>,<qos>,<retained>", config the publish parameters */
    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SET_MQTT_PUBPARAM_CMD, topicIndex + 1, 1, topic, 2, 0);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

	/* step3: serial write "AT+S", save the configuration and restart the module */
    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_SAVE_CFG_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(15000);  // after save configuration, wait at least 10s for restarting

	/* step4: send the data to mqtt server */
    char num[10];
    sprintf(num, "%d,", topicIndex + 1);
    EntmSend(adapter->agent, num, strlen(num));
    EntmSend(adapter->agent, buf, len);
    topicIndex++;

    ADAPTER_DEBUG("Gm800tf mqtt send done\n");
    return 0;

out:
    ADAPTER_DEBUG("Gm800tf mqtt send failed.\n");
    return -1;
}

/**
 * @brief  GM800TF only support transparent mode, so the topic is not used. The Message can't be diffrentiated by
 * topic in the received data.
 * @param  adapter
 * @param  topic
 * @param  buf
 * @param  len
 * @return int
 * @note 该函数暂时未经过测试
 */
int Gm800tfMqttRecv(struct Adapter *adapter, const char *topic, void *buf, size_t len) {
    int ret = 0;
    static const char *subscribeTopics[10] = {NULL};
    static int topicIndex = 0;
    uint8_t gm800tf_cmd[64];
    /* check if the topic in the topics array */
    for (int i = 0; i < 10; i++) {
        if (subscribeTopics[i] != NULL && strcmp(subscribeTopics[i], topic) == 0) {
            if (adapter->agent) {
                return EntmRecv(adapter->agent, (char *)buf, len, 6);
            } else {
                printf("Gm800tfRecv can not find agent\n");
                return -1;
            }
        }
    }

    topicIndex = topicIndex >= 10 ? 0 : topicIndex;
    subscribeTopics[topicIndex] = topic;

    ret = Gm800tfEnterAtMode(adapter);
    if (ret < 0) {
        goto out;
    }

    AtSetReplyEndChar(adapter->agent, 'O', 'K');
    AtSetReplyCharNum(adapter->agent, 256);
    AtSetReplyLrEnd(adapter->agent, 0);

    memset(gm800tf_cmd, 0, sizeof(gm800tf_cmd));
    sprintf(gm800tf_cmd, GM800TF_SET_MQTT_SUBPARAM_CMD, topicIndex + 1, 1, topic, 2);
    ret = AtCmdConfigAndCheck(adapter->agent, gm800tf_cmd, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }

    ret = AtCmdConfigAndCheck(adapter->agent, GM800TF_SAVE_CFG_CMD, GM800TF_OK_REPLY);
    if (ret < 0) {
        goto out;
    }
    PrivTaskDelay(15000);  // after save configuration, wait at least 10s for restarting

    if (adapter->agent) {
        return EntmRecv(adapter->agent, (char *)buf, len, 6);
    } else {
        printf("Gm800tfRecv can not find agent\n");
    }
out:
    ADAPTER_DEBUG("Gm800tf mqtt receive failed.\n");
    return -1;
}