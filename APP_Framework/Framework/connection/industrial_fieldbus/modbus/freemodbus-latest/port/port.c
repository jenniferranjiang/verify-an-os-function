 /*
  * FreeModbus Libary: RT-Thread Port
  * Copyright (C) 2013 Armink <armink.ztl@gmail.com>
  *
  * This library is free software; you can redistribute it and/or
  * modify it under the terms of the GNU Lesser General Public
  * License as published by the Free Software Foundation; either
  * version 2.1 of the License, or (at your option) any later version.
  *
  * This library is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
  * License along with this library; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
  * File: $Id: port.c,v 1.60 2015/02/01 9:18:05 Armink $
  */

/**
* @file port.c
* @brief support freemodbus port for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-10-12
*/

/*************************************************
File name: port.c
Description: support freemodbus port for XiUOS
Others: 
History: 
1. Date: 2023-10-12
Author: AIIT XUOS Lab
Modification: 
1、support XiUOS sem.
*************************************************/

/* ----------------------- System includes --------------------------------*/

/* ----------------------- Modbus includes ----------------------------------*/
#include "port.h"
/* ----------------------- Variables ----------------------------------------*/
#ifdef ADD_RTTHREAD_FEATURES
static struct rt_semaphore lock;
#endif

#ifdef ADD_XIZI_FEATURES
static sem_t sem;
#endif

static int is_inited = 0;
/* ----------------------- Start implementation -----------------------------*/
#ifdef ADD_RTTHREAD_FEATURES
void EnterCriticalSection(void)
{
    rt_err_t err;
    if(!is_inited)
    {
        err = rt_sem_init(&lock, "fmb_lock", 1, RT_IPC_FLAG_PRIO);
        if(err != RT_EOK)
        {
            rt_kprintf("Freemodbus Critical init failed!\n");
        }
        is_inited = 1;
    }
    rt_sem_take(&lock, RT_WAITING_FOREVER);
}

void ExitCriticalSection(void)
{
    rt_sem_release(&lock);
}
#endif

#ifdef ADD_XIZI_FEATURES
void EnterCriticalSection(void)
{
    if(!is_inited) {
        PrivSemaphoreCreate(&sem, 0, 1);
        is_inited = 1;
    }
    PrivSemaphoreObtainWait(&sem, NULL);
}

void ExitCriticalSection(void)
{
    PrivSemaphoreAbandon(&sem);
}
#endif
