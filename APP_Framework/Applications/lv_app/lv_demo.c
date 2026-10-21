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
* @file:    lv_demo.c
* @brief:   a application using littleVgl
* @version: 2.0
* @author:  AIIT XUOS Lab
* @date:    2022/9/26
*
*/

#include <lvgl.h>
#include <lv_port_indev_template.h>
#include "lv_demo_calendar.h"
#include <transform.h>

extern void lv_example_show(void);
void* lvgl_thread(void *parameter)
{
    lv_example_show();
    while(1)
    {
        lv_task_handler();
        PrivTaskDelay(10);
    }
}

static pthread_t lvgl_task;
static int lvgl_demo_init(void)
{
    pthread_attr_t attr;
    attr.schedparam.sched_priority = 25;
    attr.stacksize = 8192;

    PrivTaskCreate(&lvgl_task, &attr, lvgl_thread, NULL);

    return 0;
}
PRIV_SHELL_CMD_FUNCTION(lvgl_demo_init, a littlevgl init sample, PRIV_SHELL_CMD_MAIN_ATTR);
