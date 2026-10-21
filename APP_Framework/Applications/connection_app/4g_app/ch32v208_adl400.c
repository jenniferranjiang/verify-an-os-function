/**
 * @file ch32v208_adl400.c
 * @brief ch32v208 board gets data from Acrel-ADL400 electricity meter with rs485 bus,
 * and then sends it to the server with 4G.
 * @author Huo Yujia (huoyujia081@126.com)
 * @version 1.0
 * @date 2024-07-10
 */

#include <ModuleConfig.h>
#include <adapter.h>
#include <transform.h>
#define MAX_FRAME_SIZE 256                      // 最大帧大小
#define MAX_BUFFER_SIZE 1024 * 2                // 最大缓冲区大小
#define RECEIVE_DATA_INTERVAL_MS 1000 * 60 * 2  // ADL400数据采集间隔时间，单位为毫秒
#define RESEND_COUNT 3                          // 最大帧重发次数
#define RECONNECT_COUNT 5                       // 最大连接次数
#define WATING_RESPONSE_MS 5000                 // 等待响应时间，单位为毫秒

/**
 * @brief  生成Modbus RTU请求帧中的CRC循环冗余码
 * @param  CRC_Ptr
 * @param  LEN 需要生成CRC冗余码的数据长度
 * @return uint16_t 以小端顺序返回CRC循环冗余码
 */
static uint16_t generateCRC(uint8_t *CRC_Ptr, uint8_t LEN) {
    uint16_t CRC_Value = 0;
    uint8_t i = 0;
    uint8_t j = 0;

    CRC_Value = 0xffff;
    for (i = 0; i < LEN; i++)  // LEN为数组长度
    {
        CRC_Value ^= *(CRC_Ptr + i);
        for (j = 0; j < 8; j++) {
            if (CRC_Value & 0x00001)
                CRC_Value = (CRC_Value >> 1) ^ 0xA001;
            else
                CRC_Value = (CRC_Value >> 1);
        }
    }
    CRC_Value = ((CRC_Value >> 8) + (CRC_Value << 8));  // 交换高低字节

    return CRC_Value;
}

/**
 * @brief  生成Modbus RTU请求帧，用于获取指定寄存器的值
 * @param  address 请求的Modbus地址
 * @param  functionCode 功能码
 * @param  startAddress 数据起始地址
 * @param  quantity 数据读取个数
 * @param  modbusRtuRequestFrame 生成的ModBus RTU请求帧数组
 * @param  requestFrameArrLength 生成的ModBus RTU请求帧数组长度，固定为8
 * @return int   0表示生成成功，其他结果表示生成失败
 * @note   Modbus
 * RTU请求帧格式：地址（1字节）+功能码（1字节）+数据起始地址（2字节）+数据读取个数（2字节）+校验码（2字节）
 */
static int generateRequestFrame(unsigned char address, unsigned char functionCode, unsigned short startAddress, unsigned short quantity,
                                unsigned char modbusRtuRequestFrame[], int requestFrameArrLength) {
    if (requestFrameArrLength != 8) {
        printf("the length of request frame array is not 8\n");
        return -1;
    }
    modbusRtuRequestFrame[0] = address;
    modbusRtuRequestFrame[1] = functionCode;
    modbusRtuRequestFrame[2] = (startAddress >> 8) & 0xff;
    modbusRtuRequestFrame[3] = startAddress & 0xff;
    modbusRtuRequestFrame[4] = (quantity >> 8) & 0xff;
    modbusRtuRequestFrame[5] = quantity & 0xff;
    modbusRtuRequestFrame[6] = (generateCRC(modbusRtuRequestFrame, 6) >> 8) & 0xff;
    modbusRtuRequestFrame[7] = generateCRC(modbusRtuRequestFrame, 6) & 0xff;
    return 0;
}

/**
 * @brief  将要上传服务器的数据帧
 */
struct DataFrame {
    unsigned char id[13];  // 用响应的时间戳作为数据帧的id
    unsigned char data[MAX_FRAME_SIZE];  // 上传服务器的数据帧字符串，前12字节表示数据帧id。字符串格式：数据帧id,数据1,数据2,数据3...
};

/**
 * @brief  Modbus RTU响应数据帧的缓存，使用循环队列作为数据结构
 */
struct QueueBuffer {
    struct DataFrame *buffer[MAX_BUFFER_SIZE / sizeof(struct DataFrame)];  // 循环队列存储空间，使用数组存储
    int front;                                                             // 循环队列队头
    int rear;                                                              // 循环队列队尾
    pthread_mutex_t mutex;                                                 // 互斥访问循环队列信号量
    sem_t full;                                                            // 循环队列中有效成员个数的信号量
};

#define BUFFER_ELEM_COUNT (MAX_BUFFER_SIZE / sizeof(struct DataFrame))  // 循环队列中可以容纳的最大成员个数

/**
 * @brief  初始化循环队列
 * @param  pQueueBuffer 循环队列指针
 * @return * int  0表示初始化成功，其他表示初始化失败
 */
static int initBuffer(struct QueueBuffer *pQueueBuffer) {
    pQueueBuffer->front = 0;
    pQueueBuffer->rear = 0;
    if (PrivMutexCreate(&pQueueBuffer->mutex, 0) < 0) {
        printf("buffer mutex create failed.\n");
        return -1;
    }
    if (PrivSemaphoreCreate(&pQueueBuffer->full, 0, 0) < 0) {
        printf("buffer full semaphore create failed.\n");
        return -1;
    }
    return 0;
}

/**
 * @brief  循环队列入队，如果循环队列已满，则将最旧的成员出队后，新成员再入队
 * @param  pQueueBuffer 循环队列指针
 * @param  pDataFrame ADL400响应数据帧
 * @return int 0表示入队成功，其他表示入队失败
 */
static int offerBuffer(struct QueueBuffer *pQueueBuffer, struct DataFrame *pDataFrame) {
    /* 循环队列已满，将最旧的成员出队 */
    if ((pQueueBuffer->rear + 1) % BUFFER_ELEM_COUNT == pQueueBuffer->front) {
        struct DataFrame *frontDataFrame = pQueueBuffer->buffer[pQueueBuffer->front];
        PrivFree(frontDataFrame);
        pQueueBuffer->front = (pQueueBuffer->front + 1) % BUFFER_ELEM_COUNT;
    }
    /* 新成员入队 */
    pQueueBuffer->buffer[pQueueBuffer->rear] = pDataFrame;
    pQueueBuffer->rear = (pQueueBuffer->rear + 1) % BUFFER_ELEM_COUNT;
    printf("front: %d\n", pQueueBuffer->front);
    printf("rear: %d\n", pQueueBuffer->rear);
    return 0;
}

/**
 * @brief  循环队列出队，如果队列为空则返回NULL
 * @param  pQueueBuffer 循环队列指针
 * @return struct DataFrame* 出队成员，如果队列为空则返回NULL
 */
static struct DataFrame *pollBuffer(struct QueueBuffer *pQueueBuffer) {
    /* 队列为空，返回NULL */
    if (pQueueBuffer->front == pQueueBuffer->rear) {
        return NULL;
    }
    /* 最旧的成员出队 */
    struct DataFrame *pFrontDataFrame = pQueueBuffer->buffer[pQueueBuffer->front];
    pQueueBuffer->buffer[pQueueBuffer->front] = NULL;
    pQueueBuffer->front = (pQueueBuffer->front + 1) % BUFFER_ELEM_COUNT;
    printf("front: %d\n", pQueueBuffer->front);
    printf("rear: %d\n", pQueueBuffer->rear);
    return pFrontDataFrame;
}

/**
 * @brief  查看队头元素，如果队列为空则返回NULL
 * @param  pQueueBuffer 循环队列指针
 * @return struct DataFrame* 队头元素，如果队列为空则返回NULL
 */
static struct DataFrame *peekBuffer(struct QueueBuffer *pQueueBuffer) {
    /* 如果队列为空，返回NULL */
    if (pQueueBuffer->front == pQueueBuffer->rear) {
        return NULL;
    }
    /* 返回队头元素，但不出队 */
    return pQueueBuffer->buffer[pQueueBuffer->front];
}

/**
 * @brief  改写PrivRead函数，原有函数只会读取接收缓冲区的当前已有字节，新函数会读取指定字节数再返回
 * @param  fd 文件描述符
 * @param  buf 数据读取到的位置
 * @param  len 读取的指定字节数
 * @return int 如果读取到指定字节数返回0；如果到达WATING_RESPONSE_MS仍未读取到指定字节数，或者读数据错误，返回-1
 */
static int privReadEnoughData(int fd, void *buf, size_t len) {
    char *buffer = (char *)buf;           // 将接收的存储空间指针强制转型
    int gottenBytes = 0;                  // 已经读取到的字节数
    int remainTime = WATING_RESPONSE_MS;  // 剩余的时间

    /* 只有接收的字节数不够，并且还有剩余时间，才可以继续读取 */
    while (gottenBytes < len && remainTime > 0) {
        int bytes = PrivRead(fd, buffer + gottenBytes, len - gottenBytes);  // 从设备读取
        if (bytes > 0) {
            gottenBytes += bytes;  // 读取到字节
        } else if (bytes < 0) {
            printf("Error reading from serial port\n");
            return -1;  // 读取错误
        }
        PrivTaskDelay(100);  // 每100ms读取一次
        remainTime -= 100;   // 剩余时间减去100ms
    }
    /* 若没有剩余时间，表示还没有读取到指定的字节数，返回-1；若有剩余时间，表示已经读取了指定的字节数，返回0 */
    return remainTime < 0 ? -1 : 0;
}

/**
 * @brief  解析ADL400响应的Modbus RTU数据帧
 * @param  modbusRtuResponseFrame0 请求数据后ADL400的响应帧
 * @param  modbusRtuResponseFrame1 请求时间戳后ADL400的响应帧
 * @param  modbusRtuResponseFrame2 请求电流电压比后ADL400的响应帧
 * @param  pDataFrame 将要上传给服务器的数据帧，包括id和数据
 */
static void parseModBusRtuResponseFrame(unsigned char *modbusRtuResponseFrame0, unsigned char *modbusRtuResponseFrame1,
                                        unsigned char *modbusRtuResponseFrame2, struct DataFrame *pDataFrame) {
    /* 从frame2中获取电压变比pt和电流变比ct */
    unsigned char *p = modbusRtuResponseFrame2;
    int pt = (unsigned short)modbusRtuResponseFrame2[3] << 8 | (unsigned short)modbusRtuResponseFrame2[4];
    int ct = (unsigned short)modbusRtuResponseFrame2[5] << 8 | (unsigned short)modbusRtuResponseFrame2[6];

    /* 从frame1中获取时间戳，即数据帧的id */
    for (int i = 8; i >= 3; i--) {
        sprintf(pDataFrame->id, "%s%02x", pDataFrame->id, modbusRtuResponseFrame1[i]);
        sprintf(pDataFrame->data, "%s%02x", pDataFrame->data, modbusRtuResponseFrame1[i]);
    }

    /* 从frame0中获取要上传到服务器的ADL400的数据 */
    for (int i = 3; i < modbusRtuResponseFrame0[2] + 3; i += 4) {
        int originalData = (unsigned int)modbusRtuResponseFrame0[i] << 24 | (unsigned int)modbusRtuResponseFrame0[i + 1] << 16 |
                           (unsigned int)modbusRtuResponseFrame0[i + 2] << 8 | (unsigned int)modbusRtuResponseFrame0[i + 3];
        sprintf(pDataFrame->data, "%s,%d", pDataFrame->data, originalData);  // 将数据拼接到字符串
    }

    strcat(pDataFrame->data, "\n");  // 字符串末尾添加换行符，表示数据帧结束
}

/**
 * @brief  从ADL400接收数据的线程
 * @param  arg   循环队列指针
 * @return void* 目前返回值无意义
 */
static void *receiveDataFromADL400Task(void *arg) {
    struct QueueBuffer *pQueueBuffer = (struct QueueBuffer *)arg;  // 循环队列指针
    int fd = PrivOpen("/dev/rs485_dev1", O_RDWR);                  // 打开设备文件
    if (fd < 0) {                                                  // 打开设备文件失败，打印错误信息
        printf("open rs485 fd error: %d\n", fd);
        return NULL;
    }

    struct SerialDataCfg rs485Configuration;
    memset(&rs485Configuration, 0, sizeof(struct SerialDataCfg));
    /* 读取RS485配置信息 */
    PrivMutexObtain(&romConfigurationMutex);  // 若其他线程正在读取或者写入CFG，则阻塞等待
    int baudRatesOption = CFG->baudRate_Rs485;
    int dataBitsOption = CFG->dataBits_Rs485;
    int stopBitsOption = CFG->stopBits_Rs485;
    int parityOption = CFG->parity_Rs485;
    PrivMutexAbandon(&romConfigurationMutex);  // 释放互斥锁
    switch (baudRatesOption) {
        case 1:
            rs485Configuration.serial_baud_rate = BAUD_RATE_2400;
            break;
        case 2:
            rs485Configuration.serial_baud_rate = BAUD_RATE_4800;
            break;
        case 3:
            rs485Configuration.serial_baud_rate = BAUD_RATE_9600;
            break;
        case 4:
            rs485Configuration.serial_baud_rate = BAUD_RATE_19200;
            break;
        case 5:
            rs485Configuration.serial_baud_rate = BAUD_RATE_38400;
            break;
        case 6:
            rs485Configuration.serial_baud_rate = BAUD_RATE_57600;
            break;
        case 7:
            rs485Configuration.serial_baud_rate = BAUD_RATE_115200;
            break;
        case 8:
            rs485Configuration.serial_baud_rate = BAUD_RATE_230400;
            break;
        default:
            rs485Configuration.serial_baud_rate = BAUD_RATE_9600;
            break;
    }
    switch (dataBitsOption) {
        case 1:
            rs485Configuration.serial_data_bits = DATA_BITS_8;
            break;
        case 2:
            rs485Configuration.serial_data_bits = DATA_BITS_9;
            break;
        default:
            rs485Configuration.serial_data_bits = DATA_BITS_8;
            break;
    }
    switch (stopBitsOption) {
        case 1:
            rs485Configuration.serial_stop_bits = STOP_BITS_1;
            break;
        case 2:
            rs485Configuration.serial_stop_bits = STOP_BITS_2;
            break;
        default:
            rs485Configuration.serial_stop_bits = STOP_BITS_1;
            break;
    }
    switch (parityOption) {
        case 1:
            rs485Configuration.serial_parity_mode = PARITY_NONE;
            break;
        case 2:
            rs485Configuration.serial_parity_mode = PARITY_ODD;
            break;
        case 3:
            rs485Configuration.serial_parity_mode = PARITY_EVEN;
            break;
    }
    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = (void *)&rs485Configuration;
    if (0 != PrivIoctl(fd, OPE_INT, &ioctl_cfg)) {
        printf("ioctl uart fd error %d\n", fd);
        PrivClose(fd);
        return NULL;
    }

    unsigned char modbusRtuRequestFrame[8];      // 定义Modbus RTU请求帧
    unsigned char modBusRtuResponseFrame0[256];  // 定义Modbus RTU响应帧0
    unsigned char modBusRtuResponseFrame1[256];  // 定义Modbus RTU响应帧1
    unsigned char modBusRtuResponseFrame2[32];   // 定义Modbus RTU响应帧2
    while (1) {
        /* 生成Modbus RTU请求帧0，用于请求ADL400数据 */
        if (generateRequestFrame(0x93, 0x03, 0x0000, 0x003C, modbusRtuRequestFrame, sizeof(modbusRtuRequestFrame)) < 0) {
            break;  // 生成请求帧失败，退出循环
        }
        PrivWrite(fd, modbusRtuRequestFrame, sizeof(modbusRtuRequestFrame));  // 发送Modbus RTU请求帧
        /* 读取Modbus RTU响应帧0数据 */
        if (privReadEnoughData(fd, modBusRtuResponseFrame0, 5 + (0x003C << 1)) < 0) {
            printf("read data from adl400 time out\n");  // 读取超时，打印错误信息
            break;                                       // 读取失败，退出循环
        }

        /* 生成Modbus RTU请求帧1，用于请求时间戳 */
        if (generateRequestFrame(0x93, 0x03, 0x003C, 0x0003, modbusRtuRequestFrame, sizeof(modbusRtuRequestFrame)) < 0) {
            break;  // 生成请求帧失败，退出循环
        }
        PrivWrite(fd, modbusRtuRequestFrame, sizeof(modbusRtuRequestFrame));  // 发送Modbus RTU请求帧
        /* 读取Modbus RTU响应帧1数据 */
        if (privReadEnoughData(fd, modBusRtuResponseFrame1, 5 + (0x0003 << 1)) < 0) {
            printf("read data from adl400 time out\n");  // 读取超时，打印错误信息
            break;                                       // 读取失败，退出循环
        }

        /* 生成Modbus RTU请求帧2，用于请求电压电流变比 */
        if (generateRequestFrame(0x93, 0x03, 0x008D, 0x0002, modbusRtuRequestFrame, sizeof(modbusRtuRequestFrame)) < 0) {
            break;  // 生成请求帧失败，退出循环
        }
        PrivWrite(fd, modbusRtuRequestFrame, sizeof(modbusRtuRequestFrame));  // 发送Modbus RTU请求帧
        /* 读取Modbus RTU响应帧2 */
        if (privReadEnoughData(fd, modBusRtuResponseFrame2, 5 + (0x0002 << 1)) < 0) {
            printf("read data from adl400 time out\n");  // 读取超时，打印错误信息
            break;                                       // 读取失败，退出循环
        }

        /* 解析Modbus RTU响应帧 */
        struct DataFrame *pDataFrame = (struct DataFrame *)PrivMalloc(sizeof(struct DataFrame));
        memset(pDataFrame, 0, sizeof(struct DataFrame));
        parseModBusRtuResponseFrame(modBusRtuResponseFrame0, modBusRtuResponseFrame1, modBusRtuResponseFrame2, pDataFrame);

        /* 将解析后的数据帧放入循环队列 */
        PrivMutexObtain(&pQueueBuffer->mutex);                         // 获取互斥锁
        offerBuffer(pQueueBuffer, pDataFrame);                         // 将数据帧放入队列
        printf("receive data from ADL400, id: %s\n", pDataFrame->id);  // 打印接收到的数据帧ID
        PrivMutexAbandon(&pQueueBuffer->mutex);                        // 释放互斥锁
        PrivSemaphoreAbandon(&pQueueBuffer->full);  // 释放信号量，即告知发送数据线程，队列中有新的数据帧

        PrivTaskDelay(RECEIVE_DATA_INTERVAL_MS);  // 延迟一段时间再读取下一帧数据
    }

    PrivClose(fd);  // 关闭设备文件
    return NULL;
}

/**
 * @brief 通过4G向服务器发送数据的线程
 * @param arg 循环队列指针
 * @return void* 目前返回值无意义
 */
static void *sendDataToServerTask_4G(void *arg) {
    uint8_t serverIpAddress[16] = {};                              // 目的IP地址
    uint8_t serverPort[6] = {};                                    // 目的端口号
    struct QueueBuffer *pQueueBuffer = (struct QueueBuffer *)arg;  // 循环队列指针
    unsigned char receiveBuffer[256];                              // 从服务器接收每帧响应的存储空间

    struct Adapter *adapter = AdapterDeviceFindByName(ADAPTER_4G_NAME);  // 查找4G模块适配器

    AdapterDeviceOpen(adapter);                          // 打开适配器对应的设备（实际打开串口中断）
    int baud_rate = BAUD_RATE_115200;                    // 波特率，用于设置4G模块串口
    AdapterDeviceControl(adapter, OPE_INT, &baud_rate);  // 对适配器对应设备进行配置（实际配置波特率）

    struct DataFrame *pDataFrame = NULL;  // 数据帧定义
    while (1) {
        PrivSemaphoreObtainWait(&pQueueBuffer->full, NULL);  // 尝试获取循环队列队头元素，如果获取信号量失败，则等待信号量
#ifdef BSP_BLE_CONFIG                                        // 如果启用了BLE配置功能
        /* 获取互斥锁 */
        PrivMutexObtain(&adapter->lock);          // 若其他线程正在使用adapter，则阻塞等待
        PrivMutexObtain(&romConfigurationMutex);  // 若其他线程正在读取或者写入CFG，则阻塞等待

        /* 尝试连接服务器 */
        sprintf(serverIpAddress, "%u.%u.%u.%u", CFG->destinationIpAddress_4G[0], CFG->destinationIpAddress_4G[1],
                CFG->destinationIpAddress_4G[2], CFG->destinationIpAddress_4G[3]);
        sprintf(serverPort, "%u", (unsigned short)CFG->destinationPort_4G[0] | CFG->destinationPort_4G[1] << 8);
        printf("-*-*-*-*sendDataToServerTask_4G*-*-*-*\n");
        printf("serverIpAddress:\t%s\n", serverIpAddress);
        printf("serverPort:\t\t%s\n", serverPort);
        printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n");
        if (CFG->mqttSwitch_4G == 1) {  // 如果使能MQTT
            AdapterDeviceMqttConnect(adapter, serverIpAddress, serverPort, CFG->mqttClientId_4G, CFG->mqttUsername_4G,
                                     CFG->mqttPassword_4G);
        } else {  // 如果禁用MQTT
            AdapterDeviceConnect(adapter, CLIENT, serverIpAddress, serverPort, IPV4);
        }

        AdapterDeviceNetstat(adapter);  // 读取网络连接状态
        /* 若连接失败，则等待10s再次尝试连接 */
        if (CFG->mqttSwitch_4G == 0 && !adapter->network_info.is_connected ||
            CFG->mqttSwitch_4G == 1 && !adapter->network_info.mqttIsConnected) {
            PrivSemaphoreAbandon(&pQueueBuffer->full);  // 释放信号量
            /* 释放互斥锁 */
            PrivMutexAbandon(&romConfigurationMutex);
            PrivMutexAbandon(&adapter->lock);
            printf("4G connect to server failed\n");  // 连接失败，打印错误信息
            PrivTaskDelay(1000 * 10);                 // 延迟10秒，避免网络拥塞
            continue;
        }
#else  // 如果没有启用BLE配置功能
        /* 尝试连接到服务器 */
        sprintf(serverIpAddress, "%u.%u.%u.%u", CFG->destinationIpAddress_4G[0], CFG->destinationIpAddress_4G[1],
                CFG->destinationIpAddress_4G[2], CFG->destinationIpAddress_4G[3]);
        sprintf(serverPort, "%u", (unsigned short)CFG->destinationPort_4G[0] | CFG->destinationPort_4G[1] << 8);
        printf("-*-*-*-*sendDataToServerTask_4G*-*-*-*\n");
        printf("serverIpAddress:\t%s\n", serverIpAddress);
        printf("serverPort:\t\t%s\n", serverPort);
        printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n");
        int reconnectCount = RECONNECT_COUNT;  // 尝试重新连接服务器最多RECONNECT_COUNT次
        while (reconnectCount > 0) {
            int res;
            if (CFG->mqttSwitch_4G == 1) {
                res = AdapterDeviceMqttConnect(adapter, mqttServerIp, mqttServerPort, CFG->mqttClientId_4G, CFG->mqttUsername_4G,
                                               CFG->mqttPassword_4G);
            } else {
                res = AdapterDeviceConnect(adapter, CLIENT, serverIpAddress, serverPort, IPV4);
            }
            if (res == 0) {
                break;
            }
            reconnectCount--;
        }
        if (reconnectCount <= 0) {                      // 若RECONNECT_COUNT次都连接失败，则等待10s再次尝试连接
            PrivSemaphoreAbandon(&pQueueBuffer->full);  // 释放信号量
            printf("4G connect to server failed\n");    // 连接失败，打印错误信息
            PrivTaskDelay(1000 * 10);                   // 延迟10秒，避免网络拥塞
            continue;
        }
#endif
        PrivMutexObtain(&pQueueBuffer->mutex);   // 获取互斥锁
        pDataFrame = pollBuffer(pQueueBuffer);   // 从队列中获取数据帧
        PrivMutexAbandon(&pQueueBuffer->mutex);  // 释放互斥锁

        int resendCount = RESEND_COUNT;                  // 定义数据帧重发次数
        while (pDataFrame != NULL && resendCount > 0) {  // 只有数据帧非空并且还有剩余重发次数，才进行发送
            /* 向服务器发送数据 */
            printf("pDataFrame->data: %s", pDataFrame->data);
            printf("send data to server, id: %s\n", pDataFrame->id);
            if (CFG->mqttSwitch_4G == 1) { // MQTT模式下，无需服务器响应数据
                AdapterDeviceMqttSend(adapter, CFG->mqttTopic_4G, pDataFrame->data,
                                      strlen(pDataFrame->data));  // 发送数据，注意当前最多发送256字节
                break;
            } else {
                AdapterDeviceSend(adapter, pDataFrame->data,
                                  strlen(pDataFrame->data));  // 发送数据，注意当前最多发送256字节

                /* 从服务器接收响应，约定服务器接收完数据帧后，返回数据帧中的前12个字节，即数据帧id */
                /* 多读取2字节，是为了防止前面还有命令模式返回的剩余的\r\n影响判断 */
                memset(receiveBuffer, 0, sizeof(receiveBuffer));
                int receiveLength = AdapterDeviceRecv(adapter, receiveBuffer, strlen(pDataFrame->id) + 2);
                if (receiveLength == strlen(pDataFrame->id) + 2 || receiveLength == strlen(pDataFrame->id)) {
                    /* 打印服务器响应 */
					printf("receiveLength: %d\n", receiveLength);
                    printf("receiveBuffer: ");
                    for (int i = 0; i < receiveLength; i++) {
                        printf("%c", receiveBuffer[i]);
                    }
                    printf("\n");
                    /* 比较服务器响应的内容与发送的数据帧id是否一致 */
                    if (strstr(receiveBuffer, pDataFrame->id) != NULL) {
                        break;  // 接收成功，退出循环
                    }
                } else {
					printf("receiveLength: %d\n", receiveLength);
					printf("receiveBuffer: ");
                    for (int i = 0; i < receiveLength; i++) {
                        printf("%d ", receiveBuffer[i]);
                    }
                    printf("\n");
				}
            }
            resendCount--;
        }
        if (pDataFrame != NULL) {
            PrivFree(pDataFrame);  // 释放数据帧内存
            pDataFrame = NULL;     // 避免野指针
        }
        // AdapterDeviceDisconnect(adapter, NULL);  // 关闭适配器对应的设备
#ifdef BSP_BLE_CONFIG
        /* 释放互斥锁 */
        PrivMutexAbandon(&romConfigurationMutex);
        PrivMutexAbandon(&adapter->lock);
#endif
        if (resendCount <= 0) {        // 如果数据帧重发次数超过上限，表示发送失败，丢弃该帧
            PrivTaskDelay(1000 * 10);  // 延迟10秒，避免网络拥塞
        }
    }
    return NULL;
}

/**
 * @brief 通过以太网向服务器发送数据的线程
 * @param arg 循环队列指针
 * @return void* 目前返回值无意义
 */
static void *sendDataToServerTask_Ethernet(void *arg) {
    uint8_t serverIpAddress[16] = {};                              // 目的IP地址
    uint8_t serverPort[6] = {};                                    // 目的端口号
    struct QueueBuffer *pQueueBuffer = (struct QueueBuffer *)arg;  // 循环队列指针
    unsigned char receiveBuffer[256];                              // 从服务器接收每帧响应的存储空间

    struct Adapter *adapter = AdapterDeviceFindByName(ADAPTER_ETHERNET_NAME);  // 查找以太网模块适配器

#ifndef BSP_BLE_CONFIG                                        // 如果没有使能蓝牙配置功能
    AdapterDeviceSetUp(adapter);                              // 启动以太网主任务线程
    AdapterDeviceSetDhcp(adapter, CFG->dhcpSwitch_Ethernet);  // 启用或禁用DHCP
#endif

    struct DataFrame *pDataFrame = NULL;  // 数据帧定义
    while (1) {
        PrivSemaphoreObtainWait(&pQueueBuffer->full, NULL);  // 尝试获取循环队列队头元素，如果获取信号量失败，则等待信号量
#ifdef BSP_BLE_CONFIG                                        // 使能蓝牙配置功能
        /* 获取互斥锁 */
        PrivMutexObtain(&adapter->lock);          // 若其他线程正在使用adapter，则阻塞等待
        PrivMutexObtain(&romConfigurationMutex);  // 若其他线程正在读取或者写入CFG，则阻塞等待;

        /* 尝试连接服务器 */
        sprintf(serverIpAddress, "%u.%u.%u.%u", CFG->destinationIpAddress_Ethernet[0], CFG->destinationIpAddress_Ethernet[1],
                CFG->destinationIpAddress_Ethernet[2], CFG->destinationIpAddress_Ethernet[3]);
        sprintf(serverPort, "%u", (unsigned short)CFG->destinationPort_Ethernet[0] | CFG->destinationPort_Ethernet[1] << 8);
        printf("-*-*-*-*sendDataToServerTask_Ethernet*-*-*-*\n");
        printf("serverIpAddress:\t%s\n", serverIpAddress);
        printf("serverPort:\t\t%s\n", serverPort);
        printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n");
        int res = AdapterDeviceConnect(adapter, CLIENT, serverIpAddress, serverPort, IPV4);

        /* 连接失败，则等待10s再次尝试连接 */
        if (res != 0 && res != 0x1D) {
            PrivSemaphoreAbandon(&pQueueBuffer->full);  // 释放信号量
            /* 释放互斥锁 */
            PrivMutexAbandon(&romConfigurationMutex);
            PrivMutexAbandon(&adapter->lock);
            printf("Ethernet connect to server failed\n");  // 连接失败，打印错误信息
            PrivTaskDelay(1000 * 10);                       // 延迟10秒，避免网络拥塞
            continue;
        }
#else
        /* 尝试连接到服务器 */
        sprintf(serverIpAddress, "%u.%u.%u.%u", CFG->destinationIpAddress_Ethernet[0], CFG->destinationIpAddress_Ethernet[1],
                CFG->destinationIpAddress_Ethernet[2], CFG->destinationIpAddress_Ethernet[3]);
        sprintf(serverPort, "%u", (unsigned short)CFG->destinationPort_Ethernet[0] | CFG->destinationPort_Ethernet[1] << 8);
        printf("-*-*-*-*sendDataToServerTask_Ethernet*-*-*-*\n");
        printf("serverIpAddress:\t%s\n", serverIpAddress);
        printf("serverPort:\t\t%s\n", serverPort);
        printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n");
        int reconnectCount = RECONNECT_COUNT;  // 尝试重新连接服务器最多RECONNECT_COUNT次
        while (reconnectCount > 0) {
            int res = AdapterDeviceConnect(adapter, CLIENT, serverIpAddress, serverPort, IPV4);  // 尝试连接服务器
            if (res == 0 || res == 0x1D) {
                break;
            }
            reconnectCount--;
        }
        if (reconnectCount <= 0) {                          // 若RECONNECT_COUNT次都连接失败，则等待10s再次尝试连接
            PrivSemaphoreAbandon(&pQueueBuffer->full);      // 释放信号量
            printf("Ethernet connect to server failed\n");  // 连接失败，打印错误信息
            PrivTaskDelay(1000 * 10);                       // 延迟10秒，避免网络拥塞
            continue;
        }
#endif
        PrivMutexObtain(&pQueueBuffer->mutex);   // 获取互斥锁
        pDataFrame = pollBuffer(pQueueBuffer);   // 从队列中获取数据帧
        PrivMutexAbandon(&pQueueBuffer->mutex);  // 释放互斥锁

        int resendCount = RESEND_COUNT;  // 定义数据帧重发次数

        /* 只有数据帧非空并且还有剩余重发次数，才进行发送 */
        while (pDataFrame != NULL && resendCount > 0) {
            /* 向服务器发送数据 */
            printf("send data to server, id: %s\n", pDataFrame->id);
            printf("pDataFrame->data: %s", pDataFrame->data);
            AdapterDeviceSend(adapter, pDataFrame->data,
                              strlen(pDataFrame->data));  // 发送数据，注意当前最多发送256字节

            /* 从服务器接收响应，约定服务器接收完数据帧后，返回数据帧中的前12个字节，即数据帧id */
            memset(receiveBuffer, 0, sizeof(receiveBuffer));
            PrivTaskDelay(6000);
            if (AdapterDeviceRecv(adapter, receiveBuffer, strlen(pDataFrame->id)) == strlen(pDataFrame->id)) {
                /* 打印服务器响应 */
                printf("receiveBuffer: ");
                for (int i = 0; i < strlen(receiveBuffer); i++) {
                    printf("%c", receiveBuffer[i]);
                }
                printf("\n");
                /* 比较服务器响应的内容与发送的数据帧id是否一致 */
                if (strstr(pDataFrame->id, receiveBuffer) != NULL) {
                    break;  // 接收成功，退出循环
                }
            }
            resendCount--;
        }
        if (pDataFrame != NULL) {
            PrivFree(pDataFrame);  // 释放数据帧内存
            pDataFrame = NULL;     // 避免野指针
        }
        AdapterDeviceDisconnect(adapter, NULL);
#ifdef BSP_BLE_CONFIG
        /* 释放互斥锁 */
        PrivMutexAbandon(&romConfigurationMutex);
        PrivMutexAbandon(&adapter->lock);
#endif
        if (resendCount <= 0) {        // 如果数据帧重发次数超过上限，表示发送失败，丢弃该帧
            PrivTaskDelay(1000 * 10);  // 延迟10秒，避免网络拥塞
        }
    }
    return NULL;
}

/**
 * @brief  开启从ADL400接收数据的线程以及上传数据到服务器的线程，此方法在main方法中被调用，开机或复位启动
 */
void startUpTransformDataTask(void) {
    /* 分配循环队列空间 */
    struct QueueBuffer *pQueueBuffer = (struct QueueBuffer *)PrivCalloc(1, sizeof(struct QueueBuffer));
    if (initBuffer(pQueueBuffer) < 0) {
        PrivFree(pQueueBuffer);
        return;
    }

    /* 启动从ADL400接收数据的线程 */
    pthread_attr_t receiveDataFromADL400TaskAttr;
    pthread_args_t receiveDataFromADL400TaskArgs;
    receiveDataFromADL400TaskAttr.schedparam.sched_priority = 16;              // 线程优先级
    receiveDataFromADL400TaskAttr.stacksize = 2048;                            // 线程栈大小
    receiveDataFromADL400TaskArgs.pthread_name = "receiveDataFromADL400Task";  // 线程名字
    receiveDataFromADL400TaskArgs.arg = pQueueBuffer;                          // 线程参数
    pthread_t receiveDataThread;                                               // 线程ID
    PrivTaskCreate(&receiveDataThread, &receiveDataFromADL400TaskAttr, receiveDataFromADL400Task, &receiveDataFromADL400TaskArgs);
    PrivTaskStartup(&receiveDataThread);

    /* 启动上传数据到服务器的线程 */
    pthread_attr_t sendDataToServerTaskAttr;
    pthread_args_t sendDataToServerTaskArgs;
    sendDataToServerTaskAttr.schedparam.sched_priority = 16;         // 线程优先级
    sendDataToServerTaskAttr.stacksize = 2200;                       // 线程栈大小
    sendDataToServerTaskArgs.pthread_name = "sendDataToServerTask";  // 线程名字
    sendDataToServerTaskArgs.arg = pQueueBuffer;                     // 线程参数
    pthread_t sendDataThread;                                        // 线程ID
    void *(*start_routine)(void *) = sendDataToServerTask_4G;        // 通过4G模块上传到服务器
    // void *(*start_routine)(void *) = sendDataToServerTask_Ethernet;  // 通过以太网模块上传到服务器
    PrivTaskCreate(&sendDataThread, &sendDataToServerTaskAttr, start_routine, &sendDataToServerTaskArgs);  // 通过4G模块上传到服务器
    PrivTaskStartup(&sendDataThread);
}