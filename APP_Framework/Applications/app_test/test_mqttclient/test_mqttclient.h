/*
 * Copyright (c) 2022 AIIT XUOS Lab
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
 * @file test_mqttclient.h
 * @brief mqtt subscribe fuction test
 * @version 3.0
 * @author AIIT XUOS Lab
 * @date 2023.8.10
 */

#include <stdint.h>

#define   MSG_MAX_LEN     1024
#define   MSG_TOPIC_LEN   50
#define   KEEPLIVE_TIME   650
#define   MQTT_VERSION    4

#ifdef    LWIP_DNS
#define   HOST_NAME       "iot-06z00im0uwa0ki2.mqtt.iothub.aliyuncs.com"     //服务器域名
#else
#define   HOST_NAME       "iot-06z00im0uwa0ki2.mqtt.iothub.aliyuncs.com"     //服务器IP地址
#endif


//#define   HOST_IP       "129.204.201.235"
#define   HOST_PORT     1883    //由于是TCP连接，端口必须是1883

#define   CLIENT_ID     "iw3rn3pa11K.test|securemode=2,signmethod=hmacsha256,timestamp=1689296035604|"         //随机的id
#define   USER_NAME     "test&iw3rn3pa11K"     //用户名
#define   PASSWORD      "7b948d22fe46f0f63d1a403376d26e7cb298abc227d29e44311d7040307a71f8"  //秘钥



#define   TOPIC         "/iw3rn3pa11K/test/user/Test"      //订阅的主题

#define   TEST_MESSAGE  "test_message"  //发送测试消息


// #define   CLIENT_ID     "hc123456789"         //随机的id
// #define   USER_NAME     "xiuos"     //用户名
// #define   PASSWORD      "xiuos"  //秘钥


enum QoS 
{ QOS0 = 0, 
  QOS1, 
  QOS2 
};

enum MQTT_Connect
{
  Connect_OK = 0,
  Connect_NOK,
  Connect_NOTACK
};

//数据交互结构体
typedef struct __MQTTMessage
{
    uint32_t qos;
    uint8_t retained;
    uint8_t dup;
    uint16_t id;
	  uint8_t type;
    void *payload;
    int32_t payloadlen;
}MQTTMessage;

//用户接收消息结构体
typedef struct __MQTT_MSG
{
	  uint8_t  msgqos;                 //消息质量
		uint8_t  msg[MSG_MAX_LEN];       //消息
	  uint32_t msglenth;               //消息长度
	  uint8_t  topic[MSG_TOPIC_LEN];   //主题    
	  uint16_t packetid;               //消息ID
	  uint8_t  valid;                  //标明消息是否有效
}MQTT_USER_MSG;

//发送消息结构体
typedef struct
{
    int8_t topic[MSG_TOPIC_LEN];
    int8_t qos;
    int8_t retained;

    uint8_t msg[MSG_MAX_LEN];
    uint8_t msglen;
} mqtt_recv_msg_t, *p_mqtt_recv_msg_t, mqtt_send_msg_t, *p_mqtt_send_msg_t;