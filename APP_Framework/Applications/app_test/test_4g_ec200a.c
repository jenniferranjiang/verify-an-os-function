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
 * @file test_4g_ec200a.c
 * @brief Implement the connection 4G function, using QUECTEL EC200A device
 * @version 1.1
 * @author AIIT XUOS Lab
 * @date 2023.10.15
 */

#include <stdio.h>
#include <string.h>
#include <transform.h>

#ifdef ADD_XIZI_FEATURES

char *trans_data = "{\"saleid\": \"52330000MJ87322565\", \"gateid\": \"10100001011\", \"type\": \"report\", \"time\": \"2023-06-15 17:22:00\", \"sequence\": \"268\", \"source\": \"da\", \"meter\": [{\"id\": \"T100106\", \"status\": \"1\", \"name\": \"T100106\", \"values\": {}}]}\r\n";
// const char chk_buad[] = {"AT+IPR?\r\n"};
const char set_mode[] = {"AT+QMTCFG=\"recv/mode\",0,0,1\r\n"};
// const char set_cfg[] = {"AT+QMTCFG=\"aliauth\",0,\"k0celEMx5DK\",\"test_device\",\"411aa14c0dc671f7ee869adced442d13\"\r\n"};
const char set_server[] = {"AT+QMTOPEN=0,\"xyheqmx.e3.luyouxia.net\",13333\r\n"};
// const char set_server[] = {"AT+QMTOPEN=0,\"iot-060a7p7c.mqtt.iothub.aliyuncs.com\",1883\r\n"};
const char set_conn[] = {"AT+QMTCONN=0,\"quectel\",\"test\",\"test123456\"\r\n"};
// const char set_conn[] = {"AT+QMTCONN=0,\"sysoul\"\r\n"};
// const char set_get[] = {"AT+QMTSUB=0,1,\"/get\",0\r\n"};
// const char set_reply[] = {"AT+QMTPUBEX=0,0,0,0,\"/reply\",1000\r\n"};
char recv_buf[100] = {0};
int buf_len = 0;


void Test4G(void)
{
    int quectel_fd = PrivOpen(ADAPTER_QUECTEL_DRIVER, O_RDWR);
    if (quectel_fd < 0) {
        printf("open quectel fd error:%d\n", quectel_fd);
        return;
    }
    printf("quectel fopen success\n");

    struct SerialDataCfg quectel_cfg;
    memset(&quectel_cfg, 0, sizeof(struct SerialDataCfg));
    quectel_cfg.serial_baud_rate = BAUD_RATE_115200;
    quectel_cfg.serial_data_bits = DATA_BITS_8;
    quectel_cfg.serial_stop_bits = STOP_BITS_1;
    quectel_cfg.serial_parity_mode = PARITY_NONE;
    quectel_cfg.serial_bit_order = BIT_ORDER_LSB;
    quectel_cfg.serial_invert_mode = NRZ_NORMAL;
    // quectel_cfg.serial_buffer_size = SERIAL_RB_BUFSZ;
    quectel_cfg.serial_buffer_size = 1024;
    quectel_cfg.serial_timeout = 1000;
    quectel_cfg.is_ext_uart = 0;
    // quectel_cfg.ext_uart_no = ADAPTER_QUECTEL_DRIVER_EXT_PORT;
    // quectel_cfg.port_configure = PORT_CFG_INIT;

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = &quectel_cfg;
    if (0 != PrivIoctl(quectel_fd, OPE_INT, &ioctl_cfg)) {
        printf("ioctl quectel fd error %d\n", quectel_fd);
        PrivClose(quectel_fd);
        return;
    }

    printf("4G module set\n");

    // memset(recv_buf, 0, sizeof(recv_buf));
    // printf("chk_buad: %s\n", chk_buad);
    // printf("chk_buad_len: %d\n", strlen(chk_buad));
    // PrivWrite(quectel_fd, chk_buad, strlen(chk_buad));
    // PrivTaskDelay(30);
    // buf_len = PrivRead(quectel_fd, recv_buf, sizeof(recv_buf));
    // printf("buf_len: %d\n", buf_len);
    // printf("[%s] Info: Recv from uart: %s\n", __func__, recv_buf);
    // PrivTaskDelay(1000);

    memset(recv_buf, 0, sizeof(recv_buf));
    printf("set_mode: %s\n", set_mode);
    printf("set_mode_len: %d\n", strlen(set_mode));
    PrivWrite(quectel_fd, set_mode, strlen(set_mode));
    PrivTaskDelay(30);
    buf_len = PrivRead(quectel_fd, recv_buf, sizeof(recv_buf));
    printf("buf_len: %d\n", buf_len);
    printf("[%s] Info: Recv from uart: %s\n", __func__, recv_buf);
    PrivTaskDelay(1000);

    // memset(recv_buf, 0, sizeof(recv_buf));
    // printf("set_cfg: %s\n", set_cfg);
    // printf("set_cfg_len: %d\n", strlen(set_cfg));
    // PrivWrite(quectel_fd, set_cfg, strlen(set_cfg));
    // PrivTaskDelay(30);
    // buf_len = PrivRead(quectel_fd, recv_buf, sizeof(recv_buf));
    // printf("buf_len: %d\n", buf_len);
    // printf("[%s] Info: Recv from uart: %s\n", __func__, recv_buf);
    // PrivTaskDelay(1000);

    memset(recv_buf, 0, sizeof(recv_buf));
    printf("set_server: %s\n", set_server);
    printf("set_server_len: %d\n", strlen(set_server));
    PrivWrite(quectel_fd, set_server, strlen(set_server));
    PrivTaskDelay(30);
    buf_len = PrivRead(quectel_fd, recv_buf, sizeof(recv_buf));
    printf("buf_len: %d\n", buf_len);
    printf("[%s] Info: Recv from uart: %s\n", __func__, recv_buf);
    PrivTaskDelay(1000);
    
    memset(recv_buf, 0, sizeof(recv_buf));
    printf("set_conn: %s\n", set_conn);
    printf("set_conn_len: %d\n", strlen(set_conn));
    PrivWrite(quectel_fd, set_conn, strlen(set_conn));
    PrivTaskDelay(30);
    buf_len = PrivRead(quectel_fd, recv_buf, sizeof(recv_buf));
    printf("buf_len: %d\n", buf_len);
    printf("[%s] Info: Recv from uart: %s\n", __func__, recv_buf);
    PrivTaskDelay(1000);

    while (1) {
        printf("start send\n");
        char set_reply[50] = {"AT+QMTPUBEX=0,0,0,0,\"/reply\","};
        char data_len_str[20];
        sprintf(data_len_str, "%d", strlen(trans_data));
        printf("data_len_str: %s\n", data_len_str);
        strcat(set_reply, data_len_str);
        strcat(set_reply, "\r\n");

        memset(recv_buf, 0, sizeof(recv_buf));
        printf("set_reply: %s\n", set_reply);
        printf("set_reply_len: %d\n", strlen(set_reply));
        PrivWrite(quectel_fd, set_reply, strlen(set_reply));
        PrivTaskDelay(30);
        buf_len = PrivRead(quectel_fd, recv_buf, sizeof(recv_buf));
        printf("buf_len: %d\n", buf_len);
        printf("[%s] Info: Recv from uart: %s\n", __func__, recv_buf);
        PrivTaskDelay(500);
       
        memset(recv_buf, 0, sizeof(recv_buf));
        printf("send_data: %s\n", trans_data);
        printf("send_data_len: %d\n", strlen(trans_data));
        PrivWrite(quectel_fd, trans_data, strlen(trans_data));
        PrivTaskDelay(30);
        buf_len = PrivRead(quectel_fd, recv_buf, sizeof(recv_buf));
        printf("buf_len: %d\n", buf_len);
        printf("[%s] Info: Recv from uart: %s\n", __func__, recv_buf);
        PrivTaskDelay(5000);
    }

    PrivClose(quectel_fd);
    
    return;
}

PRIV_SHELL_CMD_FUNCTION(Test4G, a quectel test sample, PRIV_SHELL_CMD_MAIN_ATTR);
#endif