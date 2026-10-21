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
* @file:    e220.c
* @brief:   E220 module underlying related configuration driver functions implement
* @version: 0.1
* @author:  YUNFEI CHU
* @date:    2023/10/01 
*
*/

#include "e220.h"

struct RegisterCfg                  // 寄存器结构
{
    uint8 ADDH;
    uint8 ADDL;                     // 地址
    uint8 REG0;                     // 波特率/串口校验/空中速率
    uint8 REG1;                     // 分包设定/RSSI环境噪声/发射功率
    uint8 REG2;                     // 信道
    uint8 REG3;                     // RSSI字节/传输方式/LBT使能/WOR周期
    uint8 KEYH;
    uint8 KEYL;                     // 密钥
};

/**
 * 默认的寄存器配置信息，在每次配置更新后会同步更新该数据，保持其与硬件寄存器数据的一致性
*/
static struct RegisterCfg register_cfg =
{
    .ADDH = (E220_ADDRESS >> 8) & 0XFF,
    .ADDL = E220_ADDRESS & 0XFF,
    .REG0 = E220_DEFAULT_CONFIG_BAUD_RATE_BYTE | E220_DEFAULT_AIR_RATE,
    .REG1 = 0X0,
    .REG2 = E220_DEFAULT_CHANNEL,
    .REG3 = E220_DEFAULT_TRANS_MODE,
    .KEYH = 0X0,
    .KEYL = 0X0,       
};

/**
 * 默认的串口配置信息，初始化时波特率为9600，保持与硬件一致，在波特率更改过程中也需要保证一致
*/
static struct SerialDataCfg serial_cfg =
{
    .serial_baud_rate = E220_DEFAULT_CONFIG_BAUD_RATE,// 串口波特率
    .serial_data_bits = DATA_BITS_8,
    .serial_stop_bits = STOP_BITS_1,
    .serial_parity_mode = PARITY_NONE,
    .serial_bit_order = BIT_ORDER_LSB,
    .serial_invert_mode = NRZ_NORMAL,
    .serial_buffer_size = SERIAL_RB_BUFSZ,
    .serial_timeout = E220_DAFAULT_SERIAL_TIMEOUT,     // 串口超时配置
    .is_ext_uart = 0,
    .dev_recv_callback = NULL,
};

enum LoraMode current_mode = -1;                       // 当前模块处于什么模式
enum LoraState lora_state = STATE_CLOSED;              // 当前模块的状态
uint8 lora_init = E220_NO;                             // 当前模块是否已经被初始化过了

/**
 * @brief: 将硬件切换至指定的模式
 * @param mode: 支持休眠/配置模式 和 传输模式
*/
static uint8 E220LoraModeConfig(enum LoraMode mode)
{
    // 模式和状态判断
    if (lora_state == STATE_BROKEN)
    {
        DDBG("E220LoraModeConfig-Fail: lora broken!\n");
        return -1;
    }
    if(mode == current_mode)
    {
        // 同一个模式直接返回，不输出信息
        return 0;
    }
    // 打开PIN驱动
    int pin_fd = PrivOpen(E220_PIN_DRIVER,O_RDWR);
    if (pin_fd < 0)
    {
        DDBG("E220LoraModeConfig-Fail: open pin driver fail %s!\n",E220_PIN_DRIVER);
        lora_state = STATE_BROKEN;
        return -1;
    }
    // 配置管脚属性
    struct PinParam pin_param ={.cmd = GPIO_CONFIG_MODE,.mode = GPIO_CFG_OUTPUT,.pin = E220_M0_PATH};
    struct PrivIoctlCfg ioctl_config = {.ioctl_driver_type = PIN_TYPE, .args = &pin_param};
    if (0 != PrivIoctl(pin_fd,OPE_CFG,&ioctl_config))
    {
        DDBG("E220LoraModeConfig-Fail: config m0 fail!\n");
        lora_state = STATE_BROKEN;
        return -1;
    }
    pin_param.pin = E220_M1_PATH;
    ioctl_config.args = &pin_param;
    if (0 != PrivIoctl(pin_fd,OPE_CFG,&ioctl_config))
    {
        DDBG("E220LoraModeConfig-Fail: config m1 fail!\n");
        lora_state = STATE_BROKEN;
        return -1;
    }

    struct PinStat pin_stat;
    switch (mode)
    {
    case MODE_TRANSFER_MODE:
    {   
        pin_stat.pin = E220_M0_PATH;
        pin_stat.val = GPIO_LOW;
        if (-1 == PrivWrite(pin_fd, &pin_stat, 1))
        {
            DDBG("E220LoraModeConfig-Fail: config m0 low fail!\n");
            lora_state = STATE_BROKEN;
            return -1;
        }
        pin_stat.pin = E220_M1_PATH;
        pin_stat.val = GPIO_LOW;
        if (-1 == PrivWrite(pin_fd, &pin_stat, 1))
        {
            DDBG("E220LoraModeConfig-Fail: config m1 low fail!\n");
            lora_state = STATE_BROKEN;
            return -1;
        }
        break;
    }
    case MODE_CONFIG_SLEEP:
    {
        pin_stat.pin = E220_M0_PATH;
        pin_stat.val = GPIO_HIGH;
        if (-1 == PrivWrite(pin_fd, &pin_stat, 1))
        {
            DDBG("E220LoraModeConfig-Fail: config m0 high fail!\n");
            lora_state = STATE_BROKEN;
            return -1;
        }
        pin_stat.pin = E220_M1_PATH;
        pin_stat.val = GPIO_HIGH;
        if (-1 == PrivWrite(pin_fd, &pin_stat, 1))
        {
            DDBG("E220LoraModeConfig-Fail: config m1 high fail!\n");
            lora_state = STATE_BROKEN;
            return -1;
        }
        break;
    }
    default:
        DDBG("E220LoraModeConfig-Fail: unsupported lora mode!\n");
        PrivClose(pin_fd);
        return -1;
    }
    PrivTaskDelay(E220_CONFIG_DELAY);
    PrivClose(pin_fd);
    // 记录当前模式，避免不必要的重复配置
    current_mode = mode;
    DDBG("E220LoraModeConfig-Success: change to mode %s !\n",mode == MODE_CONFIG_SLEEP ? "MODE_CONFIG_SLEEP" : "MODE_TRANSFER_MODE");
    return 0;
}

/**
 * @brief: 通过指令获取硬件寄存器参数后将其保存并输出
 * @param adapter: 需要打开
*/
static void PrintRegister(char* prefix)
{       
    // 打印数据
    DDBG("%s Register:",prefix);
    DDBG("ADDH:%X,ADDL:%X,REG0:%X,",register_cfg.ADDH,register_cfg.ADDL,register_cfg.REG0);
    DDBG("REG1:%X,REG2:%X,REG3:%X,",register_cfg.REG1,register_cfg.REG2,register_cfg.REG3);
    DDBG("KEYH:%X,KEYL:%X\n",register_cfg.KEYH,register_cfg.KEYL);
}

/**
 * @brief: 根据配置的数据覆写硬件寄存器参数
 * @param adapter: 一个已经打开了UART串口的Lora硬件
 * @param start_addr: 需要覆写的寄存器起始地址
 * @param byte_length: 需要覆写的寄存器数量
 * @param args: 需要覆写的寄存器参数
 * @return: 0 -> Success; -1 -> Fail
*/
static uint8 WriteRegister(struct Adapter *adapter,uint8 start_addr,uint8 byte_length,void* args)
{
    if (STATE_BROKEN == lora_state)
    {
        DDBG("WriteRegister-Fail: lora broken!\n");
        return -1;
    }
    // 切换硬件到配置模式
    E220LoraModeConfig(MODE_CONFIG_SLEEP);
    // 构造寄存器覆写数据
    uint8 buffer[11] = {0};
    buffer[0] = 0XC0;
    buffer[1] = start_addr;
    buffer[2] = byte_length;
    memcpy(&buffer[3],args,byte_length);
    // 覆写寄存器参数
    if (PrivWrite(adapter->fd, (void *)buffer, byte_length + 3) < 0)
    {
        PrintRegister("WriteRegister-Fail");
        lora_state = STATE_BROKEN;
        return -1;
    }
    // 等待配置完成后读取回写数据
    PrivTaskDelay(E220_CONFIG_DELAY);
    PrivRead(adapter->fd, buffer, byte_length + 3);             
    PrintRegister("WriteRegister-Success");
    return 0;
}

/**
 * @brief: 根据默认的配置对一个已经打开UART串口的Lora硬件进行寄存器参数的初始化,开启后只会被调用一次
 * @param adapter: 需要打开
*/
static uint8 E220RegisterInit(struct Adapter *adapter)
{
    if(STATE_BROKEN == lora_state)
    {
        DDBG("E220RegisterInit-Fail: lora broken!\n");
        return -1;
    }
    if (lora_init == E220_YES)
    {
        DDBG("E220RegisterInit-Success: inited before!\n");
        return 0;
    }
    // 按照默认的参数进行寄存器初始化
	if (0 != WriteRegister(adapter,0X0,0X8,&register_cfg))
    {
        lora_state = STATE_BROKEN;
        return -1;
    }
    // 防止重复初始化
    lora_init = E220_YES;
    DDBG("E220RegisterConfig-Success!\n");
    return 0;
}

uint8 E220Open(struct Adapter *adapter)
{
    if (lora_state == STATE_BROKEN)
    {
        DDBG("E220Open-Fail: lora broken!\n");
        return -1;
    }
    if (lora_state == STATE_OPENED)
    {
        // 避免重复打开
        return 0;
    }
    // 打开UART串口
    adapter->fd = PrivOpen(E220_UART_DRIVER,O_RDWR);
    if (adapter->fd < 0)
    {
        DDBG("E220Open-Fail: open uart fail - %s \n",E220_UART_DRIVER);
        lora_state = STATE_BROKEN;
        return -1;
    }
    // 按照默认串口配置信息初始化串口
    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = &serial_cfg;
    if (0 != PrivIoctl(adapter->fd, OPE_INT,&ioctl_cfg))
    {
        DDBG("E220Open-Fail: uart config fail - %s \n",E220_UART_DRIVER);
        lora_state = STATE_BROKEN;
        return -1;
    }
    // 硬件的寄存器初始化
    if (0 != E220RegisterInit(adapter))
    {
        DDBG("E220Open-Fail: register config fail!\n");
        lora_state = STATE_BROKEN;
        return -1;
    }
    lora_state = STATE_OPENED;
    DDBG("E220Open-Success: e220 open success!\n");
    return 0;
}

uint8 E220Close(struct Adapter *adapter)
{
    if (lora_state != STATE_OPENED)
    {
        DDBG("E220Close-Success: broken or closed before!\n");
        return 0;
    }
    // 关闭UART串口
    if (adapter->fd > 0)
    {
        if (0 != PrivClose(adapter->fd))
        {
            DDBG("E220Close-Failed: result != 0\n");
            lora_state = STATE_BROKEN;
            return -1;
        }
    }
    adapter->fd = -1;
    lora_init = E220_NO;
    lora_state = STATE_CLOSED;
    DDBG("E220Close-Success: success!\n");
    return 0;
}

uint8 E220Ioctl(struct Adapter *adapter, int config_item, void *args)
{
    if (STATE_OPENED != lora_state)
    {
        DDBG("E220Ioctl-Fail: open lora or the lora is broken!\n");
        return -1;
    }
    switch (config_item)
    {
    // 配置Lora串口超时时间
    case CONFIG_SERIAL_TIME_OUT:
    {
        int32 time_out = *((int32*)args);
        if (time_out == serial_cfg.serial_timeout)
        {
            DDBG("ConfigSerialTimeOut-Success: the same time_out %d !\n", time_out);
            return 0;
        }
        
        serial_cfg.serial_timeout = time_out;
        struct PrivIoctlCfg ioctl_cfg = { .ioctl_driver_type = SERIAL_TYPE,.args = &serial_cfg };
        // 修改串口配置信息
        if (0 != PrivIoctl(adapter->fd, OPE_INT, &ioctl_cfg))
        {
            DDBG("ConfigSerialTimeOut-Fail: %d\n", serial_cfg.serial_timeout);
            lora_state = STATE_BROKEN;
            return -1;
        }
        DDBG("ConfigSerialTimeOut-Success: %d\n", serial_cfg.serial_timeout);
        return 0;
    }
    // 配置Lora模式
    case CONFIG_LORA_MODE:
    {
        enum LoraMode mode = *((enum LoraMode*)args);
        if (mode == current_mode)
        {
            DDBG("ConfigLoraMode-Success: the same mode %s!\n",mode == MODE_TRANSFER_MODE ? "MODE_TRANSFER_MODE" : "MODE_CONFIG_SLEEP");
            return 0;
        }
        if (mode == MODE_TRANSFER_MODE || mode == MODE_CONFIG_SLEEP)
        {
            if (0 != E220LoraModeConfig(mode))
            {
                DDBG("ConfigLoraMode-Fail: config mode fail %s!\n",mode == MODE_TRANSFER_MODE ? "MODE_TRANSFER_MODE" : "MODE_CONFIG_SLEEP");
                return -1;
            }
            DDBG("ConfigLoraMode-Success: change lora mode to %s!\n",mode == MODE_TRANSFER_MODE ? "MODE_TRANSFER_MODE" : "MODE_CONFIG_SLEEP");
            return 0;
        }
        DDBG("ConfigLoraMode-Fail: unsupported lora mode %x!\n",mode);
        return -1;
    }
    // 配置Lora传输模式
    case CONFIG_TRANS_MODE:
    {
        if (serial_cfg.serial_baud_rate != E220_DEFAULT_CONFIG_BAUD_RATE)
        {
            DDBG("ConfigTransMode-Fail: only config by baud rate 9600!\n");
            return -1;
        }
        uint8 trans_mode = *((uint8*)args);
        if (trans_mode == TRANS_MODE_HYALINE || trans_mode == TRANS_MODE_ORIENTED)
        {
            // 判断参数是否有必要覆写
            if (register_cfg.REG3 & 0X40 == trans_mode)
            {
                DDBG("ConfigTransMode-Success: the same trans mode %x!\n",trans_mode);
                return 0;
            }
            trans_mode = register_cfg.REG3 & 0xBF | trans_mode;
            if (0 != WriteRegister(adapter,0X5,1,&trans_mode))
            {
                lora_state = STATE_BROKEN;
                DDBG("ConfigTransMode-Fail: config trans mode fail %x!\n",trans_mode);
                return -1;
            }
            register_cfg.REG3 = trans_mode;
            DDBG("ConfigTransMode-Success: config trans mode success %x!\n",trans_mode);
            return 0;
        }
        DDBG("ConfigTransMode-Fail: unsupported trans mode %x!\n",trans_mode);
        return -1;
    }
    // 配置Lora空中速率
    case CONFIG_AIR_RATE:
    {
        if (serial_cfg.serial_baud_rate != E220_DEFAULT_CONFIG_BAUD_RATE)
        {
            DDBG("ConfigAirRate-Fail: only config by baud rate 9600!\n");
            return -1;
        }
        uint8 air_rate = *((uint8*)args);
        if (air_rate >= AIR_RATE_2D4K && air_rate <= AIR_RATE_62D5K)
        {
            // 判断参数是否有必要覆写
            if (register_cfg.REG0 & 0X7 == air_rate)
            {
                DDBG("ConfigAirRate-Success: the same air rate %x!\n",air_rate);
                return 0;
            }
            air_rate = ((register_cfg.REG0 >> 3) << 3) | air_rate;
            if (0 != WriteRegister(adapter,0X2,1,&air_rate))
            {
                lora_state = STATE_BROKEN;
                DDBG("ConfigAirRate-Fail: write register fail %x!\n",air_rate);
                return -1;
            }
            register_cfg.REG0 = air_rate;
            DDBG("ConfigAirRate-Success: config air rate success %x!\n",air_rate & 0X7);
            return 0;
        }
        DDBG("ConfigAirRate-Fail: unsupported air rate %x!\n",air_rate);
        return -1;
    }
    // 配置Lora的波特率
    case CONFIG_BAUD_RATE:
    {
        uint8 arg_rate = *((uint8*)args);
        uint8 temp_rate = arg_rate;
        if (arg_rate == E220_DEFAULT_CONFIG_BAUD_RATE_BYTE || arg_rate == E220_DEFAULT_USED_BAUD_RATE_BYTE)
        {
            // 判断参数是否有必要覆写
            if (register_cfg.REG0 & 0XE0 == arg_rate)
            {
                DDBG("ConfigBaudRate-Success: the same baud rate %x!\n",arg_rate);
                return 0;
            }
            temp_rate = register_cfg.REG0 & 0X1F | arg_rate;
            // 先更改寄存器的波特率
            if (0 != WriteRegister(adapter,0X2,1,&temp_rate))
            {
                lora_state = STATE_BROKEN;
                DDBG("ConfigBaudRate-Fail: write register config fail %x!\n",temp_rate);
                return -1;
            }
            register_cfg.REG0 = temp_rate;
            // 重新配置串口波特率
            serial_cfg.serial_baud_rate = arg_rate == E220_DEFAULT_CONFIG_BAUD_RATE_BYTE ? BAUD_RATE_9600 : BAUD_RATE_115200;
            struct PrivIoctlCfg ioctl_cfg;
            ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
            ioctl_cfg.args = &serial_cfg;
            // 重新配置串口波特率
            if (0 != PrivIoctl(adapter->fd, OPE_INT, &ioctl_cfg))
            {
                lora_state = STATE_BROKEN;
                DDBG("ConfigBaudRate-Fail: config serail fail %x!\n",temp_rate);
                return -1;
            }
            DDBG("ConfigBaudRate-Success: config baud rate success %d !\n",arg_rate == E220_DEFAULT_CONFIG_BAUD_RATE_BYTE ? BAUD_RATE_9600 : BAUD_RATE_115200);
            return 0;
        }
        DDBG("ConfigBaudRate-Fail: unsupported baud rate %x!\n",arg_rate);
        return -1;
    }
    // 配置Lora地址参数
    case CONFIG_ADDRESS:
    {
        if (serial_cfg.serial_baud_rate != E220_DEFAULT_CONFIG_BAUD_RATE)
        {
            DDBG("ConfigAddress-Fail: only config by baud rate 9600!\n");
            return -1;
        }
        uint16 address = *((uint16*)args);
        if ((address >> 8) | 0XFF == register_cfg.ADDH && address & 0XFF == register_cfg.ADDL)
        {
            DDBG("ConfigAddress-Success: the same address %d!\n",address);
            return 0;
        }
        register_cfg.ADDH = (address >> 8) & 0XFF;
        register_cfg.ADDL = address & 0XFF;
        if (0 != WriteRegister(adapter,0X0,2,&register_cfg))
        {
            lora_state = STATE_BROKEN;
            DDBG("ConfigAddress-Fail: write register fail %d!\n",address);
            return -1;
        }
        DDBG("ConfigAddress-Success: config address success %d!\n",address);
        return 0;
    }
    // 配置Lora信道参数
    case CONFIG_CHANNEL:
    {
        if (serial_cfg.serial_baud_rate != E220_DEFAULT_CONFIG_BAUD_RATE)
        {
            DDBG("ConfigChannel-Fail: only config by baud rate 9600!\n");
            return -1;
        }
        uint8 channel = *((uint8*)args);
        if (channel <= E220_MAX_CHANNEL_NUMBER)
        {
            if (register_cfg.REG2 == channel)
            {
                DDBG("ConfigChannel-Success: the same channel %d!\n",channel);
                return 0;
            }
            register_cfg.REG2 = channel;
            if (0 != WriteRegister(adapter,0X4,1,&register_cfg.REG2))
            {
                lora_state = STATE_BROKEN;
                DDBG("ConfigChannel-Fail: write register fail %d!\n",channel);
                return -1;
            }
            DDBG("ConfigChannel-Success: config channel success %X !\n",channel);
            return 0;
        }
        DDBG("ConfigChannel-Fail: unsupported channel %d!\n",channel);
        return -1;
    }
    // 打印配置信息
    case CONFIG_SHOW:
    {
        DDBG("ConfigShow SerailTime: %d",serial_cfg.serial_timeout);
        PrintRegister("CONFIG_SHOW");
        return 0;
    }
    default:
        DDBG("E220Ioctl-Failed: config item unsupported %d!\n",config_item);
        return -1;
    }
}

uint8 E220Send(struct Adapter *adapter, const void *buf, uint32 len)
{
    if (STATE_OPENED != lora_state)
    {
        DDBG("E220Send-Fail: open lora before send data!\n");
        return -1;
    }
    // 切换至传输模式
    if (0 != E220LoraModeConfig(MODE_TRANSFER_MODE))
    {
        DDBG("E220Send-Fail: change mode transfer fail!\n");
        return -1;
    }

    if (len != PrivWrite(adapter->fd, (void *)buf, len))
    {
        DDBG("E220Send-Fail: send data fail!\n");
        return -1;
    }
    return 0;    
}

uint8 E220Recv(struct Adapter *adapter, void *buf, uint32 len)
{
    if (STATE_OPENED != lora_state)
    {
        DDBG("E220Recv-Fail: open lora before recv!\n");
        return -1;
    }
    // 确保传输模式
    if (0 != E220LoraModeConfig(MODE_TRANSFER_MODE))
    {
        return -1;
    }

    int recv_len = 0, recv_len_continue = 0;

    uint8 *recv_buf = PrivMalloc(len);
    // 读取数据并返回已读取数据量
    recv_len = PrivRead(adapter->fd, recv_buf, len);
    if (recv_len) {
        while (recv_len < len) {
            // 读取超时后退出循环
            recv_len_continue = PrivRead(adapter->fd, recv_buf + recv_len, len - recv_len);
            if (recv_len_continue) {
                recv_len += recv_len_continue;
            } else {
                recv_len = 0;
                break;
            }
        }
        memcpy(buf, recv_buf, len);
    }
    PrivFree(recv_buf);
    return recv_len;  
}
