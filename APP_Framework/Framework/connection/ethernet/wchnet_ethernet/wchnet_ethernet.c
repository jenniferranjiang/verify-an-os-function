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
 * @file wchnet_ethernet.c
 * @brief Implement the connection ethernet adapter function, using wchnet device
 * @author Huo Yujia (huoyujia081@126.com)
 * @version 1.0
 * @date 2024-07-17
 */

#include <ModuleConfig.h>
#include <adapter.h>
#include <connect_ether.h>
#include <eth_driver.h>

extern pmodule_cfg CFG;  // 从flash中读取的配置信息指针

/* 记录socket会话参数，由于ch32v208内存限制，目前只支持单个会话通信 */
struct WchnetSocketConfiguration wchnetSocketConfiguration;

/**
 * @brief  wchnet主任务线程，主要用于不断处理以太网中断
 * @param  argv   参数无意义
 * @return void*  返回值无意义
 */
static void *wchnetMainTask(void *argv) {
    struct WchnetSocketConfiguration *pWchnetSocketConfiguration = (struct WchnetSocketConfiguration *)argv;
    while (1) {
		PrivTaskDelay(50);
        WCHNET_MainTask();
        if (WCHNET_QueryGlobalInt()) {
            WCHNET_HandleGlobalInt(pWchnetSocketConfiguration);
        }
    }
    return NULL;
}

/**
 * @brief  以太网发送数据
 * @param  adapter
 * @param  data  所要发送数据的存储区域指针
 * @param  len   所要发送数据的长度
 * @return int   实际发送的数据长度
 */
static int wchnetEthernetSend(struct Adapter *adapter, const void *data, size_t len) {
    struct WchnetSocketConfiguration *pWchnetSocketConfiguration =
        (struct WchnetSocketConfiguration *)adapter->adapter_param;

    /* 判断是否可以发送数据 */
    if (pWchnetSocketConfiguration->wchnetMainThread == 0) {  // 判断是否已启动wchnet主任务线程
        printf("[error %s %d]wchnetMainThread has not been started, please call function AdapterDeviceSetUp first\n",
               __func__, __LINE__);
        return -1;
    } else if (pWchnetSocketConfiguration->socketStatus != WCHNET_SOCKET_CONNECT_SUCCESS) {  // 判断是否已连接socket
        printf(
            "[error %s %d]socket has not been connected, please call function AdapterDeviceConnect "
            "first\n",
            __func__, __LINE__);
        return -1;
    }

    /* 发送数据 */
    uint32_t tempLen = (uint32_t)len;  // 实际发送数据长度
    uint8_t res = WCHNET_SocketSend(pWchnetSocketConfiguration->socketId, (uint8_t *)data, &tempLen);
    if (res == WCHNET_ERR_SUCCESS) {
        printf("[socketid-%d]send data success, len = %d\n", adapter->socket.socket_id, tempLen);
        return tempLen;
    } else {
        mStopIfError(res);
        return -1;
    }
}

/**
 * @brief  以太网接收数据
 * @param  adapter
 * @param  rev_buffer 接收数据首地址
 * @param  buffer_len 期望读取的数据长度
 * @return int   实际读取的数据长度
 */
static int wchnetEthernetReceive(struct Adapter *adapter, void *rev_buffer, size_t buffer_len) {
    struct WchnetSocketConfiguration *pWchnetSocketConfiguration =
        (struct WchnetSocketConfiguration *)adapter->adapter_param;

    /* 判断是否可以接收数据 */
    if (pWchnetSocketConfiguration->wchnetMainThread == 0) {  // 判断是否已启动wchnet主任务线程
        printf("[error %s %d]wchnetMainThread has not been started, please call function AdapterDeviceSetUp first\n",
               __func__, __LINE__);
        return -1;
    }

    /* 接收数据 */
    uint32_t tempLen = (uint32_t)buffer_len;  // 实际接收数据长度
    uint8_t res = WCHNET_SocketRecv(pWchnetSocketConfiguration->socketId, (u8 *)rev_buffer, &tempLen);
    if (res == WCHNET_ERR_SUCCESS) {
        printf("[socketid-%d]recv data success, len = %d\n", pWchnetSocketConfiguration->socketId, tempLen);
        return tempLen;
    } else {
        mStopIfError(res);
        return -1;
    }
}

/**
 * @brief  启动wchnet主任务线程，监听以太网中断
 * @param  adapter
 * @return int    0表示线程启动成功，其他表示线程启动失败
 */
static int wchnetEthernetSetUp(struct Adapter *adapter) {
    pthread_attr_t wchnetMainTaskAttr;
    pthread_args_t wchnetMainTaskArgs;
    wchnetMainTaskAttr.schedparam.sched_priority = 16;    // 线程优先级
    wchnetMainTaskAttr.stacksize = 1100;                  // 线程栈大小
    wchnetMainTaskArgs.pthread_name = "wchnetMainTask";   // 线程名字
    wchnetMainTaskArgs.arg = &wchnetSocketConfiguration;  // 线程参数
    int res = PrivTaskCreate(&wchnetSocketConfiguration.wchnetMainThread, &wchnetMainTaskAttr, wchnetMainTask,
                             &wchnetMainTaskArgs);
    PrivTaskStartup(&wchnetSocketConfiguration.wchnetMainThread);
    adapter->adapter_param = &wchnetSocketConfiguration;
    return res;
}

/**
 * @brief  关闭以太网socket连接
 * @param  adapter
 * @return int 0表示关闭以太网socket连接成功，其他表示关闭以太网socket连接失败
 */
static int wchnetEthernetDisconnect(struct Adapter *adapter) {
    struct WchnetSocketConfiguration *pWchnetSocketConfiguration =
        (struct WchnetSocketConfiguration *)adapter->adapter_param;

    /* 判断是否可以关闭socket */
    if (pWchnetSocketConfiguration->wchnetMainThread == 0) {  // 判断是否已启动wchnet主任务线程
        printf("[error %s %d]wchnetMainThread has not been started, please call function AdapterDeviceSetUp first\n",
               __func__, __LINE__);
        return -1;
    } else if (pWchnetSocketConfiguration->socketStatus !=
               WCHNET_SOCKET_CONNECT_SUCCESS) {  // 判断当前是否已有socket连接
        return WCHNET_ERR_SUCCESS;
    }

    /* 将目的IP地址和端口号的数组形式转换成字符串形式和unsigned short形式 */
    char destinationIpAddress[16];  // 目的IP地址
    uint16_t destinationPort;       // 目的端口号
    sprintf(destinationIpAddress, "%u.%u.%u.%u", pWchnetSocketConfiguration->destinationIpAddress[0],
            pWchnetSocketConfiguration->destinationIpAddress[1], pWchnetSocketConfiguration->destinationIpAddress[2],
            pWchnetSocketConfiguration->destinationIpAddress[3]);
    destinationPort =
        (pWchnetSocketConfiguration->destinationPort[1] << 8) + pWchnetSocketConfiguration->destinationPort[0];

    /* 关闭socket连接 */
    uint8_t res = WCHNET_SocketClose(pWchnetSocketConfiguration->socketId, TCP_CLOSE_NORMAL);
    if (res == WCHNET_ERR_SUCCESS) {
        while (pWchnetSocketConfiguration->socketStatus == WCHNET_SOCKET_CONNECT_SUCCESS) {
            PrivTaskDelay(100);  // 每100ms检查一次是否socket关闭完成
        }
        /* socket关闭完成 */
        pWchnetSocketConfiguration->socketStatus = WCHNET_SOCKET_UNDEFINED;
        printf("[socketid-%d]socket with %s:%hu has been disconnected\n", pWchnetSocketConfiguration->socketId,
               destinationIpAddress, destinationPort);
        return WCHNET_ERR_SUCCESS;
    } else {
        mStopIfError(res);
        printf("[socketid-%d]socket with %s:%hu disconnect error\n", pWchnetSocketConfiguration->socketId,
               destinationIpAddress, destinationPort);
        return res;
    }
}

/**
 * @brief  建立以太网socket连接
 * @param  adapter
 * @param  net_role 网络角色，CLIENT或者SERVER
 * @param  ip    目的IP地址字符串
 * @param  port  目的端口号字符串
 * @param  ip_type IP类型，IPV4或者IPV6
 * @return int   0表示建立以太网socket连接成功，其他表示建立以太网socket连接失败
 */
static int wchnetEthernetConnect(struct Adapter *adapter, enum NetRoleType net_role, const char *ip, const char *port,
                                 enum IpType ip_type) {
    struct WchnetSocketConfiguration *pWchnetSocketConfiguration =
        (struct WchnetSocketConfiguration *)adapter->adapter_param;

    /* 由于ch32v208内存限制，当前仅支持IPV4+CLIENT */
    if (ip_type != IPV4) {
        printf("[error %s %d]wchnetEthernetConnect only support IPV4, do not support IPV6\n", __func__, __LINE__);
        return -1;
    } else if (net_role != CLIENT) {
        printf("[error %s %d]wchnetEthernetConnect only support CLIENT, do not support SERVER\n", __func__, __LINE__);
        return -1;
    }

    /* 将IP地址和端口号的字符串形式转换成数组形式 */
    uint8_t destinationIpAddress[4];
    uint8_t destinationPort[2];
    WCHNET_Aton(ip, destinationIpAddress);
    destinationPort[0] = atoi(port) % 256;
    destinationPort[1] = atoi(port) / 256;

    uint8_t res = WCHNET_ERR_SUCCESS;
    if (pWchnetSocketConfiguration->wchnetMainThread == 0) {  // 判断是否已启动wchnet主任务线程
        printf("[error %s %d]wchnetMainThread has not been started, please call function AdapterDeviceSetUp first\n",
               __func__, __LINE__);
        return -1;
    } else if (pWchnetSocketConfiguration->socketStatus ==
               WCHNET_SOCKET_CONNECT_SUCCESS) {  // 判断当前是否已有socket连接
        if (memcmp(destinationIpAddress, pWchnetSocketConfiguration->destinationIpAddress, 4) == 0 &&
            memcmp(destinationPort, pWchnetSocketConfiguration->destinationPort, 2) ==
                0) {  // 当前连接的socket，目的IP地址和端口号完全一致，无需再次连接
            return WCHNET_ERR_SUCCESS;
        } else {  // 当前连接的socket，目的IP地址和端口号不完全一致，由于ch32v208内存限制，当前仅支持单个socket通信，需断开当前连接
            res = wchnetEthernetDisconnect(adapter);
            if (res != WCHNET_ERR_SUCCESS) {
                mStopIfError(res);
                printf("[error %s %d]wchnetEthernetDisconnect fail\n", __func__, __LINE__);
                return res;
            }
        }
    }

    /* 保存目的IP地址和目的端口号 */
    memcpy(pWchnetSocketConfiguration->destinationIpAddress, destinationIpAddress, 4);
    memcpy(pWchnetSocketConfiguration->destinationPort, destinationPort, 2);
    pWchnetSocketConfiguration->socketStatus = WCHNET_SOCKET_UNDEFINED;

    /* 配置socket会话 */
    SOCK_INF TmpSocketInf;
    memset((void *)&TmpSocketInf, 0, sizeof(SOCK_INF));
    memcpy(TmpSocketInf.IPAddr, destinationIpAddress, 4);
    TmpSocketInf.SourPort =
        (pWchnetSocketConfiguration->sourcePort[1] << 8) + pWchnetSocketConfiguration->sourcePort[0];  // 源端口号
    TmpSocketInf.DesPort = (pWchnetSocketConfiguration->destinationPort[1] << 8) +
                           pWchnetSocketConfiguration->destinationPort[0];  // 目的端口号
    TmpSocketInf.ProtoType = PROTO_TYPE_TCP;                                // 协议类型，TCP
    TmpSocketInf.RecvBufLen = RECE_BUF_LEN;                                 // 接收缓冲区大小

    /* 创建socket */
    res = WCHNET_SocketCreat(&pWchnetSocketConfiguration->socketId, &TmpSocketInf);
    if (res == WCHNET_ERR_SUCCESS) {
        printf("[socketid-%d]create socketId %d\r\n", pWchnetSocketConfiguration->socketId,
               pWchnetSocketConfiguration->socketId);
    } else {
        mStopIfError(res);
        printf("[error %s %d]WCHNET_SocketCreat fail\n", __func__, __LINE__);
        return res;
    }

    /* 连接socket */
    res = WCHNET_SocketConnect(pWchnetSocketConfiguration->socketId);
    if (res == WCHNET_ERR_SUCCESS) {
        printf("[socketid-%d]connecting socketId %d\r\n", pWchnetSocketConfiguration->socketId,
               pWchnetSocketConfiguration->socketId);
    } else {
        mStopIfError(res);
        printf("[error %s %d]WCHNET_SocketConnect fail\n", __func__, __LINE__);
        return res;
    }

    /* 每100ms查询一次，直至连接成功或者超时 */
    while (pWchnetSocketConfiguration->socketStatus == WCHNET_SOCKET_UNDEFINED) {
		printf("[socketid-%d]connecting socketId %d\r\n", pWchnetSocketConfiguration->socketId,
               pWchnetSocketConfiguration->socketId);
        PrivTaskDelay(1000);
    }
    if (pWchnetSocketConfiguration->socketStatus == WCHNET_SOCKET_CONNECT_SUCCESS) {
        printf("[socketid-%d]socket connect success\n", pWchnetSocketConfiguration->socketId);
        return res;
    } else if (pWchnetSocketConfiguration->socketStatus == WCHNET_SOCKET_CONNECT_TIMEOUT) {
        printf("[socketid-%d]socket connect timeout\n", pWchnetSocketConfiguration->socketId);
        return -1;
    }
}

/**
 * @brief  设置以太网源IP地址，网关地址，子网掩码
 * @param  adapter
 * @param  ip 源IP地址
 * @param  gateway 网关地址
 * @param  netmask 子网掩码
 * @return int 0表示设置成功，其他表示设置失败
 */
static int wchnetEthernetSetAddr(struct Adapter *adapter, const char *ip, const char *gateway, const char *netmask) {
    struct WchnetSocketConfiguration *pWchnetSocketConfiguration =
        (struct WchnetSocketConfiguration *)adapter->adapter_param;

    /* 判断是否已启动wchnet主任务线程 */
    if (pWchnetSocketConfiguration->wchnetMainThread == 0) {
        printf("[error %s %d]wchnetMainThread has not been started, please call function AdapterDeviceSetUp first\n",
               __func__, __LINE__);
        return -1;
    }

    /* 将地址的字符串形式转化为数组形式 */
    uint8_t sourceIpAddress[4], sourceGateway[4], sourceSubnetMask[4];
    WCHNET_Aton(ip, sourceIpAddress);
    WCHNET_Aton(gateway, sourceGateway);
    WCHNET_Aton(netmask, sourceSubnetMask);

    /* 若配置内容和当前配置保持一致，则无需配置 */
    if (memcmp(sourceIpAddress, pWchnetSocketConfiguration->sourceIpAddress, 4) == 0 &&
        memcmp(sourceGateway, pWchnetSocketConfiguration->sourceGateway, 4) == 0 &&
        memcmp(sourceSubnetMask, pWchnetSocketConfiguration->sourceSubnetMask, 4) == 0) {
        return WCHNET_ERR_SUCCESS;
    }

    /* 若当前有socket正在连接，则需断开socket，再使用新的配置连接socket */
    uint8_t socketExists = pWchnetSocketConfiguration->socketStatus == WCHNET_SOCKET_CONNECT_SUCCESS;
    if (socketExists) {
        wchnetEthernetDisconnect(adapter);
    }

    /* 进行配置，并重新初始化wchnet */
    memcpy(pWchnetSocketConfiguration->sourceIpAddress, sourceIpAddress, 4);
    memcpy(pWchnetSocketConfiguration->sourceGateway, sourceGateway, 4);
    memcpy(pWchnetSocketConfiguration->sourceSubnetMask, sourceSubnetMask, 4);
    uint8_t res = WCHNET_Init(pWchnetSocketConfiguration->sourceIpAddress, pWchnetSocketConfiguration->sourceGateway,
                              pWchnetSocketConfiguration->sourceSubnetMask, pWchnetSocketConfiguration->macAddress);

    if (res == WCHNET_ERR_SUCCESS) {  // 初始化wchnet成功
        pWchnetSocketConfiguration->dhcpSwitch = 0;
        pWchnetSocketConfiguration->dhcpStatus = WCHNET_DHCP_UNDEFINED;
        printf("-*-*-*wchnetEthernetSetAddr*-*-*\n");
        printf("ip:\t%s\ngateway:%s\nnetmask:%s\n", ip, gateway, netmask);
        printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n");
        if (socketExists) {  // 若之前有socket正在连接，则需重新连接
            char destinationIpAddress[16], destinationPort[6];
            sprintf(destinationIpAddress, "%u.%u.%u.%u", pWchnetSocketConfiguration->destinationIpAddress[0],
                    pWchnetSocketConfiguration->destinationIpAddress[1],
                    pWchnetSocketConfiguration->destinationIpAddress[2],
                    pWchnetSocketConfiguration->destinationIpAddress[3]);
            sprintf(
                destinationPort, "%hu",
                (pWchnetSocketConfiguration->destinationPort[1] << 8) + pWchnetSocketConfiguration->destinationPort[0]);
            res = wchnetEthernetConnect(adapter, CLIENT, destinationIpAddress, destinationPort, IPV4);
        }
    }
    mStopIfError(res);
    return res;
}

/**
 * @brief  删除wchnet主任务线程
 * @param  adapter
 * @return int    0表示删除wchnet主任务线程成功，其他表示删除wchnet主任务线程失败
 */
static int wchnetEthernetSetDown(struct Adapter *adapter) {
    struct WchnetSocketConfiguration *pWchnetSocketConfiguration =
        (struct WchnetSocketConfiguration *)adapter->adapter_param;

    /* 如果wchnet主任务线程已经处于关闭状态 */
    if (pWchnetSocketConfiguration->wchnetMainThread == 0) {
        return WCHNET_ERR_SUCCESS;
    }

    uint8_t res = WCHNET_ERR_SUCCESS;

    /* 如果仍有socket未关闭，先关闭socket */
    if (pWchnetSocketConfiguration->socketStatus == WCHNET_SOCKET_CONNECT_SUCCESS) {
        res = wchnetEthernetDisconnect(adapter);
        if (res != WCHNET_ERR_SUCCESS) {
            return res;
        }
    }

    /* 删除wchnet主任务线程 */
    res = PrivTaskDelete(pWchnetSocketConfiguration->wchnetMainThread, 0);
    if (res != 0) {
        printf("wchnet ethernet set down fail\n");
    } else {
        pWchnetSocketConfiguration->wchnetMainThread = 0;
        printf("wchnet ethernet set down success\n");
    }
    return res;
}

/**
 * @brief  设置DHCP
 * @param  adapter
 * @param  enable 0表示关闭DHCP，1表示打开DHCP
 * @return int 0表示设置成功，其他表示设置失败
 * @note   若获得新的动态IP地址，则关闭当前的所有socket连接，并使用新的IP地址建立连接
 * @note   若获得的动态IP地址和当前的IP地址一致，则不进行任何操作，继续使用旧的IP地址进行通信
 * @note   若获取动态IP地址失败，则继续使用旧的IP地址进行通信
 */
static int wchnetEthernetSetDHCP(struct Adapter *adapter, int enable) {
    struct WchnetSocketConfiguration *pWchnetSocketConfiguration =
        (struct WchnetSocketConfiguration *)adapter->adapter_param;

    if (pWchnetSocketConfiguration->wchnetMainThread == 0) {  // 判断是否已启动wchnet主任务线程
        printf("[error %s %d]wchnetMainThread has not been started, please call function AdapterDeviceSetUp first\n",
               __func__, __LINE__);
        return -1;
    }

    uint8_t res;
    switch (enable) {
        /* 关闭DHCP */
        case 0:
            /* 如果原来就没有打开DHCP，无需关闭DHCP */
            if (pWchnetSocketConfiguration->dhcpSwitch == 0) {
                return WCHNET_ERR_SUCCESS;
            }

            /* 重新使用静态IP地址初始化，相当于关闭DHCP */
            res = WCHNET_Init(pWchnetSocketConfiguration->sourceIpAddress, pWchnetSocketConfiguration->sourceGateway,
                              pWchnetSocketConfiguration->sourceSubnetMask, pWchnetSocketConfiguration->macAddress);
            if (res != WCHNET_ERR_SUCCESS) {  // DHCP关闭失败
                mStopIfError(res);
            } else {  // DHCP关闭成功
                pWchnetSocketConfiguration->dhcpSwitch = 0;
                pWchnetSocketConfiguration->dhcpStatus = WCHNET_DHCP_UNDEFINED;
            }
            return res;
            break;

        /* 打开DHCP */
        case 1:
            /* 如果原来已经打开DHCP */
            if (pWchnetSocketConfiguration->dhcpSwitch == 1 &&
                (pWchnetSocketConfiguration->dhcpStatus == WCHNET_DHCP_SUCCESS_NEW ||
                 pWchnetSocketConfiguration->dhcpStatus == WCHNET_DHCP_SUCCESS_OLD)) {
                return WCHNET_ERR_SUCCESS;
            }

            /* 配置DHCP主机名 */
            res = WCHNET_DHCPSetHostname("WCHNET");
            if (res == WCHNET_ERR_SUCCESS) {
                printf("DHCP hostname set success\n");
            } else {
                mStopIfError(res);
                printf("[error %s %d]WCHNET_DHCPSetHostname fail\n", __func__, __LINE__);
            }

            /* 开启DHCP */
            res = WCHNET_DHCPStart(WCHNET_DHCPCallBack);
            if (res == WCHNET_ERR_SUCCESS) {
                pWchnetSocketConfiguration->dhcpStatus = WCHNET_DHCP_UNDEFINED;
                while (pWchnetSocketConfiguration->dhcpStatus == WCHNET_DHCP_UNDEFINED) {
                    PrivTaskDelay(1000);  // 每秒查询一次DHCP状态
                    printf("DHCP finding IP\n");
                }
                WCHNET_DHCPStop();  // 停止DHCP
                switch (pWchnetSocketConfiguration->dhcpStatus) {
                    case WCHNET_DHCP_SUCCESS_NEW:  // 获取到新的动态IP地址，若之前连接过socket，则重新连接该socket
                        pWchnetSocketConfiguration->dhcpSwitch = 1;
                        printf("DHCP set up successfully, getting new IP configuration\n");
                        if (pWchnetSocketConfiguration->socketStatus == WCHNET_SOCKET_CONNECT_SUCCESS) {
                            char destinationIpAddress[16];
                            char destinationPort[6];
                            sprintf(destinationIpAddress, "%u.%u.%u.%u",
                                    pWchnetSocketConfiguration->destinationIpAddress[0],
                                    pWchnetSocketConfiguration->destinationIpAddress[1],
                                    pWchnetSocketConfiguration->destinationIpAddress[2],
                                    pWchnetSocketConfiguration->destinationIpAddress[3]);
                            sprintf(destinationPort, "%hu",
                                    (pWchnetSocketConfiguration->destinationPort[1] << 8) +
                                        pWchnetSocketConfiguration->destinationPort[0]);
                            if (!wchnetEthernetDisconnect(adapter) &&
                                !wchnetEthernetConnect(adapter, CLIENT, destinationIpAddress, destinationPort, IPV4)) {
                                printf("[socketid-%d]DHCP: socket with %s:%s has been reset\n",
                                       pWchnetSocketConfiguration->socketId, destinationIpAddress, destinationPort);
                            } else {
                                printf("[socketid-%d]DHCP: socket with %s:%s reset failed\n",
                                       pWchnetSocketConfiguration->socketId, pWchnetSocketConfiguration->socketId,
                                       destinationIpAddress, destinationPort);
                            }
                        }
                        return WCHNET_ERR_SUCCESS;
                        break;
                    case WCHNET_DHCP_SUCCESS_OLD:  // 获取到旧的动态IP地址
                        pWchnetSocketConfiguration->dhcpSwitch = 1;
                        printf("DHCP set up successfully, getting the same IP configuration\n");
                        return WCHNET_ERR_SUCCESS;
                        break;
                    case WCHNET_DHCP_FAIL:  // 获取动态IP地址错误
                        pWchnetSocketConfiguration->dhcpSwitch = 0;
                        printf("[error %s %d]wchnet dhcp fail\n", __func__, __LINE__);
                        return -1;
                }
            } else {
                mStopIfError(res);
                return res;
            }
            break;
    }
}

static const struct IpProtocolDone wchnet_ethernet_done = {
    .open = NULL,
    .close = NULL,
    .ioctl = NULL,
    .setup = wchnetEthernetSetUp,
    .setdown = wchnetEthernetSetDown,
    .setaddr = wchnetEthernetSetAddr,
    .setdns = NULL,
    .setdhcp = wchnetEthernetSetDHCP,
    .ping = NULL,
    .netstat = NULL,
    .connect = wchnetEthernetConnect,
    .send = wchnetEthernetSend,
    .recv = wchnetEthernetReceive,
    .disconnect = wchnetEthernetDisconnect,
};

/**
 * @description: Register ethernet device wchnet
 * @return success: product_info, failure: NULL
 */
AdapterProductInfoType wchnetEthernetAttach(struct Adapter *adapter) {
    struct AdapterProductInfo *product_info = PrivMalloc(sizeof(struct AdapterProductInfo));
    if (!product_info) {
        printf("wchnetEthernetAttach Attach malloc product_info error\n");
        PrivFree(product_info);
        return NULL;
    }

    strcpy(product_info->model_name, ADAPTER_ETHERNET_WCHNET);

    product_info->model_done = (void *)&wchnet_ethernet_done;

    return product_info;
}
