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
* @file:    lora_mac.c
* @brief:   Lora private network protocol related data structure implementation
* @version: 0.1
* @author:  YUNFEI CHU
* @date:    2023/10/01 
*
*/

#include "lora_mac.h"

static const uint8 crc_hi_table[] =
    {
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40
    };

static const uint8 crc_lo_table[] =
    {
        0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06, 0x07, 0xC7, 0x05, 0xC5, 0xC4, 0x04,
        0xCC, 0x0C, 0x0D, 0xCD, 0x0F, 0xCF, 0xCE, 0x0E, 0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09, 0x08, 0xC8,
        0xD8, 0x18, 0x19, 0xD9, 0x1B, 0xDB, 0xDA, 0x1A, 0x1E, 0xDE, 0xDF, 0x1F, 0xDD, 0x1D, 0x1C, 0xDC,
        0x14, 0xD4, 0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3, 0x11, 0xD1, 0xD0, 0x10,
        0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3, 0xF2, 0x32, 0x36, 0xF6, 0xF7, 0x37, 0xF5, 0x35, 0x34, 0xF4,
        0x3C, 0xFC, 0xFD, 0x3D, 0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A, 0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38,
        0x28, 0xE8, 0xE9, 0x29, 0xEB, 0x2B, 0x2A, 0xEA, 0xEE, 0x2E, 0x2F, 0xEF, 0x2D, 0xED, 0xEC, 0x2C,
        0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26, 0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0,
        0xA0, 0x60, 0x61, 0xA1, 0x63, 0xA3, 0xA2, 0x62, 0x66, 0xA6, 0xA7, 0x67, 0xA5, 0x65, 0x64, 0xA4,
        0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F, 0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 0x69, 0xA9, 0xA8, 0x68,
        0x78, 0xB8, 0xB9, 0x79, 0xBB, 0x7B, 0x7A, 0xBA, 0xBE, 0x7E, 0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C,
        0xB4, 0x74, 0x75, 0xB5, 0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71, 0x70, 0xB0,
        0x50, 0x90, 0x91, 0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54,
        0x9C, 0x5C, 0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E, 0x5A, 0x9A, 0x9B, 0x5B, 0x99, 0x59, 0x58, 0x98,
        0x88, 0x48, 0x49, 0x89, 0x4B, 0x8B, 0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C,
        0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83, 0x41, 0x81, 0x80, 0x40
    };

// 相关数据缓冲区，全局变量
struct LoraFrame send_frame;                             // 数据帧发送缓冲区
struct LoraFrame recv_frame;                             // 数据帧接受缓存区
uint8 send_data_buffer[FRAME_MAX_USER_DATA_LENGTH];      // 数据发送缓冲区
uint8 recv_data_buffer[FRAME_MAX_USER_DATA_LENGTH];      // 数据接受缓存区
uint8 total_data_buffer[FRAME_MAX_DATA_LENGTH];          // 数据帧加数据的最大缓冲区

void InitLoraFrame(struct LoraFrame* frame)
{
    // 数据清空
    memset(frame,0,sizeof(struct LoraFrame));
    // 设置帧头、帧尾
    frame->begin_mark = FRAME_BEGIN_MARK;
    frame->end_mark = FRAME_END_MARK;
}

void ShowLoraFrame(struct LoraFrame* frame,char* prefix)
{
    printf("%s -> ",prefix);
    printf("session_id:%d,dev_addr:%X,down_channel:%X,frame_confirm:%X ",frame->session_id,frame->dev_addr,frame->down_channel,frame->frame_confirm);
    switch (frame->frame_type)
    {       
    case E_G_JOIN:
        printf("-E_G_JOIN-");
        break;
    case E_G_QUIT:
        printf("-E_G_QUIT-");
        break;
    case E_G_DATA:
        printf("-E_G_DATA-");
        printf("user_data:%s ",frame->user_data);
        break;
    case G_E_ANS:
        printf("-G_E_ANS-");
        break;
    }
    printf("frame_attach:%d,crc_hi:%X,crc_lo:%X\n",frame->frame_attach,frame->crc_hi,frame->crc_lo);
}

void CalCrcByte(uint8* data, uint8 data_length,unsigned int* temp,uint8* crc_hi,uint8* crc_lo)
{
    for (int i = 0; i < data_length; i++)
    {
        *temp = *crc_hi ^ *data++;
        *crc_hi = *crc_lo ^ crc_hi_table[*temp];
        *crc_lo = crc_lo_table[*temp];
    }
}

uint8 CalCrlLoraFrame(struct LoraFrame* frame)
{
    uint8 crc_hi = 0xFF;
    uint8 crc_lo = 0xFF;
    unsigned int temp;
    // 转化为字节的方式进行数据访问
    uint8 *bit_arr = (uint8 *)frame;                                    
    // 计算除开帧头后面11位元数据的校验值
    CalCrcByte(bit_arr + FRAME_CRC_INDEX_BEGIN,FRAME_CRC_LENGTH,&temp,&crc_hi,&crc_lo);
    if (frame->frame_type == E_G_DATA) 
    {
        // 数据传输必须要携带数据，否则就是出错
        if (frame->frame_attach != 0 && frame->user_data != NULL)
        {
            // 计算用户数据的校验值
            CalCrcByte(frame->user_data,frame->frame_attach,&temp,&crc_hi,&crc_lo);
        }
        else
        {
            printf("CalCrlLoraFrame: have no data!\n");
            return -1;
        }
    }
    frame->crc_lo = crc_lo;
    frame->crc_hi = crc_hi;
    return 0;
}

uint8 CheckCrcLoraFrame(struct LoraFrame* frame)
{
    uint8 crc_hi_tmp = frame->crc_hi;
    uint8 crc_lo_tmp = frame->crc_lo;
    
    if (0 == CalCrlLoraFrame(frame))
    {
        if (crc_hi_tmp == frame->crc_hi && crc_lo_tmp == frame->crc_lo)
        {
            return 0;
        }
    }
    return -1;
}

static const uint16 header_mark = FRAME_BEGIN_MARK & 0XFF; // 数据帧头部
static const uint16 tail_mark = FRAME_END_MARK & 0XFF;     // 数据帧尾部
static uint16 header_buffer = 0;                           // 用于数据帧头部检测

uint8 LoraRecvFrame(struct Adapter *adapter, struct LoraFrame *recv_buffer)
{
    if (lora_state != STATE_OPENED)
    {
        printf("LoraRecvFrame-Fail: lora closed or broken!\n");
        return -1;
    }
    // 初始化接受缓冲区
    memset(recv_buffer, 0, sizeof(struct LoraFrame));

    header_buffer = 0;
    // 用于查找数据帧的帧头
    uint8 *header_temp = (uint8*)(&header_buffer);
    // 查找数据帧的开始标志
    while (1 == E220Recv(adapter, &header_temp[1], 1)) // 查找开始标志
    {
        // 找到了开始标识的一半
        if (header_mark == header_temp[1])
        {
            // 判断上一个字节是否是开始标志，若是，则已找到，若不是，则继续
            if (header_temp[1] == header_temp[0])
            {
                recv_buffer->begin_mark = FRAME_BEGIN_MARK;
                // 接收帧头以下，用户数据以上的数据
                if (FRAME_NECK_LENGTH == E220Recv(adapter, &recv_buffer->session_id, FRAME_NECK_LENGTH))
                {
                    // 查看是否有用户数据
                    if (E_G_DATA == recv_buffer->frame_type)
                    {
                        // 如果携带了用户数据则接收用户数据
                        if (0 != recv_buffer->frame_attach)
                        {
                            // 重置用户数据缓冲区
                            memset(recv_data_buffer, 0, FRAME_MAX_USER_DATA_LENGTH);
                            // 接收用户数据
                            if (recv_buffer->frame_attach != E220Recv(adapter, recv_data_buffer, recv_buffer->frame_attach))
                            {
                                printf("LoraRecvFrame-Fail: recv user data fail!\n");
                                header_buffer = 0;
                                break;
                            }
                            // 将数据嫁接到数据帧
                            recv_buffer->user_data = recv_data_buffer;
                        }
                    }
                    // 开始接受最后的数据
                    if (FRAME_FOOT_LENGTH != E220Recv(adapter,&recv_buffer->crc_hi,FRAME_FOOT_LENGTH))
                    {
                        printf("LoraRecvFrame-Fail: recv foot frame fail!\n");
                        header_buffer = 0;
                        break;
                    }
                    // 开始检查数据帧尾巴是否正确
                    if (FRAME_END_MARK != recv_buffer->end_mark)
                    {
                        printf("LoraRecvFrame-Fail: frame end mark err!\n");
                        header_buffer = 0;
                        break;
                    }
                    // 开始进行数据帧校验
                    if (0 != CheckCrcLoraFrame(recv_buffer))
                    {   
                        printf("LoraRecvFrame-Fail: check frame crc fail!\n");
                        header_buffer = 0;
                        break;
                    }
                    // 接受数据帧成功
                    ShowLoraFrame(recv_buffer,"LoraRecvFrame");
                    header_buffer = 0;
                    return 0;
                }
                else
                {
                    printf("LoraRecvFrame-Fail: recv neck frame fail!\n");
                    header_buffer = 0;
                    break;
                }
            }
        }
        // 将接受到的数据放置在上一个位置
        header_temp[0] = header_temp[1];
    }
    header_buffer = 0;
    return -1;
}

uint8 LoraSendFrame(struct Adapter* adapter, struct LoraFrame* send_buffer,uint16 addr,uint8 channel)
{
    // 判断lora是否已经正确开启
    if (lora_state != STATE_OPENED)
    {
        printf("LoraSendFrame-Fail: lora closed or broken!\n");
        return -1;
    }
    // 计算数据帧的校验值
    if (0 != CalCrlLoraFrame(send_buffer))
    {
        printf("LoraSendFrame-Fail: cal_crc fail!\n");
        return -1;
    }
    // 记录整个数据帧的长度
    int fram_length = 0;
    // 重置数据发送缓冲区
    memset(&total_data_buffer,0,FRAME_MAX_DATA_LENGTH);
    // 组装目标地址
    total_data_buffer[0] = (addr >> 8) & 0XFF;
    total_data_buffer[1] = addr & 0XFF;
    total_data_buffer[2] = channel;
    fram_length += 3;

    // 数据帧前半部分
    memcpy(&total_data_buffer[fram_length],send_buffer,FRAME_META_LENGTH - FRAME_FOOT_LENGTH);
    fram_length += (FRAME_META_LENGTH - FRAME_FOOT_LENGTH);
    // 用户额外数据
    if (E_G_DATA == send_buffer->frame_type)
    {
        memcpy(&total_data_buffer[fram_length],send_buffer->user_data,send_buffer->frame_attach);
        fram_length += send_buffer->frame_attach;
    }
    // 剩下来的数据
    memcpy(&total_data_buffer[fram_length],&send_buffer->crc_hi,FRAME_FOOT_LENGTH);
    fram_length += FRAME_FOOT_LENGTH;
    // 发送所有数据
    if (0 != E220Send(adapter,&total_data_buffer,fram_length))
    {
        printf("LoraSendFrame-Fail: send fail!\n");
        return -1;
    }
    ShowLoraFrame(send_buffer,"LoraSendFrame");
    return 0;
}

uint16 GetSessionId(void)
{
    return rand() & 0XFFFF;
}

void SignalDetector(struct Adapter *adapter,uint8 download_channel,uint8 upload_channel)
{
    // 切换至上行信道,客户端上行通道为广播信息(地址为OXFFFF),该信道所有终端都可以接收到
    E220Ioctl(adapter,CONFIG_CHANNEL,&upload_channel);
    // 监听信道
    uint8 temp_dst;
    while (1 == E220Recv(adapter, &temp_dst, 1))
    {
        printf("LoraSignalDetector-Fail: Channel occupied!\n");
    }
    // 切换至切换至下行通道,准备发送数据
    E220Ioctl(adapter,CONFIG_CHANNEL,&download_channel);
    printf("LoraSignalDetector-Success: Channel idle!\n");
}

int UsrAdapterLoraInit(void)
{
    struct Adapter *adapter = PrivMalloc(sizeof(struct Adapter));
    if (!adapter)
    {
        PrivFree(adapter);
        return -1;
    }
    memset(adapter, 0, sizeof(struct Adapter));
    // Adapter注册函数，终端和网关需要自己实现并开放接口
    if (0 != UsrAdapterLoraRegister(adapter))
    {
        printf("UsrAdapterLoraInit-Fail: register lora adapter error\n");
        PrivFree(adapter);
        return -1;
    }
    // 获取函数操作集合，终端和网关需要自己实现并开放接口
    AdapterProductInfoType product_info = LoraAttach(adapter);
    if (NULL == product_info)
    {
        printf("UsrAdapterLoraInit-Fail: e220 attach error\n");
        PrivFree(adapter);
        return -1;
    }
    // 配置Adapter属性
    adapter->product_info_flag = 1;
    adapter->info = product_info;
    adapter->done = product_info->model_done;
    adapter->adapter_status = REGISTERED;
    // 创建信号量和互斥量
    PrivSemaphoreCreate(&adapter->sem, 0, 0);
    PrivMutexCreate(&adapter->lock, 0);

    printf("UsrAdapterLoraInit-Success!\n");
    return 0;
}

#ifdef AS_LORA_GATEWAY

struct GatewayParam gateway_param =         // 网关配置参数
{
    .dev_addr = LORA_GATEWAY_ADDRESS,
    .channel = LORA_GATEWAY_CHANNEL,
    .recv_time = LORA_RECV_TIME,
    .air_rate = LORA_AIR_RATE,
    .frame_retry = LORA_FRAME_RETRY,
    .gateway_state = GATEWAY_CLOSED,
    .node_infos = {NULL},
    .node_count = 0,
};

struct PrivProtocolDone gateway_done =      // 网关操作函数集合
{
    .open = GatewayOpen,
    .close = GatewayClose,
    .ioctl = GatewayIoctl,
    .setup = GatewaySetup,
    .setdown = GatewaySetDown,
    .netstat = GatewayNetState
};

int (*gateway_handlers[])(struct Adapter*,struct LoraFrame*) =  // 网关处理程序
{
    [E_G_JOIN] = GatewayJoinHandler,
    [E_G_QUIT] = GatewayQuitHandler,
    [E_G_DATA] = GatewayDataSendHandler,
};

static UtaskType gateway_task;              // 网关任务
static int32 gateway_task_id = -1;          // 任务ID

/**
 * @brief: 根据地址和信道定位到终端的信息
*/
static struct EndNodeInfo* GetEndNodeInfo(uint16 node_addr,uint8 channel)
{
    for (int i = 0; i < gateway_param.node_count; i++)
    {
        if (node_addr == gateway_param.node_infos[i]->node_addr && channel == gateway_param.node_infos[i]->node_down_channel)
        {
            return gateway_param.node_infos[i];
        }
    }
    return NULL;
}

int GatewayOpen(struct Adapter *adapter)
{
    switch (gateway_param.gateway_state)
    {
    case GATEWAY_WORKING: case GATEWAY_OPENED:
        printf("GatewayOpen-Success: lora already opened before!\n");
        return 0;
    case GATEWAY_BROKEN: 
        printf("GatewayOpen-Fail: lora broken!\n");
        return -1;
    case GATEWAY_CLOSED:
        PrivMutexObtain(&adapter->lock);
        // 打开底层硬件
        if (0 != E220Open(adapter))
        {
            gateway_param.gateway_state = GATEWAY_BROKEN;
            PrivMutexAbandon(&adapter->lock);
            return -1;
        }
        // 按照网关的配置信息配置底层的硬件
        uint32 recv_time = gateway_param.recv_time * 1000;
        if (0 != E220Ioctl(adapter,CONFIG_CHANNEL,&gateway_param.channel) 
            || 0 != E220Ioctl(adapter,CONFIG_ADDRESS,&gateway_param.dev_addr)
            || 0 != E220Ioctl(adapter,CONFIG_AIR_RATE,&gateway_param.air_rate)
            || 0 != E220Ioctl(adapter,CONFIG_SERIAL_TIME_OUT,&recv_time))
        {
            printf("GatewayOpen-Fail: config gateway fail -> channel: %X,address: %X,air_rate: %X!\n",gateway_param.channel,gateway_param.dev_addr,gateway_param.air_rate);
            gateway_param.gateway_state = GATEWAY_BROKEN;
            PrivMutexAbandon(&adapter->lock);
            return -1;
        }
        // 更新网关的状态信息
        gateway_param.gateway_state = GATEWAY_OPENED;
        printf("GatewayOpen-Success: channel: %X,address: %X!\n",gateway_param.channel,gateway_param.dev_addr);
        PrivMutexAbandon(&adapter->lock);
        return 0;
    default:
        printf("GatewayOpen-Fail: unknown gateway state!\n");
        return -1;
    }
}

int GatewayClose(struct Adapter *adapter)
{
    switch (gateway_param.gateway_state)
    {
    case GATEWAY_CLOSED: case GATEWAY_BROKEN:
        printf("GatewayClose-Success: lora close or broken before!\n");
        return 0;
    case GATEWAY_WORKING:
        printf("GatewayClose-Fail: quit net before close!\n");
        return -1;
    case GATEWAY_OPENED:
        PrivMutexObtain(&adapter->lock);
        if (0 != E220Close(adapter))
        {
            gateway_param.gateway_state = GATEWAY_BROKEN;
            printf("GatewayClose-Fail: close lora fail!\n");
            PrivMutexAbandon(&adapter->lock);
            return -1;
        }
        gateway_param.gateway_state = GATEWAY_CLOSED;
        printf("GatewayClose-Success\n");
        PrivMutexAbandon(&adapter->lock);
        return 0;
    default:
        printf("GatewayClose-Fail: unknown err!\n");
        return -1;
    }
}

int GatewayIoctl(struct Adapter *adapter, int cmd, void *args)
{
    switch (gateway_param.gateway_state)
    {
    case GATEWAY_WORKING: case GATEWAY_BROKEN: case GATEWAY_CLOSED: 
        printf("GatewayIoctl-Fail: cant be config when lora broken、working、clesed!\n");
        return -1;
    case GATEWAY_OPENED:
        PrivMutexObtain(&adapter->lock);
        if (0 != E220Ioctl(adapter, cmd, args))
        {
            gateway_param.gateway_state = GATEWAY_BROKEN;
            printf("GatewayIoctl-Fail: ioctl fail!\n");
            PrivMutexAbandon(&adapter->lock);
            return -1;
        }
        printf("GatewayIoctl-Success\n");
        PrivMutexAbandon(&adapter->lock);
        return 0;
    default:
        printf("GatewayIoctl-Fail: unknown err!\n");
        return -1;
    }
}

int GatewaySetup(struct Adapter *adapter)
{
    if (GATEWAY_BROKEN == gateway_param.gateway_state)
    {
        printf("GatewaySetup-Fail: lora broken!\n");
        return -1;
    }
    if (GATEWAY_CLOSED == gateway_param.gateway_state)
    {
        printf("GatewaySetup-Fail: please open lora before!\n");
        return -1;
    }
    if (GATEWAY_WORKING == gateway_param.gateway_state)
    {
        printf("GatewaySetup-Success: lora setup before!\n");
        return 0;
    }
    PrivMutexObtain(&adapter->lock);
    // 配置硬件传输
    if (0 != E220Ioctl(adapter,CONFIG_LORA_MODE,MODE_TRANSFER_MODE))
    {
        printf("GatewaySetup-Fail: config lora transfer fail!\n");
        PrivMutexAbandon(&adapter->lock);
        return -1;
    }
    
    gateway_task.prio = 24;
    gateway_task.stack_size = 2048;
    gateway_task.func_param = adapter;
    gateway_task.func_entry = GatewayTask;
    strncpy(gateway_task.name, "lora_gateway_task", strlen("lora_gateway_task"));

    gateway_task_id = UserTaskCreate(gateway_task);
    
    if (gateway_task_id < 0)
    {
        printf("GatewaySetup-Fail: create task fail!\n");
        PrivMutexAbandon(&adapter->lock);
        return -1;
    }

    if (0 == UserTaskStartup(gateway_task_id))
    {
        gateway_param.gateway_state = GATEWAY_WORKING;
        printf("GatewaySetup-Success: start task success!\n");
        PrivMutexAbandon(&adapter->lock);
        return 0;
    }
    else
    {
        UserTaskDelete(gateway_task_id);
        gateway_task_id = -1;
        printf("GatewaySetup-Fail: start task fail!\n");
        PrivMutexAbandon(&adapter->lock);
        return -1;
    }
}

int GatewaySetDown(struct Adapter *adapter)
{

    if (GATEWAY_WORKING != gateway_param.gateway_state)
    {
        printf("GatewaySetDown-Success: not in working state!\n");
        return 0;
    }
    // 通知后台程序
    PrivSemaphoreAbandon(&adapter->sem);
    PrivMutexObtain(&adapter->lock);
    if (0 == UserTaskDelete(gateway_task_id))
    {
        gateway_task_id = -1;
        gateway_param.gateway_state = GATEWAY_OPENED;
        printf("GatewaySetDown-Success!\n");
        PrivMutexAbandon(&adapter->lock);
        return 0;
    }
    printf("GatewaySetDown-Fail: delete task fail!\n");
    PrivMutexAbandon(&adapter->lock);
    return -1;
}

int GatewayNetState(struct Adapter *adapter)
{
    printf("GatewayInfos: \n");
    printf("addr:%d,channel:%d,recv_time:%d,",gateway_param.dev_addr,gateway_param.channel,gateway_param.recv_time);
    printf("air_rate:%d,state:%x,node_count:%d\n",gateway_param.air_rate,gateway_param.gateway_state,gateway_param.node_count);
    for (int i = 0; i < gateway_param.node_count; i++)
    {
        struct EndNodeInfo *node = gateway_param.node_infos[i];
        printf("node_addr:%d,node_down_channel:%d!n",node->node_addr,node->node_down_channel);
    }
    return 0;
}

void* GatewayTask(void* param)
{
    struct Adapter *gateway_adapter = (struct Adapter *)param;
    if (gateway_adapter == NULL)
    {
        printf("GatewayTask-Fail: adapter is null!\n");
        return NULL;
    }

    while (gateway_param.gateway_state != GATEWAY_WORKING) // 等待上一个函数修改网关状态
    {
        PrivTaskDelay(100);
    }

    while (1) // 业务大循环
    {
        if (0 == PrivSemaphoreObtainNoWait(&gateway_adapter->sem))
        {
            PrivTaskDelay(LORA_RECV_TIME);
            continue;
        }
        PrivMutexObtain(&gateway_adapter->lock);
        if (0 == LoraRecvFrame(gateway_adapter,&recv_frame))
        {
            // 进行相应的处理
            if (0 == gateway_handlers[recv_frame.frame_type](gateway_adapter,&recv_frame))
            {
                printf("GatewayTask: handle success!\n");
            }
            else
            {
                printf("GatewayTask: handle fail!\n");
            }
        }
        PrivMutexAbandon(&gateway_adapter->lock);
    }
    
    printf("GatewayTask: task exit!\n");
    return NULL;
}

int GatewayJoinHandler(struct Adapter* adapter,struct LoraFrame* frame)
{
    // 获取终端的地址和信道，防止多个信道中同一个地址加入失败
    uint16 node_addr = frame->dev_addr;
    uint8 node_channel = frame->down_channel;
    struct EndNodeInfo* node = NULL;
    // 从现有的数据中查找
    for (int i = 0; i < gateway_param.node_count; i++)
    {
        if (node_addr == gateway_param.node_infos[i]->node_addr && node_channel == gateway_param.node_infos[i]->node_down_channel) // 找到了这个终端，实现已经加入了
        {
            node = gateway_param.node_infos[i];
            break;
        }
    }
    // 如果事先没有加入就创建
    if (node == NULL)
    {
        if(gateway_param.node_count ==  LORA_GATEWAY_MAX_NODE)
        {
            printf("NodeJoinHandler: too much node!\n");
            return -1;
        }
        node = (struct EndNodeInfo *)PrivMalloc(sizeof(struct EndNodeInfo));
        memset(node, 0, sizeof(struct EndNodeInfo));
        node->node_addr = node_addr;
        node->node_down_channel = node_channel;
        gateway_param.node_infos[gateway_param.node_count] = node;
        gateway_param.node_count++;
        // 如果已经事先加入了，直接返回
    }
    // 响应终端
    frame->frame_type = G_E_ANS;
    frame->frame_confirm = FRAME_BYTE_NO;
    frame->frame_attach = FRAME_BYTE_OK;

    if (0 != LoraSendFrame(adapter, frame,node->node_addr,node->node_down_channel))
    {
        printf("NodeJoinHandler: response node fail!\n");
        return -1;
    }
    printf("NodeJoinHandler: join net success addr:%d,channel:%d!\n",node->node_addr,node->node_down_channel);
    return 0;
}

int GatewayQuitHandler(struct Adapter* adapter,struct LoraFrame* frame)
{
    uint16 node_addr = frame->dev_addr;
    uint8 node_channel = frame->down_channel;
    for (int i = 0; i < gateway_param.node_count; i++) // 查找是否存在这个终端
    {
        if (node_addr == gateway_param.node_infos[i]->node_addr && node_channel == gateway_param.node_infos[i]->node_down_channel)
        {
            frame->frame_type = G_E_ANS;
            frame->frame_confirm = FRAME_BYTE_NO;
            frame->frame_attach = FRAME_BYTE_OK;
            if (0 != LoraSendFrame(adapter, frame,gateway_param.node_infos[i]->node_addr,gateway_param.node_infos[i]->node_down_channel))
            {
                printf("NodeQuitHandler: response node fail!\n");
                return -1;
            }
            // 释放相关的空间
            PrivFree(gateway_param.node_infos[i]);
            for (int j = i; j < gateway_param.node_count - 1; j++)
            {
                gateway_param.node_infos[j] = gateway_param.node_infos[j+1];
            }
            gateway_param.node_count--;
            gateway_param.node_infos[gateway_param.node_count] = NULL;
            break;
        }
    }
    printf("NodeQuitHandler: quit net success or quit before!\n");
    return 0;
}

int GatewayDataSendHandler(struct Adapter* adapter,struct LoraFrame* frame)
{
    // 查找该终端
    struct EndNodeInfo* node_info = GetEndNodeInfo(frame->dev_addr,frame->down_channel);
    if (node_info == NULL)
    {
        printf("NodeDataSendHandler: no such node!\n");
        return 0;
    }
    // 响应数据上传
    frame->frame_type = G_E_ANS;
    frame->frame_confirm = FRAME_BYTE_NO;
    frame->frame_attach = LORA_OK;
    if (0 != LoraSendFrame(adapter, frame,node_info->node_addr,node_info->node_down_channel))
    {
        printf("NodeDataSendHandler: response fail!\n");
        return -1;
    }
    // TODO 数据上传在此处理
    printf("NodeDataSendHandler-Success: recv data: %s\n!",frame->user_data);
    return 0;
}

AdapterProductInfoType LoraAttach(struct Adapter *adapter)
{
    struct AdapterProductInfo *product_info = malloc(sizeof(struct AdapterProductInfo));
    if (!product_info) {
        printf("LoraAttach-Failed-Node: malloc fail!\n");
        return NULL;
    }

    strncpy(product_info->model_name, LORA_ADAPTER_NAME,sizeof(product_info->model_name));
    product_info->model_done = (void *)&gateway_done;

    return product_info;
}

uint8 UsrAdapterLoraRegister(struct Adapter *adapter)
{
    strncpy(adapter->name, ADAPTER_LORA_NAME, NAME_NUM_MAX);
    adapter->net_protocol = PRIVATE_PROTOCOL;

    adapter->net_role = GATEWAY;
    adapter->net_role_id = gateway_param.channel;
    adapter->adapter_param = (void *)(&gateway_param);

    adapter->adapter_status = UNREGISTERED;

    if (AdapterDeviceRegister(adapter) < 0)
    {
        printf("UsrAdapterLoraRegister-Fail: lora register error!\n");
        return -1;
    }

    printf("UsrAdapterLoraRegister-Success!\n");
    return 0;
}
#else

// 终端参数结构
struct EndNodeParam node_param = 
{
    .dev_addr = LORA_ADDRESS,
    .down_channel = LORA_DOWN_CHANNEL,
    .upload_channel = LORA_UP_CHANNEL,
    .session_id = 0X0,
    .node_state = NODE_STATE_CLOSED,
    .air_rate = LORA_AIR_RATE,
    .adr_enable = LORA_ADR_ENABLE,
    .reconnect_enable = LORA_RECONNECT_ENABLE,
    .recv_time = LORA_RECV_TIME,
};
// 终端操作集合
static struct PrivProtocolDone node_done = 
{
    .open = NodeOpen,
    .close = NodeClose,
    .join = NodeJoin,
    .send = NodeSend,
    .quit = NodeQuit,
    .netstat = NodeNetState
};
// 空中速率枚举
enum LoraAirRate air_rates[6] =
    {
        AIR_RATE_2D4K,
        AIR_RATE_4D8K,
        AIR_RATE_9D6K,
        AIR_RATE_19D2K,
        AIR_RATE_38D4K,
        AIR_RATE_62D5K};

int air_rate_length = 6;

/**
 * @brief: 向特定信道以特定空中速率发送入网请求
 * @param adapter: 已打开的适配器
 * @param join_buffer: 已组装数据帧的缓冲区
 * @param upload_channel: 上行信道
 * @param air_rate: 空中速率
 * @return: 0 -> Success : -1 -> Fail(根据状态判定是否存在硬件损坏)
*/
static uint8 TargetConnectGateway(struct Adapter *adapter,struct LoraFrame *join_buffer,uint8 upload_channel,enum LoraAirRate air_rate)
{
    if (0 != E220Ioctl(adapter, CONFIG_AIR_RATE, &air_rate)) // 配置硬件空中速率
    {
        printf("TargetConnectGateway-Fail: config air rate fail %d!\n",air_rate);
        node_param.node_state = NODE_STATE_BROKEN;
        return -1;
    }
    node_param.air_rate = air_rate;
    for (int i = 0; i < LORA_FRAME_RETRY; i++)
    {
        node_param.session_id = GetSessionId();
        send_frame.session_id = node_param.session_id;

        SignalDetector(adapter,node_param.down_channel,node_param.upload_channel); // 信道监听
        if (0 != LoraSendFrame(adapter, &send_frame, LORA_GATEWAY_ADDRESS,upload_channel)) // 发送入网请求
        {
            node_param.node_state = NODE_STATE_BROKEN;
            return -1;
        }
        PrivTaskDelay(LORA_TIME_ON_AIR * 1000);
        while (0 == LoraRecvFrame(adapter, &recv_frame)) // 接收响应数据帧
        {
            if (recv_frame.session_id == node_param.session_id) // 判断数据帧是否丢失
            {
                if (G_E_ANS == recv_frame.frame_type && FRAME_BYTE_OK == recv_frame.frame_attach) // 成功加入网关
                {
                    node_param.node_state = NODE_STATE_CONNECT; // 更改终端状态
                    node_param.upload_channel = upload_channel;
                    node_param.air_rate = air_rate;
                    printf("ConnectGateway-Success: upload_channel: %d, air_rate: %d !\n",upload_channel,air_rate);
                    return 0;
                }
            }
        }
    }
    printf("ConnectGateway-Fail: upload_channel: %d, air_rate: %d !\n",upload_channel,air_rate);
    return -1;
}

int NodeOpen(struct Adapter *adapter)
{
    // 获取硬件控制权
    PrivMutexObtain(&adapter->lock);
    // 硬件损坏
    if (NODE_STATE_BROKEN == node_param.node_state)
    {
        printf("NodeOpen-Fail: lora broken!\n");
        PrivMutexAbandon(&adapter->lock);
        return -1;
    }
    // 硬件已打开
    if (NODE_STATE_CONNECT == node_param.node_state || NODE_STATE_DISCONNECT == node_param.node_state)
    {
        printf("NodeOpen-Success: opened before!\n");
        PrivMutexAbandon(&adapter->lock);
        return 0;
    }
    // 打开硬件设施
    if (0 != E220Open(adapter))
    {
        printf("NodeOpen-Fail: lora open fail!\n");
        node_param.node_state = NODE_STATE_BROKEN;
        PrivMutexAbandon(&adapter->lock);
        return -1;
    }
    // 配置硬件地址、信道、超时时间,空中速率
    int time_out = node_param.recv_time * 1000;
    if (0 != E220Ioctl(adapter,CONFIG_ADDRESS,&node_param.dev_addr) 
        || 0 != E220Ioctl(adapter,CONFIG_CHANNEL,&node_param.down_channel) 
        || 0 != E220Ioctl(adapter,CONFIG_SERIAL_TIME_OUT,&time_out)
        || 0 != E220Ioctl(adapter,CONFIG_AIR_RATE,&node_param.air_rate))
    {
        printf("NodeOpen-Fail: condfi client fail!\n");
        node_param.node_state = NODE_STATE_BROKEN;
        PrivMutexAbandon(&adapter->lock);
        return -1;
    }
    // 配置硬件休眠
    enum LoraMode aim_mode = MODE_CONFIG_SLEEP;
    if (0 != E220Ioctl(adapter, CONFIG_LORA_MODE, &aim_mode))
    {
        printf("NodeOpen-Fail: config lora sleep fail!\n");
        node_param.node_state = NODE_STATE_BROKEN;
        PrivMutexAbandon(&adapter->lock);
        return -1;
    }
    printf("NodeOpen-Success: node open success address: %d, dwon_channel: %d, upload_channel: %d!\n",node_param.dev_addr,node_param.down_channel,node_param.upload_channel);
    node_param.node_state = NODE_STATE_DISCONNECT;
    PrivMutexAbandon(&adapter->lock);
    return 0;
}

int NodeClose(struct Adapter *adapter)
{
    if (NODE_STATE_BROKEN == node_param.node_state || NODE_STATE_CLOSED == node_param.node_state)
    {
        printf("NodeClose-Success: lora broken or cloded before!\n");
        return 0;
    }
    if (NODE_STATE_CONNECT == node_param.node_state)
    {
        printf("NodeClose-Fail: quit net before close node!\n");
        return -1;
    }
    PrivMutexObtain(&adapter->lock);
    // 关闭硬件设施
    if (0 != E220Close(adapter))
    {
        printf("NodeClose-Fail: lora close fail!\n");
        node_param.node_state = NODE_STATE_BROKEN;
        PrivMutexAbandon(&adapter->lock);
        return -1;
    }
    printf("NodeClose-Success: node close success!\n");
    node_param.node_state = NODE_STATE_CLOSED;
    PrivMutexAbandon(&adapter->lock);
    return 0;
}

int NodeJoin(struct Adapter *adapter, unsigned char *net_group)
{
    switch (node_param.node_state)
    {
    case NODE_STATE_BROKEN:
        printf("NodeJoin-Fail: lora broken!\n");
        return -1;
    case NODE_STATE_CLOSED:
        printf("NodeJoin-Fail: open lora before join net!\n");
        return -1;
    case NODE_STATE_CONNECT:
        if (node_param.upload_channel == *net_group && NODE_STATE_CONNECT == node_param.node_state)
        {
            printf("NodeJoin-Success: joined before!\n");
            return 0;
        }
        // 退出当前网络
        if (NODE_STATE_CONNECT == node_param.node_state)
        {
            // 退出当前的网络，断开上行通道
            if (0 != NodeQuit(adapter, &node_param.upload_channel))
            {
                printf("NodeJoin-Fail: quit net before fail!\n");
                return -1;
            }
        }
    default:
        // 构建入网数据帧
        InitLoraFrame(&send_frame);
        send_frame.dev_addr = node_param.dev_addr;              // 当前设备地址
        send_frame.down_channel = node_param.down_channel;      // 下行通道信息，当前设备的信道
        send_frame.frame_type = E_G_JOIN;
        send_frame.frame_confirm = LORA_OK;
        // 获取终端控制权
        PrivMutexObtain(&adapter->lock);
        // 以默认的空中速率尝试连接传入的网络
        if (0 == TargetConnectGateway(adapter, &send_frame, *net_group,node_param.air_rate))
        {
            PrivMutexAbandon(&adapter->lock);
            return 0;
        }
        else
        {
            // ADR自动寻找网关
            if (LORA_OK == node_param.adr_enable)
            {
                // 默认连接出错
                if (NODE_STATE_BROKEN == node_param.node_state)
                {
                    printf("NodeJoin-Fail: send join frame fail!\n");
                    node_param.node_state = NODE_STATE_BROKEN;
                    PrivMutexAbandon(&adapter->lock);
                    return -1;
                }
                // 尝试连接其他的网关
                for (int i = 0; i < E220_MAX_CHANNEL_NUMBER; i++)
                {
                    for (int j = 0; j < air_rate_length; j++)
                    {
                        printf("NodeJoin-Try: channel: %d air rate: %x!\n",i,air_rates[j]);
                        if (0 == TargetConnectGateway(adapter, &send_frame, i, air_rates[j]))
                        {
                            PrivMutexAbandon(&adapter->lock);
                            return 0;
                        }
                        if (NODE_STATE_BROKEN == node_param.node_state)
                        {
                            printf("NodeJoin-Fail: send join frame fail!\n");
                            node_param.node_state = NODE_STATE_BROKEN;
                            PrivMutexAbandon(&adapter->lock);
                            return -1;
                        }
                    }
                }
                // 不存在网关
                printf("NodeJoin-Fail: no gateway exits!\n");
                PrivMutexAbandon(&adapter->lock);
                return -1;
            }
            else
            {
                printf("NodeJoin-Fail: the gateway config not exits!\n");
                PrivMutexAbandon(&adapter->lock);
                return -1;
            }
        }
    }
}

int NodeSend(struct Adapter *adapter, const void *buf, size_t len)
{
    // 只有处于联网状态的终端才可发送数据
    if (NODE_STATE_CONNECT != node_param.node_state) 
    {
        printf("NodeSend-Fail: open lora and join net before send data!\n");
        return -1;
    }
    if (len > FRAME_MAX_USER_DATA_LENGTH) // 数据量太大
    {
        printf("NodeSend-Fail: to much data for send!\n");
        return -1;
    }
    // 构造数据帧并发送数据
    InitLoraFrame(&send_frame); // 初始化
    send_frame.dev_addr = node_param.dev_addr;
    send_frame.down_channel = node_param.down_channel;
    send_frame.frame_type = E_G_DATA;
    send_frame.frame_confirm = LORA_OK;
    // 复制待发送的数据
    memcpy(send_data_buffer,buf,len);
    send_frame.user_data = send_data_buffer;
    send_frame.frame_attach = len;

    PrivMutexObtain(&adapter->lock);
    // 发送用户数据帧
    for (int i = 0; i < LORA_FRAME_RETRY; i++)
    {
        node_param.session_id = GetSessionId();
        send_frame.session_id = node_param.session_id;

        // 信道监听
        SignalDetector(adapter,node_param.down_channel,node_param.upload_channel);
        // 发送数据帧
        if (0 != LoraSendFrame(adapter, &send_frame,LORA_GATEWAY_ADDRESS,node_param.upload_channel))
        {
            PrivMutexAbandon(&adapter->lock);
            node_param.node_state = NODE_STATE_BROKEN;
            return -1;
        }
        // 等待信号到达
        PrivTaskDelay(LORA_TIME_ON_AIR * 1000);
        // 准备数据缓冲区并等待网关响应
        while (0 == LoraRecvFrame(adapter, &recv_frame))
        {
            // 判断数据是否丢失
            if (recv_frame.session_id == node_param.session_id)
            {
                // 判断是否发送成功
                if (G_E_ANS == recv_frame.frame_type && LORA_OK == recv_frame.frame_attach)
                {
                    // 配置硬件休眠
                    enum LoraMode aim_mode = MODE_CONFIG_SLEEP;
                    E220Ioctl(adapter,CONFIG_LORA_MODE,&aim_mode);
                    PrivMutexAbandon(&adapter->lock);
                    return 0;
                }
                
            }
        }
    }
    PrivMutexAbandon(&adapter->lock);
    // 判定网关掉线
    node_param.node_state = NODE_STATE_DISCONNECT;
    // 数据发送失败，需要重新联网
    if (LORA_OK == node_param.reconnect_enable)
    {
        printf("NodeSend-Fail: try to reconnect gateway!\n");
        if (0 == NodeJoin(adapter,&node_param.upload_channel))
        {
            // 重新发送数据
            return NodeSend(adapter,buf,len);
        }
        printf("NodeSend-Fail: try to reconnect gateway fail!\n");
    }
    return -1;
}

int NodeQuit(struct Adapter *adapter, unsigned char *net_group)
{
    if (NODE_STATE_CONNECT != node_param.node_state)
    {
        printf("NodeQuit-Success: disconnected before!\n");
        return 0;
    }

    if (node_param.upload_channel != *net_group)
    {
        printf("NodeQuit-Success: not such net!\n");
        return 0;
    }

    // 构建退网数据帧
    InitLoraFrame(&send_frame);
    send_frame.dev_addr = node_param.dev_addr;
    send_frame.down_channel = node_param.down_channel;
    send_frame.frame_type = E_G_QUIT;
    send_frame.frame_confirm = FRAME_BYTE_OK;

    PrivMutexObtain(&adapter->lock);
    // 发送用户数据帧
    for (int i = 0; i < LORA_FRAME_RETRY; i++)
    {
        node_param.session_id = GetSessionId();
        send_frame.session_id = node_param.session_id;

        // 信道监听
        SignalDetector(adapter,node_param.down_channel,node_param.upload_channel);
        // 发送数据帧
        if (0 != LoraSendFrame(adapter, &send_frame,LORA_GATEWAY_ADDRESS,node_param.upload_channel))
        {
            node_param.node_state = NODE_STATE_BROKEN;
            PrivMutexAbandon(&adapter->lock);
            return -1;
        }
        // 等待信号到达
        PrivTaskDelay(LORA_TIME_ON_AIR * 1000);
        // 准备数据缓冲区并等待网关响应
        while (0 == LoraRecvFrame(adapter, &recv_frame))
        {
            // 判断数据是否丢失
            if (recv_frame.session_id == node_param.session_id)
            {
                // 判断是否退出成功
                if (G_E_ANS == recv_frame.frame_type && FRAME_BYTE_OK == recv_frame.frame_attach)
                {
                    // 配置硬件休眠
                    enum LoraMode aim_mode = MODE_CONFIG_SLEEP;
                    E220Ioctl(adapter,CONFIG_LORA_MODE,&aim_mode);
                    PrivMutexAbandon(&adapter->lock);
                    return 0;
                }
            }
        }
    }
    printf("NodeQuit-Fail: quit net fail %d!\n",*net_group);
    // 配置硬件休眠
    enum LoraMode aim_mode = MODE_CONFIG_SLEEP;
    E220Ioctl(adapter,CONFIG_LORA_MODE,&aim_mode);
    PrivMutexAbandon(&adapter->lock);
    return -1;
}

int NodeNetState(struct Adapter *adapter)
{
    printf("EndNodeInfos: \n");
    printf("addr:%d,down_channel:%d,upload_channel:%d,",node_param.dev_addr,node_param.down_channel,node_param.upload_channel);
    printf("state:%x,air_rate:%x,adr:%x,",node_param.node_state,node_param.air_rate,node_param.adr_enable);
    printf("reconnect:%x,recv_time:%d \n",node_param.recv_time,node_param.reconnect_enable);
    return 0;
}

AdapterProductInfoType LoraAttach(struct Adapter *adapter)
{
    struct AdapterProductInfo *product_info = malloc(sizeof(struct AdapterProductInfo));
    if (!product_info) {
        printf("LoraAttach-Failed-Node: malloc fail!\n");
        return NULL;
    }

    strncpy(product_info->model_name, LORA_ADAPTER_NAME,sizeof(product_info->model_name));
    product_info->model_done = (void *)&node_done;

    return product_info;
}

uint8 UsrAdapterLoraRegister(struct Adapter *adapter)
{
    strncpy(adapter->name, ADAPTER_LORA_NAME, NAME_NUM_MAX);
    adapter->net_protocol = PRIVATE_PROTOCOL;

    adapter->net_role = CLIENT;
    adapter->net_role_id = node_param.dev_addr;
    adapter->adapter_param = (void *)(&node_param);

    adapter->adapter_status = UNREGISTERED;

    if (AdapterDeviceRegister(adapter) < 0)
    {
        printf("UsrAdapterLoraRegister-Fail: lora register error!\n");
        return -1;
    }

    printf("UsrAdapterLoraRegister-Success!\n");
    return 0;
}
#endif