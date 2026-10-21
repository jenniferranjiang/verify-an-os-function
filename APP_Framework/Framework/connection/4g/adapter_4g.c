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
 * @file adapter_4G.c
 * @brief Implement the connection 4G adapter function
 * @version 1.1
 * @author AIIT XUOS Lab
 * @date 2021.06.25
 */

#include <adapter.h>

#ifdef ADAPTER_EC200T
extern AdapterProductInfoType Ec200tAttach(struct Adapter *adapter);
#endif

#ifdef ADAPTER_EC200A
extern AdapterProductInfoType Ec200aAttach(struct Adapter *adapter);
#endif

#ifdef ADAPTER_GM800TF
extern AdapterProductInfoType Gm800tfAttach(struct Adapter *adapter);
#endif

#ifdef ADAPTER_EC801E
extern AdapterProductInfoType Ec801eAttach(struct Adapter *adapter);
#endif

static int Adapter4GRegister(struct Adapter *adapter)
{
    int ret = 0;

    strncpy(adapter->name, ADAPTER_4G_NAME, NAME_NUM_MAX);

    adapter->net_protocol = IP_PROTOCOL;
    adapter->net_role = CLIENT;
    adapter->adapter_status = UNREGISTERED;

    ret = AdapterDeviceRegister(adapter);
    if (ret < 0) {
        printf("Adapter4G register error\n");
        return -1;
    }

    return ret;
}

int Adapter4GInit(void)
{
    int ret = 0;

    struct Adapter *adapter = PrivMalloc(sizeof(struct Adapter));
    if (!adapter) {
        PrivFree(adapter);
        return -1;
    }

    memset(adapter, 0, sizeof(struct Adapter));

    ret = Adapter4GRegister(adapter);
    if (ret < 0) {
        printf("Adapter4GInit register 4G adapter error\n");
        PrivFree(adapter);
        return -1;
    }

#ifdef ADAPTER_EC801E
    AdapterProductInfoType product_info = Ec801eAttach(adapter);
    if (!product_info) {
        printf("Adapter4GInit ec801e attach error\n");
        PrivFree(adapter);
        return -1;
    }

    adapter->product_info_flag = 1;
    adapter->info = product_info;
    adapter->done = product_info->model_done;

#endif

#ifdef ADAPTER_EC200T
    AdapterProductInfoType product_info = Ec200tAttach(adapter);
    if (!product_info) {
        printf("Adapter4GInit ec200t attach error\n");
        PrivFree(adapter);
        return -1;
    }

    adapter->product_info_flag = 1;
    adapter->info = product_info;
    adapter->done = product_info->model_done;

#endif

#ifdef ADAPTER_EC200A
    AdapterProductInfoType product_info = Ec200aAttach(adapter);
    if (!product_info) {
        printf("Adapter4GInit ec200a attach error\n");
        PrivFree(adapter);
        return -1;
    }

    adapter->product_info_flag = 1;
    adapter->info = product_info;
    adapter->done = product_info->model_done;

#endif

#ifdef ADAPTER_GM800TF
    AdapterProductInfoType product_info = Gm800tfAttach(adapter);
    if (!product_info) {
        printf("Adapter4GInit gm800tf attach error\n");
        PrivFree(adapter);
        return -1;
    }

    adapter->product_info_flag = 1;
    adapter->info = product_info;
    adapter->done = product_info->model_done;

#endif

    return ret;
}

/******************4G TEST*********************/
int Adapter4GTest(void)
{
    const char *send_msg = "Adapter_4G Test";
    char recv_msg[256] = {0};
    int baud_rate = BAUD_RATE_115200;

    struct Adapter* adapter = AdapterDeviceFindByName(ADAPTER_4G_NAME);

#ifdef ADAPTER_EC200T
    /* Using Public TCP server to  test 4G Socket connection */
    uint8 server_addr[64] = "120.76.100.197";
    uint8 server_port[64] = "10002";

    adapter->socket.socket_id = 0;

    AdapterDeviceOpen(adapter);
    AdapterDeviceControl(adapter, OPE_INT, &baud_rate);

    AdapterDeviceConnect(adapter, CLIENT, server_addr, server_port, IPV4);

    while (1) {
        AdapterDeviceSend(adapter, send_msg, strlen(send_msg));
        AdapterDeviceRecv(adapter, recv_msg, 256);
        printf("4G recv msg %s\n", recv_msg);
        memset(recv_msg, 0, 256);
    }
#endif

#ifdef ADAPTER_EC200A
    /* Using Public TCP server to  test 4G Socket connection */
    uint8 server_addr[64] = "xyheqmx.e3.luyouxia.net";
    uint8 server_port[64] = "13333";
    uint8 client_id[64] = "quectel";
    uint8 username[64] = "test";
    uint8 password[64] = "test123456";
    uint8 topic_pub[64] = "/reply";
    uint8 topic_sub[64] = "/get";

    adapter->socket.socket_id = 0;

    AdapterDeviceOpen(adapter);
    AdapterDeviceControl(adapter, OPE_INT, &baud_rate);

    AdapterDeviceNetstat(adapter);

    /*4G TCP Connect Test*/
    // AdapterDeviceConnect(adapter, CLIENT, server_addr, server_port, IPV4);

    // while (1) {
    //     AdapterDeviceSend(adapter, send_msg, strlen(send_msg));
    //     AdapterDeviceRecv(adapter, recv_msg, 256);
    //     printf("4G recv msg %s\n", recv_msg);
    //     memset(recv_msg, 0, 256);
    // }

    /*4G MQTT Connect Test*/
    AdapterDeviceMqttConnect(adapter, server_addr, server_port, client_id, username, password);

    while (1) {
        AdapterDeviceMqttSend(adapter, topic_pub, send_msg, strlen(send_msg));
        AdapterDeviceMqttRecv(adapter, topic_sub, recv_msg, 256);
        printf("4G mqtt recv msg %s\n", recv_msg);
        memset(recv_msg, 0, 256);
    }
#endif

#ifdef ADAPTER_EC801E
    /* Using Public TCP server to  test 4G Socket connection */
    uint8 server_addr[64] = "xyheqmx.f1.luyouxia.net";
    uint8 server_port[64] = "17028";
    uint8 client_id[64] = "quectel";
    uint8 username[64] = "test";
    uint8 password[64] = "test123456";
    uint8 topic_pub[64] = "/reply";
    uint8 topic_sub[64] = "/get";

    adapter->socket.socket_id = 0;

    AdapterDeviceOpen(adapter);
    AdapterDeviceControl(adapter, OPE_INT, &baud_rate);

    // AdapterDeviceNetstat(adapter);

    /*4G TCP Connect Test*/
    AdapterDeviceConnect(adapter, CLIENT, server_addr, server_port, IPV4);

    while (1) {
        AdapterDeviceSend(adapter, send_msg, strlen(send_msg));
        AdapterDeviceRecv(adapter, recv_msg, 256);
        printf("4G recv msg %s\n", recv_msg);
        memset(recv_msg, 0, 256);
    }

    /*4G MQTT Connect Test*/
    // AdapterDeviceMqttConnect(adapter, server_addr, server_port, client_id, username, password);

    // while (1) {
    //     AdapterDeviceMqttSend(adapter, topic_pub, send_msg, strlen(send_msg));
    //     AdapterDeviceMqttRecv(adapter, topic_sub, recv_msg, 256);
    //     printf("4G mqtt recv msg %s\n", recv_msg);
    //     memset(recv_msg, 0, 256);
    // }
#endif

#ifdef ADAPTER_GM800TF
	uint8 server_addr[64] = "115.238.53.59";
    uint8 server_port[64] = "10208";

    adapter->socket.socket_id = 0;
    AdapterDeviceOpen(adapter);
    AdapterDeviceControl(adapter, OPE_INT, &baud_rate);
    AdapterDeviceConnect(adapter, CLIENT, server_addr, server_port, IPV4);
	// AdapterDeviceDisconnect(adapter, NULL);
    // AdapterDeviceConnect(adapter, CLIENT, server_addr, server_port, IPV4);
	AdapterDeviceNetstat(adapter);
	
	// char sendData[15] = "Hello World!";
	char sendData = 'a';
	char receiveData = 0;
	int failCount = 0;
	for (int i = 0; i < 1024; i++) { // send 1kB data
		AdapterDeviceSend(adapter, &sendData, 1);
		sendData = sendData + 1 > 'z' ? 'a' : sendData + 1;
	}
	// AdapterDeviceSend(adapter, sendData, 13);
    // while (1) {
	// 	// if (sendData > 'z') {
	// 	// 	break;
	// 	// }
    //     AdapterDeviceSend(adapter, &sendData, 1);
	// 	sendData = sendData + 1 > 'z' ? 'a' : sendData + 1;
    //     // int ret = AdapterDeviceRecv(adapter, &receiveData, 1);
	// 	// printf("receiveData: %d\n", receiveData);
	// 	// if (ret >= 0 && receiveData == sendData) {
	// 	// 	sendData = sendData + 1 > 'z' ? 'a' : sendData + 1;
	// 	// 	failCount = 0;
	// 	// } else {
	// 	// 	failCount++;
	// 	// 	if (failCount >= 10) {
	// 	// 		AdapterDeviceConnect(adapter, CLIENT, server_addr, server_port, IPV4);
	// 	// 		failCount = 0;
	// 	// 	}
	// 	// }
    //     // printf("4G recv msg %c\n", receiveData);
	// 	// receiveData = 0;
    // }
	// PrivTaskDelay(10000);
	AdapterDeviceClose(adapter);
#endif
    return 0;    
}
PRIV_SHELL_CMD_FUNCTION(Adapter4GTest, a LTE adapter sample, PRIV_SHELL_CMD_FUNC_ATTR);

#ifdef ADAPTER_GM800TF
// unsigned char data[1024 * 40];
void *uploadDataTask(void *param) {
    int baud_rate = BAUD_RATE_115200;
    struct Adapter* adapter = AdapterDeviceFindByName(ADAPTER_4G_NAME);
	int reconnectLimit = 3; // try reconnect to server up to 3 times

	uint8 server_addr[64] = "115.238.53.59";
    uint8 server_port[64] = "10208";

    adapter->socket.socket_id = 0;
    AdapterDeviceOpen(adapter);
    AdapterDeviceControl(adapter, OPE_INT, &baud_rate);

	/* try to connect to server */
	do {
        AdapterDeviceConnect(adapter, CLIENT, server_addr, server_port, IPV4);
        AdapterDeviceNetstat(adapter);
		if (adapter->network_info.is_connected && adapter->network_info.signal_strength < 99) {
			break;
		}
    } while (--reconnectLimit > 0);
	if (reconnectLimit <= 0) {
		printf("4G connect to server failed\n");
		AdapterDeviceClose(adapter);
		return NULL;
	}
	
	/* send data to server */
	char sendData[15] = "Hello World!";
	AdapterDeviceSend(adapter, &sendData, 13);
	// char sendData = 'a';
	// char receiveData = 0;
	// int failCount = 0;
	// for (int i = 0; i < 1024; i++) { // send 1kB data
	// 	AdapterDeviceSend(adapter, &sendData, 1);
	// 	sendData = sendData + 1 > 'z' ? 'a' : sendData + 1;
	// }

	AdapterDeviceClose(adapter);
}

void startUploadDataTask(void) {
	pthread_attr_t attr;
    attr.schedparam.sched_priority = 20;
    attr.stacksize = 8096;

    // char task_name[] = "upload_data_task";

	pthread_t thread;
    PrivTaskCreate(&thread, &attr, uploadDataTask, NULL);
	PrivTaskStartup(&thread);
}
#endif
