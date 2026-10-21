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
* @file:    test_lora_net_final.h
* @brief:   Private protocol test function definition
* @version: 0.1
* @author:  YUNFEI CHU
* @date:    2023/10/01 
*
*/

#include <transform.h>
#include <adapter.h>

// #define AS_LORA_GATEWAY

/**
 * @brief: 节点测试函数
 * 1. 打开Lora硬件设施.
 * 2. 连接到网关.
*/
void TestNodeUp(void);

/**
 * @brief: 发送数据
*/
void TestNodeSend(void);

/**
 * @brief: 循环发送数据
*/
void TestNodeSendCycle(void);

/**
 * @brief: 网关测试函数
 * 1. 打开Lora硬件设施.
 * 2. 接入网络.
*/
void TestGateway(void);