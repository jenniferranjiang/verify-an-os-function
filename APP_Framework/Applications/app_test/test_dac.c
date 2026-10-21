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
* @file:    test_dac.c
* @brief:   a application of dac function
* @version: 2.0
* @author:  AIIT XUOS Lab
* @date:    2022/1/11
*/
#include <stdio.h>
#include <string.h>
#include <transform.h>
#ifdef ADD_XIZI_FEATURES

static pthread_t test_dac_task;

static void *TestDacTask(void *parameter)
{
    int dac_fd;
    uint16 dac_set_value = 4096 * 10;//sin length

    dac_fd = PrivOpen(DAC_DEV_DRIVER, O_RDWR);
    if (dac_fd < 0) {
        KPrintf("open dac fd error %d\n", dac_fd);
    }

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = DAC_TYPE;
    ioctl_cfg.args = &dac_set_value;
    if (0 != PrivIoctl(dac_fd, OPE_CFG, &ioctl_cfg)) {
        KPrintf("ioctl dac fd error %d\n", dac_fd);
        PrivClose(dac_fd);
    }

    while (1) {
        //start dac output sin
        PrivWrite(dac_fd, NULL, 0);
    }

    PrivClose(dac_fd);
}

void TestDac(void)
{
    pthread_attr_t tid;
    tid.schedparam.sched_priority = 20;
    tid.stacksize = 4096;

    PrivTaskCreate(&test_dac_task, &tid, &TestDacTask, NULL);
    PrivTaskStartup(&test_dac_task);
}
PRIV_SHELL_CMD_FUNCTION(TestDac, a dac test sample, PRIV_SHELL_CMD_MAIN_ATTR);
#endif