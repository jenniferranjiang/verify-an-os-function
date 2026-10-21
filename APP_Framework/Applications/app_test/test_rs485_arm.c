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
* @file:    test_rs485.c
* @brief:   a application of rs485 function
* @version: 1.1
* @author:  AIIT XUOS Lab
* @date:    2022/12/17
*/
#include <stdio.h>
#include <string.h>
#include <transform.h>
#ifdef ADD_XIZI_FEATURES

//edu-arm board dir pin PG01----no.67 in XiZi_IIoT/board/edu_arm32/third_party_driver/gpio/connect_gpio.c
#define BSP_485_DIR_PIN 67

static int pin_fd;
static int uart_fd;
static char write_485_data[] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
static char read_485_data[8] = {0};

/**
 * @description: Set Uart 485 Input
 * @return 
 */
static void Set485Input(void)
{
    struct PinStat pin_stat;
    pin_stat.pin = BSP_485_DIR_PIN;
    pin_stat.val = GPIO_LOW;
    PrivWrite(pin_fd, &pin_stat, 1);
}

/**
 * @description: Set Uart 485 Output
 * @return
 */
static void Set485Output(void)
{
    struct PinStat pin_stat;
    pin_stat.pin = BSP_485_DIR_PIN;
    pin_stat.val = GPIO_HIGH;
    PrivWrite(pin_fd, &pin_stat, 1);
}

/**
 * @description: Control Framework Serial Write
 * @param write_data - write data
 * @param length - length
 * @return
 */
void Rs485Write(uint8_t *write_data, int length)
{
    Set485Output();
    PrivTaskDelay(20);

    PrivWrite(uart_fd, write_data, length);

    PrivTaskDelay(15);
    Set485Input();
}

/**
 * @description: Control Framework Serial Read
 * @param read_data - read data
 * @param length - length
 * @return read data size
 */
int Rs485Read(uint8_t *read_data, int length)
{
    int data_size = 0;
    int data_recv_size = 0;

    while (data_size < length) {
        data_recv_size = PrivRead(uart_fd, read_data + data_size, length - data_size);
        data_size += data_recv_size;
    }

    //need to wait 30ms , make sure write cmd again and receive data successfully
    PrivTaskDelay(30);

    return data_size;
}

void Test485(void)
{
    int read_data_length = 0;
    pin_fd = PrivOpen(RS485_PIN_DEV_DRIVER, O_RDWR);
    if (pin_fd < 0) {
        printf("open pin fd error:%d\n", pin_fd);
        return;
    }

    uart_fd = PrivOpen(RS485_UART_DEV_DRIVER, O_RDWR);
    if (uart_fd < 0) {
        printf("open pin fd error:%d\n", uart_fd);
        return;
    }
    printf("uart and pin fopen success\n");

    //config dir pin in board
    struct PinParam pin_parameter;
    memset(&pin_parameter, 0, sizeof(struct PinParam));
    pin_parameter.cmd = GPIO_CONFIG_MODE;
    pin_parameter.pin = BSP_485_DIR_PIN;
    pin_parameter.mode = GPIO_CFG_OUTPUT;

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = PIN_TYPE;
    ioctl_cfg.args =  (void *)&pin_parameter;

    if (0 != PrivIoctl(pin_fd, OPE_CFG, &ioctl_cfg)) {
        printf("ioctl pin fd error %d\n", pin_fd);
        PrivClose(pin_fd);
        return;
    }

    struct SerialDataCfg uart_cfg;
    memset(&uart_cfg, 0, sizeof(struct SerialDataCfg));

    uart_cfg.serial_baud_rate = BAUD_RATE_115200;
    uart_cfg.serial_data_bits = DATA_BITS_8;
    uart_cfg.serial_stop_bits = STOP_BITS_1;
    uart_cfg.serial_parity_mode = PARITY_NONE;
    uart_cfg.serial_bit_order = BIT_ORDER_LSB;
    uart_cfg.serial_invert_mode = NRZ_NORMAL;
    uart_cfg.serial_buffer_size = SERIAL_RB_BUFSZ;
    uart_cfg.serial_timeout = -1;
    uart_cfg.is_ext_uart = 0;
    uart_cfg.dev_recv_callback = NULL;

    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = (void *)&uart_cfg;

    if (0 != PrivIoctl(uart_fd, OPE_INT, &ioctl_cfg)) {
        printf("ioctl uart fd error %d\n", uart_fd);
        PrivClose(uart_fd);
        return;
    }

    Rs485Write(write_485_data, sizeof(write_485_data));

    while(1) {
        printf("ready to read data\n");

        read_data_length = Rs485Read(read_485_data, sizeof(read_485_data));
        printf("%s read data length %d\n", __func__, read_data_length);
        for (int i = 0; i < read_data_length; i ++) {
            printf("i %d read data 0x%x\n", i, read_485_data[i]);
        }
        Rs485Write(read_485_data, read_data_length);
        memset(read_485_data, 0, sizeof(read_485_data));

        printf("read data done\n");
    }

    PrivClose(pin_fd);
    PrivClose(uart_fd);
    return;
}

PRIV_SHELL_CMD_FUNCTION(Test485, a RS485 test sample, PRIV_SHELL_CMD_MAIN_ATTR);
#endif