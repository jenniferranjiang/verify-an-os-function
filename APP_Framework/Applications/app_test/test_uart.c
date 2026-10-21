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
 * @file:    test_uart.c
 * @brief:   a application of uart function, uart6 for edu-arm32
 * @version: 3.0
 * @author:  AIIT XUOS Lab
 * @date:    2023/8/11
 */
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#include <transform.h>

#include <argparse.h>
#ifdef ADD_XIZI_FEATURES

void TestUart(int argc, char* argv[])
{
    static char program_info[] = "App Test uart, sending a message through uart and receive messages from uart.";
    static const char* const usages[] = {
        "TestUart -m arg",
        NULL,
    };

    bool is_help = false;
    char* msg = NULL;
    struct argparse_option options[] = {
        OPT_HELP(&is_help),
        OPT_STRING('m', "message", &msg, "MESSAGE to send through uart.", NULL, 0, 0),
        OPT_END(),
    };
    struct argparse argparse;
    argparse_init(&argparse, options, usages, 0);
    argparse_describe(&argparse, NULL, program_info);
    argc = argparse_parse(&argparse, argc, (const char**)argv);
    if (is_help) {
        return;
    }

    int uart_fd = PrivOpen(UART_DEV_DRIVER, O_RDWR);
    if (uart_fd < 0) {
        printf("open pin fd error:%d\n", uart_fd);
        return;
    }
    printf("[%s] Info: Uart and pin fopen success\n", __func__);

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

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = (void*)&uart_cfg;

    if (0 != PrivIoctl(uart_fd, OPE_INT, &ioctl_cfg)) {
        printf("[%s] Err: ioctl uart fd error %d\n", __func__, uart_fd);
        PrivClose(uart_fd);
        return;
    }
    PrivWrite(uart_fd, msg, strlen(msg));

    char recv_buf[100];
    while (1) {
        memset(recv_buf, 0, sizeof(recv_buf));
        PrivRead(uart_fd, recv_buf, sizeof(recv_buf));
        printf("[%s] Info: Recv from uart: %s\n", __func__, recv_buf);
    }

    PrivClose(uart_fd);
    return;
}

PRIV_SHELL_CMD_FUNCTION(TestUart, a uart test sample, PRIV_SHELL_CMD_MAIN_ATTR);
#endif