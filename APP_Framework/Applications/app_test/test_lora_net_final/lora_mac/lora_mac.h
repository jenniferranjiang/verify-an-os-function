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
* @file:    lora_mac.h
* @brief:   Definition of data structures related to the Lora private protocol
* @version: 0.1
* @author:  YUNFEI CHU
* @date:    2023/10/01 
*
*/

#include <transform.h>
#include <adapter.h>
#include "../lora_driver/e220.h"

// #define AS_LORA_GATEWAY

/*数据帧**************************************************************************/
#define FRAME_BEGIN_MARK 0x3C3C                                              // 帧开始标志，高低字节相同
#define FRAME_END_MARK 0X5A5A                                                // 帧结束标志，高低字节相同
#define FRAME_MAX_DATA_LENGTH 200                                            // 默认支持的最大数据包为200字节
#define FRAME_ADDR_INFO_LENGTH 3                                             // 定点传输时前三字节为地址和信道共三个字节
#define FRAME_META_LENGTH 14                                                 // 数据帧相关信息长度
#define FRAME_MAX_USER_DATA_LENGTH FRAME_MAX_DATA_LENGTH - FRAME_META_LENGTH - FRAME_ADDR_INFO_LENGTH
#define FRAME_CRC_INDEX_BEGIN 2                                              // CRC校验开始地址
#define FRAME_CRC_LENGTH 8                                                   // CRC校验元数据量长度
#define FRAME_BYTE_OK 0XFF                                                   // 是/成功
#define FRAME_BYTE_NO 0X00                                                   // 否/失败
#define FRAME_NECK_LENGTH 8                                                  // 帧头以下，额外数据以上的长度
#define FRAME_FOOT_LENGTH 4                                                  // 额外数据以下至帧尾的数据长度
#define FRAME_MARK_LENGTH 2                                                  // 帧头帧尾的数据长度

enum FrameType                  // 数据帧类型枚举
{
    E_G_JOIN = 0,               // 客户端入网请求，需回复
    E_G_QUIT,                   // 客户端退网请求，不需回复
    E_G_DATA,                   // 客户端上传数据，需回复
    G_E_ANS,                    // 网关响应客户端请求
};

struct LoraFrame                // 数据帧消息类型
{
    uint16 begin_mark;          // 开始标志 0x3C3C
    uint16 session_id;          // 会话ID，客户端每次数据上传会随机设置，若是回复ID不一致则表示数据丢失
    uint16 dev_addr;            // 设备地址，特指终端地址，网关地址固定为 0XFFFF
    uint8 down_channel;         // 下行通道，即终端所在的信道
    uint8 frame_type;           // 数据帧的类型
    uint8 frame_confirm;        // 该数据帧是否需要确认回复
    uint8 frame_attach;         // 用于携带简单的数据，例如用户数据长度
    uint8 *user_data;           // 需要额外携带的大量数据
    uint8 crc_hi;               // 校验位高字节
    uint8 crc_lo;               // 校验位低字节
    uint16 end_mark;            // 结束标志 0X5A5A
};

extern struct LoraFrame send_frame;                             // 数据帧发送缓冲区
extern struct LoraFrame recv_frame;                             // 数据帧接受缓存区
extern uint8 send_data_buffer[FRAME_MAX_USER_DATA_LENGTH];      // 数据发送缓冲区
extern uint8 recv_data_buffer[FRAME_MAX_USER_DATA_LENGTH];      // 数据接受缓存区
extern uint8 total_data_buffer[FRAME_MAX_DATA_LENGTH];          // 数据帧加数据的最大缓冲区

/**
 * @brief: 将数据帧缓冲区置为 0 ，并添加帧头，帧尾数据
 * @param frame: 数据帧缓冲区
*/
void InitLoraFrame(struct LoraFrame* frame);                  

/**
 * @brief: 打印数据帧结构信息，便于运行、开发调试
 * @param fram: 需要打印的数据帧
 * @param prefix: 那里打印的数据帧信息
*/
void ShowLoraFrame(struct LoraFrame* frame,char* prefix);                   

/**
 * @brief: 计算数据帧的校验值，除去帧头、帧尾、校验值本身，若是应该携带数据的类型未携带数据时报错
 * @return: 消息类型和数据不匹配时为 -1
*/
uint8 CalCrlLoraFrame(struct LoraFrame* frame);

/**
 * @brief: 校验数据帧的完整性
 * @return: 校验失败为 -1
*/
uint8 CheckCrcLoraFrame(struct LoraFrame* frame);
/*数据帧**************************************************************************/

/*基础操作************************************************************************/
#define LORA_ADAPTER_NAME "e220"                // Lora适配器名称
#define LORA_OK 0XFF                            // 标识成功、确认等
#define LORA_NO 0X00                            // 标识失败、丢失等
#define LORA_TIME_ON_AIR 2                      // 估计的空中时间
#define LORA_AIR_RATE 0                         // 模块的空中速率
#define LORA_FRAME_RETRY 5                      // 数据帧重传次数，超过这个次数判定断网
#define LORA_GATEWAY_MAX_NODE 20                // 每个网关支持的最大客户端个数，防止上行通道过于拥挤
#define LORA_GATEWAY_ADDRESS 0XFFFF             // 网关地址，单信道网关的监听地址

#ifdef AS_LORA_GATEWAY

#define LORA_RECV_TIME 10                       // 串口超时时间
#define LORA_GATEWAY_CHANNEL 0XA                // 网关默认信道

#else

#define LORA_ADDRESS 0X9                        // 节点默认地址
#define LORA_RECV_TIME 5                        // 节点默认串口超时时间
#define LORA_DOWN_CHANNEL 0X9                   // 节点默认下行信道
#define LORA_UP_CHANNEL 0XA                     // 节点默认上行通道
#define LORA_ADR_ENABLE LORA_NO                 // 节点是否开启网关自动搜索
#define LORA_RECONNECT_ENABLE LORA_OK           // 节点是否开启断网自动重联

#endif

/**
 * @brief: 从硬件获取一个完整的数据帧
 * @param recv_buffer: 数据帧缓冲区，在检测到带数据的数据帧时会自动关联数据缓冲区
 * @param prefix: 调用位置，便于调试
 * @return 0: 成功接受到一个数据帧（从侦测到数据帧头部开始、成功接受到帧尾部且数据校验成功）
 *         -1：串口超时；数据帧接受不完整；数据帧完整性校验失败；
*/
uint8 LoraRecvFrame(struct Adapter* adapter, struct LoraFrame* recv_buffer);

/**
 * @brief: 通过硬件向指定的位置的信道发送数据
 * @param send_buffer: 数据帧缓冲区，在检测到带数据的数据帧时会自动发送关联数据缓冲区
 * @param addr: 目标的地址
 * @param channel: 目标的信道
 * @return 0: 成功发送指定长度的数据
 *         -1：未能成功发送制定数据
*/
uint8 LoraSendFrame(struct Adapter* adapter, struct LoraFrame* send_buffer,uint16 addr,uint8 channel);

/**
 * @brief: 在一轮超时后未能接收到信号时判定信道空闲
 * @param download_channel: 下行信道
 * @param upload_channel: 上行信道
*/
void SignalDetector(struct Adapter *adapter,uint8 download_channel,uint8 upload_channel);

/**
 * @brief: 获取随机数，用于客户端和网关之间的会话
*/
uint16 GetSessionId(void);

/**
 * @brief: 获取操作函数集合，客户端和网关各自实现
*/
AdapterProductInfoType LoraAttach(struct Adapter *adapter);

/**
 * @brief: 注册函数，需要各自实现
*/
uint8 UsrAdapterLoraRegister(struct Adapter *adapter);

/**
 * @brief: 框架初始化函数，需要替换掉原有的初始化函数
*/
int UsrAdapterLoraInit(void);

/*基础操作************************************************************************/

/*客户端操作************************************************************************/
enum EndNodeState                     //节点状态
{
    NODE_STATE_DISCONNECT = 0,        // 硬件开启，但是没有联网，后台程序可能开启
    NODE_STATE_CONNECT,               // 硬件开启，已经联网，后台程序可能开启
    NODE_STATE_BROKEN,                // 硬件损坏，无后台程序
    NODE_STATE_CLOSED                 // 硬件关闭，无后台程序
};

struct EndNodeParam                   // 节点参数结构
{
    uint16 dev_addr;                  // 设备地址信息
    uint8 down_channel;               // 下行通道，终端可以接收信息的信道
    uint8 upload_channel;             // 上行通道，终端可以给网关发送信息的信道
    uint16 session_id;                // 会话ID，用于判定数据帧是否存在丢失

    enum EndNodeState node_state;     // 客户端状态
    enum LoraAirRate air_rate;        // 终端的空中速率
    uint8 adr_enable;                 // 终端是否开启自动寻找上行网关
    uint8 reconnect_enable;           // 终端断网自动重联
    uint8 recv_time;                  // 接受下行消息的时间窗口长度，单位为秒
};

extern struct EndNodeParam node_param;                                      // 客户端参数
extern int (*node_handlers[])(struct Adapter*,struct LoraFrame*);           // 客户端处理流程

/**
 * @brief: 打开终端硬件，按照配置的CLASS决定是否开启硬件接收和后台处理程序
 * @return: 0 -> Success : -1 -> Fail
*/
int NodeOpen(struct Adapter *adapter);

/**
 * @brief: 关闭终端硬件设施和后台处理程序
 * @return: 0 -> Success : -1 -> Fail
*/
int NodeClose(struct Adapter *adapter);

/**
 * @brief: 终端接入网关，向该上行通道发送入网请求
 * @param adapter: 已经打开的适配器
 * @param net_group: 需要加入的网络编号
 * @return: 0 -> Success : -1 -> Fail
*/
int NodeJoin(struct Adapter *adapter, unsigned char *net_group);

/**
 * @brief: 发送数据到网关
 * @param adapter: 已经联网的适配器
 * @param buf: 待发送数据
 * @param len: 待发送数据长度
 * @return: 0 -> Success : -1 -> Fail
*/
int NodeSend(struct Adapter *adapter, const void *buf, size_t len);

/**
 * @brief: 终端退出某个网络
 * @param adapter: 已经联网的适配器
 * @param net_group: 需要退出的网络编号
 * @return: 0 -> Success : -1 -> Fail
*/
int NodeQuit(struct Adapter *adapter, unsigned char *net_group);

/**
 * @brief: 打印终端的信息
*/
int NodeNetState(struct Adapter *adapter);

/*客户端操作************************************************************************/

/*网关操作*************************************************************************/
struct EndNodeInfo                                         // 网关存储的客户端信息
{
    uint16 node_addr;                                      // 客户端地址
    uint8 node_down_channel;                               // 客户端下行通道
    uint16 session_id;                                     // 上一个命令的会话ID
};

enum GatewayState                   // 网关的状态枚举
{
    GATEWAY_CLOSED,                 // Lora还没有打开
    GATEWAY_OPENED,                 // 已打开，但是未开始工作
    GATEWAY_WORKING,                // 正常打开且已经开始正常工作
    GATEWAY_BROKEN                  // 模块损坏
};

struct GatewayParam                                                   // 网关参数
{
    uint16 dev_addr;                                                  // 设备ID
    uint8 channel;                                                    // 网络编号

    int recv_time;                                                    // 串口超时时间
    enum LoraAirRate air_rate;                                        // 网关空中速率
    uint8 frame_retry;                                                // 重传次数
    enum GatewayState gateway_state;                                  // 网关状态
    struct EndNodeInfo *node_infos[LORA_GATEWAY_MAX_NODE];            // 客户端信息
    uint16 node_count;                                                // 已链接客户端数量
};

extern struct GatewayParam gateway_param;                             // 网关参数
extern int (*gateway_handlers[])(struct Adapter*,struct LoraFrame*);  // 处理程序

/**
 * @brief: 打开Lora硬件设施，但是不会将其接入网络中
*/
int GatewayOpen(struct Adapter *adapter);

/**
 * @brief: 关闭硬件设施，需要先断网
*/
int GatewayClose(struct Adapter *adapter);

/**
 * @brief: 配置网关参数的配置接口，这个函数配置的是网关的参数
*/
int GatewayIoctl(struct Adapter *adapter, int cmd, void *args);

/**
 * @brief: 启用网关，使其可以为其他终端服务
*/
int GatewaySetup(struct Adapter *adapter);

/**
 * @brief: 停用网关，但是不会给网络中的终端下线通知
*/
int GatewaySetDown(struct Adapter *adapter);

/**
 * @brief: 打印网关相关信息
*/
int GatewayNetState(struct Adapter *adapter);

/**
 * @brief: 网关主任务，负责终端各项事务的自动化处理
*/
void* GatewayTask(void* adapter);

/**
 * @brief: 处理终端入网请求
*/
int GatewayJoinHandler(struct Adapter* adapter,struct LoraFrame* frame);

/**
 * @brief: 处理终端退网
*/
int GatewayQuitHandler(struct Adapter* adapter,struct LoraFrame* frame);

/**
 * @brief: 处理终端数据传输
*/
int GatewayDataSendHandler(struct Adapter* adapter,struct LoraFrame* frame);

/*网关操作*************************************************************************/