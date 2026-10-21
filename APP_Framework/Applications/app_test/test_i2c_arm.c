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
* @file:    test_i2c.c
* @brief:   a application of i2c function
* @version: 1.1
* @author:  AIIT XUOS Lab
* @date:    2022/12/17
*/
#include <stdio.h>
#include <string.h>
#include <transform.h>
#ifdef ADD_XIZI_FEATURES

#define I2C_SLAVE_ADDRESS 0x0012U

int OpenIic(void)
{
    int iic_fd = PrivOpen(I2C_DEV_DRIVER, O_RDWR);
    if (iic_fd < 0)
    {
        printf("[TestI2C] Open iic_fd fd error: %d\n", iic_fd);
        return -ERROR;
    }
    printf("[TestI2C] IIC open successful!\n");

    uint16 iic_address = I2C_SLAVE_ADDRESS;

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = I2C_TYPE;
    ioctl_cfg.args = (void *)&iic_address;

    if (0 != PrivIoctl(iic_fd, OPE_INT, &ioctl_cfg))
    {
        printf("[TestI2C] Ioctl iic fd error %d\n", iic_fd);
        PrivClose(iic_fd);
        return -ERROR;
    }
    printf("IIC configure successful!\n");

    return iic_fd;
}

static const int nr_transmit = 15;

void TestMasterI2c(void)
{
    char recv_buff[13] = { 0 };

    int iic_fd = OpenIic();
    if (iic_fd < 0) {
        printf("[%s] Error open iic\n", __func__);
        return;
    }

    for (int transmit_cnt = 0; transmit_cnt < nr_transmit; transmit_cnt++) {
        // wait if you like.
        PrivTaskDelay(500);
        memset(recv_buff, 0, sizeof(recv_buff));
        PrivRead(iic_fd, recv_buff, sizeof(recv_buff));
        printf("[%s] Msg recv: %s\n", __func__, recv_buff);
    }

    PrivClose(iic_fd);
}

void TestSlaveI2c(void)
{
    char send_buff[] = "Hello, World";

    int iic_fd = OpenIic();

    for (int transmit_cnt = 0; transmit_cnt < nr_transmit; transmit_cnt++) {
        // wait if you like.
        PrivTaskDelay(500);
        PrivWrite(iic_fd, send_buff, sizeof(send_buff));
        printf("[%s] Msg send: %s\n", __func__, send_buff);
    }

    PrivClose(iic_fd);
}

PRIV_SHELL_CMD_FUNCTION(TestMasterI2c, a iic test sample, PRIV_SHELL_CMD_MAIN_ATTR);
PRIV_SHELL_CMD_FUNCTION(TestSlaveI2c, a iic test sample, PRIV_SHELL_CMD_MAIN_ATTR);

#endif