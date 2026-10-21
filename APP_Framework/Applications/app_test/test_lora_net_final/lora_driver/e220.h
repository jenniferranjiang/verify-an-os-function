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
* @file:    e220.h
* @brief:   E220 module underlying related configuration driver functions declarations
* @version: 0.1
* @author:  YUNFEI CHU
* @date:    2023/10/01 
*
*/

#include <transform.h>
#include <adapter.h>

#ifndef __E220_H__
#define __E220_H__

// #define __DRIVER_DEBUG__                             // 驱动调试信息输出开关
#ifdef __DRIVER_DEBUG__  
#define DDBG(format,...) printf(format, ##__VA_ARGS__)  
#else  
#define DDBG(format,...)  
#endif // __DRIVER_DEBUG__

#define E220_M0_PATH 32                                  // M0管脚位置
#define E220_M1_PATH 33                                  // M1管脚位置
#define E220_PIN_DRIVER "/dev/pin_dev"                   // PIN驱动名称
#define E220_UART_DRIVER "/dev/uart2_dev2"               // UART驱动名称
#define E220_ADDRESS 0XA                                 // 地址默认值
#define E220_DAFAULT_SERIAL_TIMEOUT 3000                 // 串口默认3S超时
#define E220_DEFAULT_CONFIG_BAUD_RATE BAUD_RATE_9600     // 在进行寄存器参数配置时，除了波特率本身的配置外，其他的配置只能在9600进行配置
#define E220_DEFAULT_CONFIG_BAUD_RATE_BYTE 0X60          // 9600波特率
#define E220_DEFAULT_USED_BAUD_RATE BAUD_RATE_115200     // 在进行使用时可以切换为该波特率，但是在配置时需要切换回配置波特率（9600）
#define E220_DEFAULT_USED_BAUD_RATE_BYTE 0XE0            // 115200波特率

#define E220_MAX_CHANNEL_NUMBER 83                       // E220最多支持84个信道，0～83
#define E220_DEFAULT_CHANNEL 0XA                         // 默认通道

#define E220_DEFAULT_AIR_RATE 0X0                        // 默认模块以2.4K的空中速率进行通信

#define E220_DEFAULT_TRANS_MODE 0X40                     // 默认使用定点传输传输模式
#define E220_CONFIG_DELAY 1000                           // 配置的硬件响应时间

#define E220_YES 0XFF
#define E220_NO 0X00

enum LoraMode                        // E220工作模式，支持四种，配置模式与休眠模式一致
{
    MODE_TRANSFER_MODE = 0,          // M0 : M1 = 0 : 0 可发可收
    MODE_WOR_SEND,                   // M0 : M1 = 1 : 0 可发可收
    MODE_WOR_RECV,                   // M0 : M1 = 0 : 1 可收不发
    MODE_CONFIG_SLEEP                // M0 : M1 = 1 : 1 不收不发
};

enum LoraState                       // 硬件状态
{
    STATE_CLOSED,                    // 硬件关闭
    STATE_OPENED,                    // 已正常开启
    STATE_BROKEN                     // 硬件损坏
};

enum LoraTransMode                   // 模块传输模式
{
    TRANS_MODE_HYALINE = 0X0,        // 透明传输
    TRANS_MODE_ORIENTED = 0X40,      // 定点传输
};

enum LoraAirRate                     // 空中速率，通信双方必须设置一致的空中速率方可进行通信
{
    AIR_RATE_2D4K = 0X0,             // 2.4K
    AIR_RATE_4D8K = 0X3,             // 4.8K
    AIR_RATE_9D6K = 0X4,             // 9.6K
    AIR_RATE_19D2K = 0X5,            // 19.2K
    AIR_RATE_38D4K = 0X6,            // 38.4K
    AIR_RATE_62D5K = 0X7             // 62.5K
};

enum LoraConfig                      // 支持IOCTL函数进行配置的配置项枚举,某些项只支持9600波特率配置
{
    CONFIG_SERIAL_TIME_OUT = 0X0,    // 串口超时时间
    CONFIG_LORA_MODE = 0X1,          // 配置Lora模式
    CONFIG_TRANS_MODE = 0X2,         // 配置Lora传输模式(9600)
    CONFIG_AIR_RATE = 0X3,           // 配置空中速率(9600)
    CONFIG_BAUD_RATE = 0X4,          // 配置波特率
    CONFIG_ADDRESS = 0X5,            // 配置设备地址(9600)
    CONFIG_CHANNEL = 0X6,            // 配置设备信道(9600)
    CONFIG_SHOW = 0X7                // 打印配置信息
};

extern enum LoraMode current_mode;   // 当前模块处于什么模式
extern enum LoraState lora_state;    // 当前模块的状态

/**
 * @brief: 打开硬件设施，开启串口并按照配置的初始化参数配置相关硬件、串口
 *         重复开启会直接返回，开启失败后不能重复尝试
 * @param adapter: 任何状态
 * @return: 0 -> Success ： -1 -> Fail
*/
uint8 E220Open(struct Adapter *adapter);

/**
 * @brief: 关闭硬件设施，关闭串口，同时会将所有的数据回复到原始的配置状态
 *         关闭失败默认为硬件损坏，未开启不可关闭
 * @param adapter: 任何状态
 * @return: 0 -> Success （硬件不是开启状态即成功）： -1 -> Fail （硬件关闭过错报错）
*/
uint8 E220Close(struct Adapter *adapter);

/**
 * @brief: 给处于开启状态的硬件配置相关信息，包括串口配置，寄存器参数等等
 *         支持的配置类型为@LoraConfig
 * @param adapter: 打开状态
 * @param config_item: 配置类型
 * @param args: 配置参数
 * @return: 0 -> Success ： -1 -> Fail 
*/
uint8 E220Ioctl(struct Adapter *adapter, int config_item, void *args);

/**
 * @brief: 通过硬件发送指定长度的数据
 * @param adapter: 打开状态
 * @param buf: 数据缓存区
 * @param len: 缓存区大小
 * @return 0 -> Success（全部发送完毕） : -1 -> Fail（未发送或发送不完整）
*/
uint8 E220Send(struct Adapter *adapter, const void *buf, uint32 len);

/**
 * @brief: 通过硬件接受指定长度的数据到缓冲区
 * @param adapter: 打开状态
 * @param buf: 接受缓冲区
 * @param len: 需要接受的数据长度，该长度小于等于接受缓存区长度
 * @return 0 -> 接收到了指定长度的数据 ： -1 -> 未接受到指定长度的数据或者串口超时
*/
uint8 E220Recv(struct Adapter *adapter, void *buf, uint32 len);
#endif // __E220_H__
