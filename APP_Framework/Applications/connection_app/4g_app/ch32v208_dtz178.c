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
 * @file .c
 * @brief Support reading data from WISDOM DTZ178 using the DL/T645-2007 protocol
 * @version 1.0
 * @author AIIT XUOS Lab
 * @date 2025.4.14
 */

#include <ModuleConfig.h>
#include <adapter.h>
#include <transform.h>
#include <math.h>
#include <cJSON.h>

#define MAX_FRAME_SIZE 256                      // 最大帧大小
#define MAX_DATA_SIZE 1024                      // 最大数据大小
#define MAX_BUFFER_SIZE 1024 * 2                // 最大缓冲区大小
#define RECEIVE_DATA_INTERVAL_MS 1000 * 60 * 2  // DTZ178数据采集间隔时间，单位为毫秒
#define SAMPLE_DATA_INTERVAL_MS 300             // 稳定连续采集的间隔时间，单位为毫秒
#define SEND_FRAME_LEN 16                       // 发送帧长度
#define BASE_RECEIVE_FRAME_LEN 16               // 基础返回帧长度（不包含各项数据长度）
#define TOTAL_RECEIVE_FRAME_LEN 20              // 总返回帧长度（不包含各项数据长度），包含4个前置0xFE字节
#define RESEND_COUNT 3                          // 最大帧重发次数
#define RECONNECT_COUNT 5                       // 最大连接次数
#define WATING_RESPONSE_MS 5000                 // 等待响应时间，单位为毫秒
#define DATA_COUNT (sizeof(data_id_map) / sizeof(data_id_map[0]))   // 数据项数量
#define READ_COMMAND 0x11                       // 读取数据指令

static const uint8_t addr_meter[6] = {0x01, 0x22, 0x00, 0x03, 0x61, 0x74};
static uint8_t parsed_date[11] = {0};
static uint8_t parsed_time[9] = {0};

#ifndef DATA_ITEMS_DEF_H
#define DATA_ITEMS_DEF_H

#define DATA_ITEMS_XMACRO \
    X(ENERGY_TOTAL,          0x00, 0x00, 0x00, 0x00, 4, 2)  /* 总电能，4字节，2位小数，单位kWh */ \
    X(ENERGY_ACTIVE,         0x00, 0x01, 0x00, 0x00, 4, 2)  /* 有功电能，4字节，2位小数，单位kWh */ \
    X(ENERGY_REACTIVE,       0x00, 0x02, 0x00, 0x00, 4, 2)  /* 无功电能，4字节，2位小数，单位kWh */ \
    X(VOLTAGE_A,             0x02, 0x01, 0x01, 0x00, 2, 1)  /* A相电压，2字节，1位小数，单位V */ \
    X(VOLTAGE_B,             0x02, 0x01, 0x02, 0x00, 2, 1)  /* B相电压，2字节，1位小数，单位V */ \
    X(VOLTAGE_C,             0x02, 0x01, 0x03, 0x00, 2, 1)  /* C相电压，2字节，1位小数，单位V */ \
    X(CURRENT_A,             0x02, 0x02, 0x01, 0x00, 3, 3)  /* A相电流，3字节，3位小数，单位A */ \
    X(CURRENT_B,             0x02, 0x02, 0x02, 0x00, 3, 3)  /* B相电流，3字节，3位小数，单位A */ \
    X(CURRENT_C,             0x02, 0x02, 0x03, 0x00, 3, 3)  /* C相电流，3字节，3位小数，单位A */ \
    X(ACTIVE_POWER_TOTAL,    0x02, 0x03, 0x00, 0x00, 3, 4)  /* 总有功功率，3字节，4位小数，单位kW */ \
    X(ACTIVE_POWER_A,        0x02, 0x03, 0x01, 0x00, 3, 4)  /* A有功功率，3字节，4位小数，单位kW */ \
    X(ACTIVE_POWER_B,        0x02, 0x03, 0x02, 0x00, 3, 4)  /* B有功功率，3字节，4位小数，单位kW */ \
    X(ACTIVE_POWER_C,        0x02, 0x03, 0x03, 0x00, 3, 4)  /* C有功功率，3字节，4位小数，单位kW */ \
    X(REACTIVE_POWER_TOTAL,  0x02, 0x04, 0x00, 0x00, 3, 4)  /* 总无功功率，3字节，4位小数，单位kvar */ \
    X(REACTIVE_POWER_A,      0x02, 0x04, 0x01, 0x00, 3, 4)  /* A无功功率，3字节，4位小数，单位kvar */ \
    X(REACTIVE_POWER_B,      0x02, 0x04, 0x02, 0x00, 3, 4)  /* B无功功率，3字节，4位小数，单位kvar */ \
    X(REACTIVE_POWER_C,      0x02, 0x04, 0x03, 0x00, 3, 4)  /* C无功功率，3字节，4位小数，单位kvar */ \
    X(APPARENT_POWER_TOTAL,  0x02, 0x05, 0x00, 0x00, 3, 4)  /* 总视在功率，3字节，4位小数，单位kVA */ \
    X(APPARENT_POWER_A,      0x02, 0x05, 0x01, 0x00, 3, 4)  /* A视在功率，3字节，4位小数，单位kVA */ \
    X(APPARENT_POWER_B,      0x02, 0x05, 0x02, 0x00, 3, 4)  /* B视在功率，3字节，4位小数，单位kVA */ \
    X(APPARENT_POWER_C,      0x02, 0x05, 0x03, 0x00, 3, 4)  /* C视在功率，3字节，4位小数，单位kVA */ \
    X(POWER_FACTOR_TOTAL,    0x02, 0x06, 0x00, 0x00, 2, 3)  /* 总功率因数，2字节，3位小数，单位无 */ \
    X(POWER_FACTOR_A,        0x02, 0x06, 0x01, 0x00, 2, 3)  /* A功率因数，2字节，3位小数，单位无 */ \
    X(POWER_FACTOR_B,        0x02, 0x06, 0x02, 0x00, 2, 3)  /* B功率因数，2字节，3位小数，单位无 */ \
    X(POWER_FACTOR_C,        0x02, 0x06, 0x03, 0x00, 2, 3)  /* C功率因数，2字节，3位小数，单位无 */ \
    X(FREQUENCY,             0x02, 0x80, 0x00, 0x02, 2, 2)  /* 电网频率，2字节，2位小数，单位Hz */ \
    X(INTERNAL_TEMPERATURE,  0x02, 0x80, 0x00, 0x07, 2, 1)  /* 内部温度，2字节，1位小数，单位℃ */ \
    X(DATE_YMD,              0x04, 0x00, 0x01, 0x01, 4, 0)  /* 年月日星期，4字节，0位小数，单位无*/ \
    X(TIME_HMS,              0x04, 0x00, 0x01, 0x02, 3, 0)  /* 时分秒，3字节，0位小数，单位无 */


#endif // DATA_ITEMS_DEF_H

#ifndef DATA_ITEMS_H
#define DATA_ITEMS_H

typedef enum {
#define X(name, id3, id2, id1, id0, size, dec) name,
    DATA_ITEMS_XMACRO
#undef X
} DataIdIndex;

typedef struct {
    uint8_t byte_size;
    uint8_t decimal_places;
} DataInfo;

static const uint8_t data_id_map[][4] = {
#define X(name, id3, id2, id1, id0, size, dec) {id3, id2, id1, id0},
    DATA_ITEMS_XMACRO
#undef X
};

static const DataInfo data_info_map[] = {
#define X(name, id3, id2, id1, id0, size, dec) {size, dec},
    DATA_ITEMS_XMACRO
#undef X
};

static const char *data_id_names[] = {
#define X(name, id3, id2, id1, id0, size, dec) #name,
    DATA_ITEMS_XMACRO
#undef X
};

#endif // DATA_ITEMS_H
 
/**
 * @brief  计算DL/T645-2007数据帧的校验和
 * @param  data 数据帧指针
 * @param  len  校验的长度（从第一个 0x68 开始，到CS前一位）
 * @return uint8_t 校验和
 */
static uint8_t CheckSum(const uint8_t *data, uint8_t len)
{
    uint16_t sum = 0;
    for (int i = 0; i < len; i++) {
        sum += data[i];
    }
    return (uint8_t)(sum & 0xFF);  // 返回低8位
}

/**
 * @brief 构造DL/T645-2007协议数据帧
 * @param addr 6字节地址（低位在前）
 * @param ctrl_code 控制码，如0x11表示读数据
 * @param data_id 4字节数据标识（低位在前）
 * @param data 数据域内容（可为空）
 * @param data_len 数据域长度(读数据时<=200，写数据时<=50)
 * @param request_frame 输出构造好的完整帧
 * @return int 0成功，-1失败
 */
static int GenerateRequestFrame(const uint8_t addr[6], uint8_t ctrl_code, const uint8_t data_id[4], const uint8_t *data, uint8_t data_len, uint8_t *request_frame) 
{
    if (!addr || !data_id || !request_frame) 
        return -1;

    uint8_t idx = 0;
    request_frame[idx++] = 0x68;

    // 地址 6 字节（低位在前）
    for (int i = 5; i >= 0; i--)
        request_frame[idx++] = addr[i];

    request_frame[idx++] = 0x68;
    request_frame[idx++] = ctrl_code;

    uint8_t total_data_len = 4 + data_len;
    request_frame[idx++] = total_data_len;

    // 数据标识 + 数据内容，低位在前，+0x33加密
    for (int i = 3; i >= 0; i--)
        request_frame[idx++] = data_id[i] + 0x33;

    for (int i = 0; i < data_len; i++)
        request_frame[idx++] = data[i] + 0x33;

    // 校验和
    uint8_t cs = CheckSum(request_frame, idx);
    request_frame[idx++] = cs;

    // 结束码
    request_frame[idx++] = 0x16;

    // printf("GenerateRequestFrame: ");
    // for (int i = 0; i < idx; i++) {
    //     printf("%02X ", request_frame[i]);
    // }
    // printf("\n");

    return 0;
}
 
/**
 * @brief  将要上传服务器的数据帧
 */
struct DataFrame {
    unsigned char id[20];  // 用响应的时间戳作为数据帧的id
    unsigned char data[MAX_DATA_SIZE];  // 上传服务器的数据帧字符串，用JSON封装
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
  * @param  queue_buffer_ptr 循环队列指针
  * @return * int  0表示初始化成功，其他表示初始化失败
  */
static int InitBuffer(struct QueueBuffer *queue_buffer_ptr) {
    queue_buffer_ptr->front = 0;
    queue_buffer_ptr->rear = 0;
    if (PrivMutexCreate(&queue_buffer_ptr->mutex, 0) < 0) {
        printf("buffer mutex create failed.\n");
        return -1;
    }
    if (PrivSemaphoreCreate(&queue_buffer_ptr->full, 0, 0) < 0) {
        printf("buffer full semaphore create failed.\n");
        return -1;
    }
    return 0;
}
 
 /**
  * @brief  循环队列入队，如果循环队列已满，则将最旧的成员出队后，新成员再入队
  * @param  queue_buffer_ptr 循环队列指针
  * @param  data_frame_ptr DTZ178响应数据帧
  * @return int 0表示入队成功，其他表示入队失败
  */
static int OfferBuffer(struct QueueBuffer *queue_buffer_ptr, struct DataFrame *data_frame_ptr) {
    /* 循环队列已满，将最旧的成员出队 */
    if ((queue_buffer_ptr->rear + 1) % BUFFER_ELEM_COUNT == queue_buffer_ptr->front) {
        struct DataFrame *front_data_frame_ptr = queue_buffer_ptr->buffer[queue_buffer_ptr->front];
        PrivFree(front_data_frame_ptr);
        queue_buffer_ptr->front = (queue_buffer_ptr->front + 1) % BUFFER_ELEM_COUNT;
    }
    /* 新成员入队 */
    queue_buffer_ptr->buffer[queue_buffer_ptr->rear] = data_frame_ptr;
    queue_buffer_ptr->rear = (queue_buffer_ptr->rear + 1) % BUFFER_ELEM_COUNT;
    printf("front: %d\n", queue_buffer_ptr->front);
    printf("rear: %d\n", queue_buffer_ptr->rear);
    return 0;
}
 
 /**
  * @brief  循环队列出队，如果队列为空则返回NULL
  * @param  queue_buffer_ptr 循环队列指针
  * @return struct DataFrame* 出队成员，如果队列为空则返回NULL
  */
static struct DataFrame *PollBuffer(struct QueueBuffer *queue_buffer_ptr) {
    /* 队列为空，返回NULL */
    if (queue_buffer_ptr->front == queue_buffer_ptr->rear) {
        return NULL;
    }
    /* 最旧的成员出队 */
    struct DataFrame *front_data_frame_ptr = queue_buffer_ptr->buffer[queue_buffer_ptr->front];
    queue_buffer_ptr->buffer[queue_buffer_ptr->front] = NULL;
    queue_buffer_ptr->front = (queue_buffer_ptr->front + 1) % BUFFER_ELEM_COUNT;
    printf("front: %d\n", queue_buffer_ptr->front);
    printf("rear: %d\n", queue_buffer_ptr->rear);
    return front_data_frame_ptr;
}
 
/**
 * @brief  查看队头元素，如果队列为空则返回NULL
 * @param  queue_buffer_ptr 循环队列指针
 * @return struct DataFrame* 队头元素，如果队列为空则返回NULL
 */
static struct DataFrame *PeekBuffer(struct QueueBuffer *queue_buffer_ptr) {
    /* 如果队列为空，返回NULL */
    if (queue_buffer_ptr->front == queue_buffer_ptr->rear) {
        return NULL;
    }
    /* 返回队头元素，但不出队 */
    return queue_buffer_ptr->buffer[queue_buffer_ptr->front];
}
 
/**
 * @brief  改写PrivRead函数，原有函数只会读取接收缓冲区的当前已有字节，新函数会读取指定字节数再返回
 * @param  fd 文件描述符
 * @param  buf 数据读取到的位置
 * @param  len 读取的指定字节数
 * @return int 如果读取到指定字节数返回0；如果到达WATING_RESPONSE_MS仍未读取到指定字节数，或者读数据错误，返回-1
 */
static int PrivReadEnoughData(int fd, void *buf, size_t len) {
    char *buffer = (char *)buf;           // 将接收的存储空间指针强制转型
    int gotten_bytes = 0;                  // 已经读取到的字节数
    int remain_time = WATING_RESPONSE_MS;  // 剩余的时间

    /* 只有接收的字节数不够，并且还有剩余时间，才可以继续读取 */
    while (gotten_bytes < len && remain_time > 0) {
        int bytes = PrivRead(fd, buffer + gotten_bytes, len - gotten_bytes);  // 从设备读取
        gotten_bytes += bytes;
        PrivTaskDelay(100);  // 每100ms读取一次
        remain_time -= 100;   // 剩余时间减去100ms
    }
    /* 若没有剩余时间，表示还没有读取到指定的字节数，返回-1；若有剩余时间，表示已经读取了指定的字节数，返回0 */
    return remain_time < 0 ? -1 : 0;
}

/**
 * @brief  将BCD格式的多字节数值转换为十进制整数
 * @param  bcd    BCD格式的原始数值（低字节在低位）
 * @param  bytes  BCD所占用的字节数
 * @return 转换后的十进制整数结果
 * @note   每个字节的高4位和低4位分别代表1位十进制数字，即每个字节表示两位十进制数。
 *         最低位字节代表最低的两位十进制数，依此类推。例如 0x12 0x34 表示1234。
 */
static uint32_t BcdToDecimal(uint32_t bcd, uint8_t bytes)
{
    uint32_t result = 0;
    for (int i = 0; i < bytes; i++) {
        uint8_t byte = (bcd >> (i * 8)) & 0xFF;
        uint8_t high = (byte >> 4) & 0x0F;  // 高4位
        uint8_t low = byte & 0x0F;         // 低4位
        result += (high * 10 + low) * pow(100, i);  // 每个字节是2位十进制
    }
    return result;
}

/**
 * @brief  解析DTZ178响应的Modbus RTU数据帧
 * @param  response_frame 返回的数据帧
 * @param  data_info_ptr 数据项的字节数和小数位数信息
 * @param  item_id 数据项ID
 * @param  root 根节点
 */
static void ParseResponseFrame(unsigned char *response_frame, const DataInfo *data_info_ptr, int item_id, cJSON *root) {
    if (!response_frame || !data_info_ptr || !root) {
        printf("Invalid input to ParseResponseFrame\n");
        return;
    }

    uint8_t data_len_total = response_frame[13]; // 数据域长度，包括数据标识（4字节） + 数据内容
    if (data_len_total < 4 || data_len_total - 4 != data_info_ptr->byte_size) {
        printf("Invalid data length in frame\n");
        return;
    }

    const uint8_t *data_field = &response_frame[14];      // 数据域开始位置（含数据标识 + 数据内容）
    const uint8_t *data_value = &data_field[4];           // 数据内容起始位置

    // for (int i = 0; i < data_info_ptr->byte_size; i++)
    //     printf("%02x ", data_value[i]);

    // 判断是否是日期或时间
    if (item_id == DATE_YMD) {
        snprintf(parsed_date, sizeof(parsed_date), "20%02x-%02x-%02x", data_value[3] - 0x33, data_value[2] - 0x33, data_value[1] - 0x33);
        // printf("Parsed date: %s\n", parsed_date);
        return;
    } else if (item_id == TIME_HMS) {
        snprintf(parsed_time, sizeof(parsed_time), "%02x:%02x:%02x", data_value[2] - 0x33, data_value[1] - 0x33, data_value[0] - 0x33);
        // printf("Parsed time: %s\n", parsed_time);
        return;
    }

    uint32_t bcd = 0;

    for (int i = data_info_ptr->byte_size - 1; i >= 0; i--) {
        // 解密（减去0x33），反向拼接（低位在前 → 高位在前）
        bcd |= ((uint32_t)(data_value[i] - 0x33)) << (8 * i);
    }

    uint32_t value = 0;
    value = BcdToDecimal(bcd, data_info_ptr->byte_size);

    // 除以10的倍数来处理小数点
    double final_value = value / pow(10, data_info_ptr->decimal_places);

    // printf("Parsed value: %.*f\n", data_info_ptr->decimal_places, final_value);

    char format[10];
    snprintf(format, sizeof(format), "%%.%df", data_info_ptr->decimal_places);

    char final_value_str[20];
    snprintf(final_value_str, sizeof(final_value_str), format, final_value);

    cJSON_AddStringToObject(root, data_id_names[item_id], final_value_str);
}

/**
 * @brief  从DTZ178接收数据的线程
 * @param  arg   循环队列指针
 * @return void* 目前返回值无意义
 */
static void *ReceiveDataFromDTZ178Task(void *arg) {
    struct QueueBuffer *queue_buffer_ptr = (struct QueueBuffer *)arg;  // 循环队列指针
    int fd = PrivOpen("/dev/rs485_dev1", O_RDWR);                  // 打开设备文件
    if (fd < 0) {                                                  // 打开设备文件失败，打印错误信息
        printf("open rs485 fd error: %d\n", fd);
        return NULL;
    }

    struct SerialDataCfg rs485_configuration;
    memset(&rs485_configuration, 0, sizeof(struct SerialDataCfg));
    /* 读取RS485配置信息 */
    PrivMutexObtain(&romConfigurationMutex);  // 若其他线程正在读取或者写入CFG，则阻塞等待
    int baud_rates_option = CFG->baudRate_Rs485;
    int data_bits_option = CFG->dataBits_Rs485;
    int stop_bits_option = CFG->stopBits_Rs485;
    int parity_option = CFG->parity_Rs485;
    PrivMutexAbandon(&romConfigurationMutex);  // 释放互斥锁
    switch (baud_rates_option) {
        case 1:
            rs485_configuration.serial_baud_rate = BAUD_RATE_2400;  // 默认波特率为2400
            break;
        case 2:
            rs485_configuration.serial_baud_rate = BAUD_RATE_4800;
            break;
        case 3:
            rs485_configuration.serial_baud_rate = BAUD_RATE_9600;
            break;
        case 4:
            rs485_configuration.serial_baud_rate = BAUD_RATE_19200;
            break;
        case 5:
            rs485_configuration.serial_baud_rate = BAUD_RATE_38400;
            break;
        case 6:
            rs485_configuration.serial_baud_rate = BAUD_RATE_57600;
            break;
        case 7:
            rs485_configuration.serial_baud_rate = BAUD_RATE_115200;
            break;
        case 8:
            rs485_configuration.serial_baud_rate = BAUD_RATE_230400;
            break;
        default:
            rs485_configuration.serial_baud_rate = BAUD_RATE_9600;
            break;
    }
    switch (data_bits_option) {
        case 1:
            rs485_configuration.serial_data_bits = DATA_BITS_8;
            break;
        case 2:
            rs485_configuration.serial_data_bits = DATA_BITS_9;
            break;
        default:
            rs485_configuration.serial_data_bits = DATA_BITS_8;
            break;
    }
    switch (stop_bits_option) {
        case 1:
            rs485_configuration.serial_stop_bits = STOP_BITS_1;
            break;
        case 2:
            rs485_configuration.serial_stop_bits = STOP_BITS_2;
            break;
        default:
            rs485_configuration.serial_stop_bits = STOP_BITS_1;
            break;
    }
    switch (parity_option) {
        case 1:
            rs485_configuration.serial_parity_mode = PARITY_NONE;
            break;
        case 2:
            rs485_configuration.serial_parity_mode = PARITY_ODD;
            break;
        case 3:
            rs485_configuration.serial_parity_mode = PARITY_EVEN;  // 默认校验方式为偶校验
            break;
    }
    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = (void *)&rs485_configuration;
    if (0 != PrivIoctl(fd, OPE_INT, &ioctl_cfg)) {
        printf("ioctl uart fd error %d\n", fd);
        PrivClose(fd);
        return NULL;
    }
    printf("open rs485 fd success %d\n", fd);

    unsigned char request_frame[MAX_FRAME_SIZE];      // 定义请求帧
    unsigned char response_frame[MAX_FRAME_SIZE];     // 定义回复帧
    while (1) {
        printf("enter cycle\n");
        struct DataFrame *data_frame_ptr = (struct DataFrame *)PrivMalloc(sizeof(struct DataFrame));
        memset(data_frame_ptr, 0, sizeof(struct DataFrame));

        // 创建一个空的JSON对象
        cJSON *root = cJSON_CreateObject();
        int is_success = 1;

        for (int i = 0; i < DATA_COUNT; i++) {
            const uint8_t *data_id = data_id_map[i];
            const DataInfo *data_info = &data_info_map[i];
    
            memset(request_frame, 0, sizeof(request_frame));
            if (GenerateRequestFrame(addr_meter, READ_COMMAND, data_id, NULL, 0, request_frame) < 0) {
                printf("Generate frame failed for index %d\n", i);
                is_success = 0;
                break;
            }
    
            PrivWrite(fd, request_frame, SEND_FRAME_LEN);  // 发送Modbus RTU请求帧

            /* 读取响应帧数据 */
            memset(response_frame, 0, sizeof(response_frame));
            if (PrivReadEnoughData(fd, response_frame, TOTAL_RECEIVE_FRAME_LEN + data_info->byte_size) < 0) {
                printf("Timeout reading response for index %d\n", i);
                is_success = 0;
                break;                                   
            }

            // printf("Response frame for index %d: ", i);
            // for (int j = 0; j < TOTAL_RECEIVE_FRAME_LEN + data_info->byte_size; j++)
            //     printf("%02X ", response_frame[j]);
            // printf("\n");

            // 校验帧头、帧尾
            if (response_frame[4] != 0x68 || response_frame[11] != 0x68 || response_frame[TOTAL_RECEIVE_FRAME_LEN + data_info->byte_size - 1] != 0x16) {
                printf("Invalid frame format for index %d\n", i);
                is_success = 0;
                break;
            }
    
            // 校验和
            uint8_t calc_cs = CheckSum(response_frame + 4, BASE_RECEIVE_FRAME_LEN + data_info->byte_size - 2);
            uint8_t recv_cs = response_frame[TOTAL_RECEIVE_FRAME_LEN + data_info->byte_size - 2];
            if (calc_cs != recv_cs) {
                printf("CheckSum error at index %d: calc %02X, recv %02X\n", i, calc_cs, recv_cs);
                is_success = 0;
                break;
            }
    
            ParseResponseFrame(response_frame, data_info, i, root);

            PrivTaskDelay(SAMPLE_DATA_INTERVAL_MS);
        }

        if (!is_success) {
            printf("read all data failed\n");
            PrivFree(data_frame_ptr);
            cJSON_Delete(root);
            continue;
        }

        snprintf((char *)data_frame_ptr->id, sizeof(data_frame_ptr->id), "%s %s", parsed_date, parsed_time);
        printf("data_frame_ptr->id: %s\n", data_frame_ptr->id);
        
        char *json_str = cJSON_Print(root);
        strncpy((char *)data_frame_ptr->data, json_str, MAX_DATA_SIZE - 1);
        data_frame_ptr->data[MAX_DATA_SIZE - 1] = '\0';  // 确保结尾是 \0
        printf("data_frame_ptr->data: %s\n", data_frame_ptr->data);

        // 删除字符串空间
        free(json_str);
        // 删除 cJSON 对象
        cJSON_Delete(root);

        /* 将解析后的数据帧放入循环队列 */
        PrivMutexObtain(&queue_buffer_ptr->mutex);                         // 获取互斥锁
        OfferBuffer(queue_buffer_ptr, data_frame_ptr);                         // 将数据帧放入队列
        printf("receive data from DTZ178, id: %s\n", data_frame_ptr->id);  // 打印接收到的数据帧ID
        PrivMutexAbandon(&queue_buffer_ptr->mutex);                        // 释放互斥锁
        PrivSemaphoreAbandon(&queue_buffer_ptr->full);  // 释放信号量，即告知发送数据线程，队列中有新的数据帧

        PrivTaskDelay(RECEIVE_DATA_INTERVAL_MS);  // 延迟一段时间再读取下一帧数据

        printf("end cycle\n");
    }

    PrivClose(fd);  // 关闭设备文件
    return NULL;
}
 
 /**
  * @brief 通过4G向服务器发送数据的线程
  * @param arg 循环队列指针
  * @return void* 目前返回值无意义
  */
static void *SendDataToServerTask_4G(void *arg) {
    uint8_t server_ip_address[16] = {};                              // 目的IP地址
    uint8_t server_port[6] = {};                                    // 目的端口号
    struct QueueBuffer *queue_buffer_ptr = (struct QueueBuffer *)arg;  // 循环队列指针
    unsigned char receive_buffer[256];                              // 从服务器接收每帧响应的存储空间

    struct Adapter *adapter = AdapterDeviceFindByName(ADAPTER_4G_NAME);  // 查找4G模块适配器

    AdapterDeviceOpen(adapter);                          // 打开适配器对应的设备（实际打开串口中断）
    int baud_rate = BAUD_RATE_115200;                    // 波特率，用于设置4G模块串口
    AdapterDeviceControl(adapter, OPE_INT, &baud_rate);  // 对适配器对应设备进行配置（实际配置波特率）

    struct DataFrame *data_frame_ptr = NULL;  // 数据帧定义
    while (1) {
        PrivSemaphoreObtainWait(&queue_buffer_ptr->full, NULL);  // 尝试获取循环队列队头元素，如果获取信号量失败，则等待信号量
#ifdef BSP_BLE_CONFIG                                        // 如果启用了BLE配置功能
        /* 获取互斥锁 */
        PrivMutexObtain(&adapter->lock);          // 若其他线程正在使用adapter，则阻塞等待
        PrivMutexObtain(&romConfigurationMutex);  // 若其他线程正在读取或者写入CFG，则阻塞等待

        /* 尝试连接服务器 */
        sprintf(server_ip_address, "%u.%u.%u.%u", CFG->destinationIpAddress_4G[0], CFG->destinationIpAddress_4G[1],
                CFG->destinationIpAddress_4G[2], CFG->destinationIpAddress_4G[3]);
        sprintf(server_port, "%u", (unsigned short)CFG->destinationPort_4G[0] | CFG->destinationPort_4G[1] << 8);
        printf("-*-*-*-*sendDataToServerTask_4G*-*-*-*\n");
        printf("server_ip_address:\t%s\n", server_ip_address);
        printf("server_port:\t\t%s\n", server_port);
        printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n");
        if (CFG->mqttSwitch_4G == 1) {  // 如果使能MQTT
            AdapterDeviceMqttConnect(adapter, server_ip_address, server_port, CFG->mqttClientId_4G, CFG->mqttUsername_4G,
                                    CFG->mqttPassword_4G);
        } else {  // 如果禁用MQTT
            AdapterDeviceConnect(adapter, CLIENT, server_ip_address, server_port, IPV4);
        }

        AdapterDeviceNetstat(adapter);  // 读取网络连接状态
        /* 若连接失败，则等待10s再次尝试连接 */
        if (CFG->mqttSwitch_4G == 0 && !adapter->network_info.is_connected ||
            CFG->mqttSwitch_4G == 1 && !adapter->network_info.mqttIsConnected) {
            PrivSemaphoreAbandon(&queue_buffer_ptr->full);  // 释放信号量
            /* 释放互斥锁 */
            PrivMutexAbandon(&romConfigurationMutex);
            PrivMutexAbandon(&adapter->lock);
            printf("4G connect to server failed\n");  // 连接失败，打印错误信息
            PrivTaskDelay(1000 * 10);                 // 延迟10秒，避免网络拥塞
            continue;
        }
#else  // 如果没有启用BLE配置功能
        /* 尝试连接到服务器 */
        sprintf(server_ip_address, "%u.%u.%u.%u", CFG->destinationIpAddress_4G[0], CFG->destinationIpAddress_4G[1],
                CFG->destinationIpAddress_4G[2], CFG->destinationIpAddress_4G[3]);
        sprintf(server_port, "%u", (unsigned short)CFG->destinationPort_4G[0] | CFG->destinationPort_4G[1] << 8);
        printf("-*-*-*-*sendDataToServerTask_4G*-*-*-*\n");
        printf("server_ip_address:\t%s\n", server_ip_address);
        printf("server_port:\t\t%s\n", server_port);
        printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n");
        int reconnect_count = RECONNECT_COUNT;  // 尝试重新连接服务器最多RECONNECT_COUNT次
        while (reconnect_count > 0) {
            int res;
            if (CFG->mqttSwitch_4G == 1) {
                res = AdapterDeviceMqttConnect(adapter, mqttServerIp, mqttServerPort, CFG->mqttClientId_4G, CFG->mqttUsername_4G,
                                            CFG->mqttPassword_4G);
            } else {
                res = AdapterDeviceConnect(adapter, CLIENT, server_ip_address, server_port, IPV4);
            }
            if (res == 0) {
                break;
            }
            reconnect_count--;
        }
        if (reconnect_count <= 0) {                      // 若RECONNECT_COUNT次都连接失败，则等待10s再次尝试连接
            PrivSemaphoreAbandon(&queue_buffer_ptr->full);  // 释放信号量
            printf("4G connect to server failed\n");    // 连接失败，打印错误信息
            PrivTaskDelay(1000 * 10);                   // 延迟10秒，避免网络拥塞
            continue;
        }
#endif
        PrivMutexObtain(&queue_buffer_ptr->mutex);   // 获取互斥锁
        data_frame_ptr = PollBuffer(queue_buffer_ptr);   // 从队列中获取数据帧
        PrivMutexAbandon(&queue_buffer_ptr->mutex);  // 释放互斥锁

        int resend_count = RESEND_COUNT;                  // 定义数据帧重发次数
        while (data_frame_ptr != NULL && resend_count > 0) {  // 只有数据帧非空并且还有剩余重发次数，才进行发送
            /* 向服务器发送数据 */
            printf("data_frame_ptr->data: %s", data_frame_ptr->data);
            printf("send data to server, id: %s\n", data_frame_ptr->id);
            if (CFG->mqttSwitch_4G == 1) { // MQTT模式下，无需服务器响应数据
                AdapterDeviceMqttSend(adapter, CFG->mqttTopic_4G, data_frame_ptr->data,
                                    strlen(data_frame_ptr->data));  // 发送数据，注意当前最多发送256字节
                break;
            } else {
                AdapterDeviceSend(adapter, data_frame_ptr->data,
                                strlen(data_frame_ptr->data));  // 发送数据，注意当前最多发送256字节

                /* 从服务器接收响应，约定服务器接收完数据帧后，返回数据帧中的前12个字节，即数据帧id */
                /* 多读取2字节，是为了防止前面还有命令模式返回的剩余的\r\n影响判断 */
                memset(receive_buffer, 0, sizeof(receive_buffer));
                int receive_length = AdapterDeviceRecv(adapter, receive_buffer, strlen(data_frame_ptr->id) + 2);
                if (receive_length == strlen(data_frame_ptr->id) + 2 || receive_length == strlen(data_frame_ptr->id)) {
                    /* 打印服务器响应 */
                    printf("receive_length: %d\n", receive_length);
                    printf("receive_buffer: ");
                    for (int i = 0; i < receive_length; i++) {
                        printf("%c", receive_buffer[i]);
                    }
                    printf("\n");
                    /* 比较服务器响应的内容与发送的数据帧id是否一致 */
                    if (strstr(receive_buffer, data_frame_ptr->id) != NULL) {
                        break;  // 接收成功，退出循环
                    }
                } else {
                    printf("receive_length: %d\n", receive_length);
                    printf("receive_buffer: ");
                    for (int i = 0; i < receive_length; i++) {
                        printf("%d ", receive_buffer[i]);
                    }
                    printf("\n");
                }
            }
            resend_count--;
        }
        if (data_frame_ptr != NULL) {
            PrivFree(data_frame_ptr);  // 释放数据帧内存
            data_frame_ptr = NULL;     // 避免野指针
        }
        // AdapterDeviceDisconnect(adapter, NULL);  // 关闭适配器对应的设备
#ifdef BSP_BLE_CONFIG
        /* 释放互斥锁 */
        PrivMutexAbandon(&romConfigurationMutex);
        PrivMutexAbandon(&adapter->lock);
#endif
        if (resend_count <= 0) {        // 如果数据帧重发次数超过上限，表示发送失败，丢弃该帧
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
static void *SendDataToServerTask_Ethernet(void *arg) {
    uint8_t server_ip_address[16] = {};                              // 目的IP地址
    uint8_t server_port[6] = {};                                    // 目的端口号
    struct QueueBuffer *queue_buffer_ptr = (struct QueueBuffer *)arg;  // 循环队列指针
    unsigned char receive_buffer[256];                              // 从服务器接收每帧响应的存储空间

    struct Adapter *adapter = AdapterDeviceFindByName(ADAPTER_ETHERNET_NAME);  // 查找以太网模块适配器

#ifndef BSP_BLE_CONFIG                                        // 如果没有使能蓝牙配置功能
    AdapterDeviceSetUp(adapter);                              // 启动以太网主任务线程
    AdapterDeviceSetDhcp(adapter, CFG->dhcpSwitch_Ethernet);  // 启用或禁用DHCP
#endif

    struct DataFrame *data_frame_ptr = NULL;  // 数据帧定义
    while (1) {
        PrivSemaphoreObtainWait(&queue_buffer_ptr->full, NULL);  // 尝试获取循环队列队头元素，如果获取信号量失败，则等待信号量
#ifdef BSP_BLE_CONFIG                                        // 使能蓝牙配置功能
        /* 获取互斥锁 */
        PrivMutexObtain(&adapter->lock);          // 若其他线程正在使用adapter，则阻塞等待
        PrivMutexObtain(&romConfigurationMutex);  // 若其他线程正在读取或者写入CFG，则阻塞等待;

        /* 尝试连接服务器 */
        sprintf(server_ip_address, "%u.%u.%u.%u", CFG->destinationIpAddress_Ethernet[0], CFG->destinationIpAddress_Ethernet[1],
                CFG->destinationIpAddress_Ethernet[2], CFG->destinationIpAddress_Ethernet[3]);
        sprintf(server_port, "%u", (unsigned short)CFG->destinationPort_Ethernet[0] | CFG->destinationPort_Ethernet[1] << 8);
        printf("-*-*-*-*sendDataToServerTask_Ethernet*-*-*-*\n");
        printf("server_ip_address:\t%s\n", server_ip_address);
        printf("server_port:\t\t%s\n", server_port);
        printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n");
        int res = AdapterDeviceConnect(adapter, CLIENT, server_ip_address, server_port, IPV4);

        /* 连接失败，则等待10s再次尝试连接 */
        if (res != 0 && res != 0x1D) {
            PrivSemaphoreAbandon(&queue_buffer_ptr->full);  // 释放信号量
            /* 释放互斥锁 */
            PrivMutexAbandon(&romConfigurationMutex);
            PrivMutexAbandon(&adapter->lock);
            printf("Ethernet connect to server failed\n");  // 连接失败，打印错误信息
            PrivTaskDelay(1000 * 10);                       // 延迟10秒，避免网络拥塞
            continue;
        }
#else
        /* 尝试连接到服务器 */
        sprintf(server_ip_address, "%u.%u.%u.%u", CFG->destinationIpAddress_Ethernet[0], CFG->destinationIpAddress_Ethernet[1],
                CFG->destinationIpAddress_Ethernet[2], CFG->destinationIpAddress_Ethernet[3]);
        sprintf(server_port, "%u", (unsigned short)CFG->destinationPort_Ethernet[0] | CFG->destinationPort_Ethernet[1] << 8);
        printf("-*-*-*-*sendDataToServerTask_Ethernet*-*-*-*\n");
        printf("server_ip_address:\t%s\n", server_ip_address);
        printf("server_port:\t\t%s\n", server_port);
        printf("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n");
        int reconnect_count = RECONNECT_COUNT;  // 尝试重新连接服务器最多RECONNECT_COUNT次
        while (reconnect_count > 0) {
            int res = AdapterDeviceConnect(adapter, CLIENT, server_ip_address, server_port, IPV4);  // 尝试连接服务器
            if (res == 0 || res == 0x1D) {
                break;
            }
            reconnect_count--;
        }
        if (reconnect_count <= 0) {                          // 若RECONNECT_COUNT次都连接失败，则等待10s再次尝试连接
            PrivSemaphoreAbandon(&queue_buffer_ptr->full);      // 释放信号量
            printf("Ethernet connect to server failed\n");  // 连接失败，打印错误信息
            PrivTaskDelay(1000 * 10);                       // 延迟10秒，避免网络拥塞
            continue;
        }
#endif
        PrivMutexObtain(&queue_buffer_ptr->mutex);   // 获取互斥锁
        data_frame_ptr = PollBuffer(queue_buffer_ptr);   // 从队列中获取数据帧
        PrivMutexAbandon(&queue_buffer_ptr->mutex);  // 释放互斥锁

        int resend_count = RESEND_COUNT;  // 定义数据帧重发次数

        /* 只有数据帧非空并且还有剩余重发次数，才进行发送 */
        while (data_frame_ptr != NULL && resend_count > 0) {
            /* 向服务器发送数据 */
            printf("send data to server, id: %s\n", data_frame_ptr->id);
            printf("data_frame_ptr->data: %s", data_frame_ptr->data);
            AdapterDeviceSend(adapter, data_frame_ptr->data,
                            strlen(data_frame_ptr->data));  // 发送数据，注意当前最多发送256字节

            /* 从服务器接收响应，约定服务器接收完数据帧后，返回数据帧中的前12个字节，即数据帧id */
            memset(receive_buffer, 0, sizeof(receive_buffer));
            PrivTaskDelay(6000);
            if (AdapterDeviceRecv(adapter, receive_buffer, strlen(data_frame_ptr->id)) == strlen(data_frame_ptr->id)) {
                /* 打印服务器响应 */
                printf("receive_buffer: ");
                for (int i = 0; i < strlen(receive_buffer); i++) {
                    printf("%c", receive_buffer[i]);
                }
                printf("\n");
                /* 比较服务器响应的内容与发送的数据帧id是否一致 */
                if (strstr(data_frame_ptr->id, receive_buffer) != NULL) {
                    break;  // 接收成功，退出循环
                }
            }
            resend_count--;
        }
        if (data_frame_ptr != NULL) {
            PrivFree(data_frame_ptr);  // 释放数据帧内存
            data_frame_ptr = NULL;     // 避免野指针
        }
        AdapterDeviceDisconnect(adapter, NULL);
#ifdef BSP_BLE_CONFIG
        /* 释放互斥锁 */
        PrivMutexAbandon(&romConfigurationMutex);
        PrivMutexAbandon(&adapter->lock);
#endif
        if (resend_count <= 0) {        // 如果数据帧重发次数超过上限，表示发送失败，丢弃该帧
            PrivTaskDelay(1000 * 10);  // 延迟10秒，避免网络拥塞
        }
    }
    return NULL;
}
 
 /**
  * @brief  开启从DTZ178接收数据的线程以及上传数据到服务器的线程，此方法在main方法中被调用，开机或复位启动
  */
void StartUpTransformDataTask(void) {
    /* 分配循环队列空间 */
    struct QueueBuffer *queue_buffer_ptr = (struct QueueBuffer *)PrivCalloc(1, sizeof(struct QueueBuffer));
    if (InitBuffer(queue_buffer_ptr) < 0) {
        PrivFree(queue_buffer_ptr);
        return;
    }

    /* 启动从DTZ178接收数据的线程 */
    pthread_attr_t receive_data_from_dtz178_task_attr;
    pthread_args_t receive_data_from_dtz178_task_args;
    receive_data_from_dtz178_task_attr.schedparam.sched_priority = 16;              // 线程优先级
    receive_data_from_dtz178_task_attr.stacksize = 2048;                            // 线程栈大小
    receive_data_from_dtz178_task_args.pthread_name = "ReceiveDataFromDTZ178Task";  // 线程名字
    receive_data_from_dtz178_task_args.arg = queue_buffer_ptr;                          // 线程参数
    pthread_t receive_data_thread;                                               // 线程ID
    PrivTaskCreate(&receive_data_thread, &receive_data_from_dtz178_task_attr, ReceiveDataFromDTZ178Task, &receive_data_from_dtz178_task_args);
    PrivTaskStartup(&receive_data_thread);

    /* 启动上传数据到服务器的线程 */
    pthread_attr_t send_data_to_server_task_attr;
    pthread_args_t send_data_to_server_task_args;
    send_data_to_server_task_attr.schedparam.sched_priority = 16;         // 线程优先级
    send_data_to_server_task_attr.stacksize = 2200;                       // 线程栈大小
    send_data_to_server_task_args.pthread_name = "SendDataToServerTask";  // 线程名字
    send_data_to_server_task_args.arg = queue_buffer_ptr;                     // 线程参数
    pthread_t send_data_thread;                                        // 线程ID
    void *(*start_routine)(void *) = SendDataToServerTask_4G;        // 通过4G模块上传到服务器
    // void *(*start_routine)(void *) = SendDataToServerTask_Ethernet;  // 通过以太网模块上传到服务器
    PrivTaskCreate(&send_data_thread, &send_data_to_server_task_attr, start_routine, &send_data_to_server_task_args);  // 通过4G模块上传到服务器
    PrivTaskStartup(&send_data_thread);
}