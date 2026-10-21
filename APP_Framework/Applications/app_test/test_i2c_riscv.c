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
#include <sleep.h>
#ifdef ADD_XIZI_FEATURES

#define I2C_SLAVE_ADDRESS (0x44U)

void TestI2C(void)
{
    // config IIC pin(SCL:34.SDA:35) in menuconfig
    int iic_fd = PrivOpen(I2C_DEV_DRIVER, O_RDWR);
    if (iic_fd < 0)
    {
        printf("open iic_fd fd error:%d\n", iic_fd);
        return;
    }
    printf("IIC open successful!\n");

    // init iic
    uint16 iic_address = I2C_SLAVE_ADDRESS;

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = I2C_TYPE;
    ioctl_cfg.args = (void *)&iic_address;

    if (0 != PrivIoctl(iic_fd, OPE_INT, &ioctl_cfg))
    {
        printf("ioctl iic fd error %d\n", iic_fd);
        PrivClose(iic_fd);
        return;
    }
    printf("IIC configure successful!\n");

    // I2C read and write
    uint8_t data[32];

    while (1)
    {        
        PrivWrite(iic_fd, NONE, 0);
        msleep(40);
        PrivRead(iic_fd, data, 4);

        float result = ((data[2]  << 8 | data[3]) >> 2) * 165.0 /( (1 << 14) - 1) -  40.0;
        int temperature = result*10;
        printf("Temperature : %d.%d ℃\n", temperature/10, temperature%10);

        result = ((data[0] << 8 | data[1] ) & 0x3fff) * 100.0 / ( (1 << 14) - 1);
        int humidity = result*10;
        printf("Humidity : %d.%d %%RH\n", humidity/10, humidity%10);

        printf("HS300X origin data1:0x%2x%2x%2x%2x\n", data[0],data[1],data[2],data[3]); 

        msleep(1000);
    }

    PrivClose(iic_fd);
    return;
}

PRIV_SHELL_CMD_FUNCTION(TestI2C, a iic test sample, PRIV_SHELL_CMD_MAIN_ATTR);
#endif