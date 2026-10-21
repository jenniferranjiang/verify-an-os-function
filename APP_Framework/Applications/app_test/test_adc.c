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
* @file:    test_adc.c
* @brief:   a application of adc function
* @version: 1.1
* @author:  AIIT XUOS Lab
* @date:    2022/1/7
*/

#include <stdio.h>
#include <string.h>
#include <transform.h>
#ifdef ADD_XIZI_FEATURES

void TestAdc(void)
{
    int adc_fd;
    uint8 adc_channel = 0x1;
    uint16 adc_sample = 0;

    adc_fd = PrivOpen(ADC_DEV_DRIVER, O_RDWR);
    if (adc_fd < 0) {
        printf("open adc fd error %d\n", adc_fd);
        return;
    }

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = ADC_TYPE;
    ioctl_cfg.args = &adc_channel;
    if (0 != PrivIoctl(adc_fd, OPE_CFG, &ioctl_cfg)) {
        printf("ioctl adc fd error %d\n", adc_fd);
        PrivClose(adc_fd);
        return;
    }

    for (int i = 0; i < 10; i ++) {
        PrivRead(adc_fd, &adc_sample, 2);
        printf("adc sample %u mv\n", adc_sample);
        PrivTaskDelay(500);
    }

    PrivClose(adc_fd);

    return;
}
PRIV_SHELL_CMD_FUNCTION(TestAdc, a adc test sample, PRIV_SHELL_CMD_MAIN_ATTR);
#endif