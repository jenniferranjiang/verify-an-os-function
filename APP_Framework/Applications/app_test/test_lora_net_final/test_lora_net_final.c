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
* @file:    test_lora_net_final.c
* @brief:   Private protocol test functions
* @version: 0.1
* @author:  YUNFEI CHU
* @date:    2023/10/01 
*
*/

#include "test_lora_net_final.h"

#ifdef AS_LORA_GATEWAY

/**
 * @brief: 网关测试函数
 * 1. 打开Lora硬件设施.
 * 2. 接入网络.
*/
void TestGateway(void)
{
    struct Adapter* gateway_adapter = (struct Adapter*)AdapterDeviceFindByName(ADAPTER_LORA_NAME);
    // 打开设备
    if (0 != AdapterDeviceOpen(gateway_adapter))
    {
        printf("TestGateway-Fail: open lora fail!\n");
        return;
    }
    printf("TestGateway-Info: open lora success!\n");
    // 接入网络
    if (0 != AdapterDeviceSetUp(gateway_adapter))
    {
        printf("TestGateway-Fail: setup net fail!\n");
        return;
    }
    printf("TestGateway-Success: gateway set up success!\n");
    AdapterDeviceNetstat(gateway_adapter);
}
PRIV_SHELL_CMD_FUNCTION(TestGateway,TestGateway, PRIV_SHELL_CMD_MAIN_ATTR);

/**
 * 打印网关信息
*/
void TestGatewayInfo(void)
{
    struct Adapter* gateway_adapter = (struct Adapter*)AdapterDeviceFindByName(ADAPTER_LORA_NAME);
    AdapterDeviceNetstat(gateway_adapter);
}
PRIV_SHELL_CMD_FUNCTION(TestGatewayInfo,TestGatewayInfo, PRIV_SHELL_CMD_MAIN_ATTR);

#else

/**
 * @brief: 节点测试函数
 * 1. 打开Lora硬件设施.
 * 2. 连接到网关.
*/
void TestNodeUp(void)
{
    struct Adapter* node_adapter = (struct Adapter*)AdapterDeviceFindByName(ADAPTER_LORA_NAME);
    // 打开设备
    if (0 != AdapterDeviceOpen(node_adapter))
    {
        printf("TestNodeUp-Fail: open lora fail!\n");
        return;
    }
    AdapterDeviceNetstat(node_adapter);
    // 接入网络
    uint8 net_id = 0XA;
    if (0 != AdapterDeviceJoin(node_adapter,&net_id))
    {
        printf("TestNodeUp-Fail: join net fail!\n");
        return;
    }
    AdapterDeviceNetstat(node_adapter);
}
PRIV_SHELL_CMD_FUNCTION(TestNodeUp,TestNodeUp, PRIV_SHELL_CMD_MAIN_ATTR);

/**
 * @brief: 发送数据
*/
void TestNodeSend(void)
{
    char* data = "Hello,Gateway-OtherNode!";
    struct Adapter* node_adapter = (struct Adapter*)AdapterDeviceFindByName(ADAPTER_LORA_NAME);
    AdapterDeviceSend(node_adapter,data,strlen(data));
    AdapterDeviceNetstat(node_adapter);
}
PRIV_SHELL_CMD_FUNCTION(TestNodeSend,TestNodeSend, PRIV_SHELL_CMD_MAIN_ATTR);

/**
 * @brief: 循环发送数据
*/
void TestNodeSendCycle(void)
{
    int cycle_count = 5;
    char* data = "Hello,Gateway-OtherNode-Cycle!";
    struct Adapter *node_adapter = (struct Adapter *)AdapterDeviceFindByName(ADAPTER_LORA_NAME);
    while (cycle_count -- > 0)
    {
        AdapterDeviceSend(node_adapter, data, strlen(data));
        AdapterDeviceNetstat(node_adapter);
    }
}
PRIV_SHELL_CMD_FUNCTION(TestNodeSendCycle,TestNodeSendCycle, PRIV_SHELL_CMD_MAIN_ATTR);
#endif