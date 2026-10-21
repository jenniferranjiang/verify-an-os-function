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
 * File: $Id: porttimer.c,v 1.60 2013/08/13 15:07:05 Armink $
 */

/**
* @file porttimer.c
* @brief support freemodbus port for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-10-12
*/

/*************************************************
File name: porttimer.c
Description: support freemodbus port for XiUOS
Others: 
History: 
1. Date: 2023-10-12
Author: AIIT XUOS Lab
Modification: 
1、support XiUOS timer for slave.
*************************************************/

/* ----------------------- Platform includes --------------------------------*/
#include "port.h"

/* ----------------------- Modbus includes ----------------------------------*/
#include "mb.h"
#include "mbport.h"

#ifdef ADD_RTTHREAD_FEATURES
/* ----------------------- static functions ---------------------------------*/
static struct rt_timer timer;
static void prvvTIMERExpiredISR(void);
static void timer_timeout_ind(void* parameter);

/* ----------------------- Start implementation -----------------------------*/
BOOL xMBPortTimersInit(USHORT usTim1Timerout50us)
{
    rt_timer_init(&timer, "slave timer",
                   timer_timeout_ind, /* bind timeout callback function */
                   RT_NULL,
                   (50 * usTim1Timerout50us) / (1000 * 1000 / RT_TICK_PER_SECOND) + 1,
                   RT_TIMER_FLAG_ONE_SHOT); /* one shot */
    return TRUE;
}

void vMBPortTimersEnable()
{
    rt_timer_start(&timer);
}

void vMBPortTimersDisable()
{
    rt_timer_stop(&timer);
}

void prvvTIMERExpiredISR(void)
{
    (void) pxMBPortCBTimerExpired();
}

static void timer_timeout_ind(void* parameter)
{
    prvvTIMERExpiredISR();
}
#endif

#ifdef ADD_XIZI_FEATURES
/* ----------------------- static functions ---------------------------------*/
static timer_t timer_id;
static void prvvTIMERExpiredISR(void);
static void timer_timeout_ind(union sigval sig_val);

/* ----------------------- Start implementation -----------------------------*/
BOOL xMBPortTimersInit(USHORT usTim1Timerout50us)
{
    int ret = 0;
    int timer_flags;
    static int count = 0; 

    struct sigevent evp;
    memset(&evp, 0, sizeof(struct sigevent));
    
    timer_flags = TIMER_TRIGGER_ONCE;

    count++;

    evp.sigev_notify = SIGEV_THREAD; 
    evp.sigev_notify_function = timer_timeout_ind;
    evp.sigev_notify_attributes = &timer_flags;

    ret = PrivTimerCreate(count, &evp, &timer_id);
    if (ret < 0) {
        printf("%s create timer failed ret %d\n", __func__, ret);
        return FALSE;
    }

    UserTimerModify(timer_id, (50 * usTim1Timerout50us) / (1000 * 1000 / TICK_PER_SECOND) + 1);

    return TRUE;
}

void vMBPortTimersEnable()
{
    PrivTimerStartRun(timer_id);
}

void vMBPortTimersDisable()
{
    PrivTimerQuitRun(timer_id);
}

void prvvTIMERExpiredISR(void)
{
    (void) pxMBPortCBTimerExpired();
}

static void timer_timeout_ind(union sigval sig_val)
{
    prvvTIMERExpiredISR();
}
#endif

