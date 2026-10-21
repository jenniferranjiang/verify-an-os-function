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
 * File: $Id: porttimer_m.c,v 1.60 2013/08/13 15:07:05 Armink add Master Functions$
 */

/**
* @file porttimer_m.c
* @brief support freemodbus port for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-10-12
*/

/*************************************************
File name: porttimer_m.c
Description: support freemodbus port for XiUOS
Others: 
History: 
1. Date: 2023-10-12
Author: AIIT XUOS Lab
Modification: 
1、support XiUOS timer for master.
*************************************************/

/* ----------------------- Platform includes --------------------------------*/
#include "port.h"

/* ----------------------- Modbus includes ----------------------------------*/
#include "mb.h"
#include "mb_m.h"
#include "mbport.h"

#if MB_MASTER_RTU_ENABLED > 0 || MB_MASTER_ASCII_ENABLED > 0
#ifdef ADD_RTTHREAD_FEATURES
/* ----------------------- Variables ----------------------------------------*/
static USHORT usT35TimeOut50us;
static struct rt_timer timer;
static void prvvTIMERExpiredISR(void);
static void timer_timeout_ind(void* parameter);

/* ----------------------- static functions ---------------------------------*/
static void prvvTIMERExpiredISR(void);

/* ----------------------- Start implementation -----------------------------*/
BOOL xMBMasterPortTimersInit(USHORT usTimeOut50us)
{
    /* backup T35 ticks */
    usT35TimeOut50us = usTimeOut50us;

    rt_timer_init(&timer, "master timer",
                   timer_timeout_ind, /* bind timeout callback function */
                   RT_NULL,
                   (50 * usT35TimeOut50us) / (1000 * 1000 / RT_TICK_PER_SECOND) + 1,
                   RT_TIMER_FLAG_ONE_SHOT); /* one shot */

    return TRUE;
}

void vMBMasterPortTimersT35Enable()
{
    rt_tick_t timer_tick = (50 * usT35TimeOut50us)
            / (1000 * 1000 / RT_TICK_PER_SECOND) + 1;

    /* Set current timer mode, don't change it.*/
    vMBMasterSetCurTimerMode(MB_TMODE_T35);

    rt_timer_control(&timer, RT_TIMER_CTRL_SET_TIME, &timer_tick);

    rt_timer_start(&timer);
}

void vMBMasterPortTimersConvertDelayEnable()
{
    rt_tick_t timer_tick = MB_MASTER_DELAY_MS_CONVERT * RT_TICK_PER_SECOND / 1000;

    /* Set current timer mode, don't change it.*/
    vMBMasterSetCurTimerMode(MB_TMODE_CONVERT_DELAY);

    rt_timer_control(&timer, RT_TIMER_CTRL_SET_TIME, &timer_tick);

    rt_timer_start(&timer);
}

void vMBMasterPortTimersRespondTimeoutEnable()
{
    rt_tick_t timer_tick = MB_MASTER_TIMEOUT_MS_RESPOND * RT_TICK_PER_SECOND / 1000;

    /* Set current timer mode, don't change it.*/
    vMBMasterSetCurTimerMode(MB_TMODE_RESPOND_TIMEOUT);

    rt_timer_control(&timer, RT_TIMER_CTRL_SET_TIME, &timer_tick);

    rt_timer_start(&timer);
}

void vMBMasterPortTimersDisable()
{
    rt_timer_stop(&timer);
}

void prvvTIMERExpiredISR(void)
{
    (void) pxMBMasterPortCBTimerExpired();
}

static void timer_timeout_ind(void* parameter)
{
    prvvTIMERExpiredISR();
}
#endif


#ifdef ADD_XIZI_FEATURES
/* ----------------------- Variables ----------------------------------------*/
static USHORT usT35TimeOut50us;
static timer_t timer_id;
static void prvvTIMERExpiredISR(void);
static void timer_timeout_ind(union sigval sig_val);

/* ----------------------- static functions ---------------------------------*/
static void prvvTIMERExpiredISR(void);

/* ----------------------- Start implementation -----------------------------*/
BOOL xMBMasterPortTimersInit(USHORT usTimeOut50us)
{
    /* backup T35 ticks */
    usT35TimeOut50us = usTimeOut50us;

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

    return TRUE;
}

void vMBMasterPortTimersT35Enable()
{
    int timer_tick = (50 * usT35TimeOut50us)
            / (1000 * 1000 / TICK_PER_SECOND) + 1;

    /* Set current timer mode, don't change it.*/
    vMBMasterSetCurTimerMode(MB_TMODE_T35);

    UserTimerModify(timer_id, timer_tick);

    UserTimerStartRun(timer_id);
}

void vMBMasterPortTimersConvertDelayEnable()
{
    int timer_tick = MB_MASTER_DELAY_MS_CONVERT * TICK_PER_SECOND / 1000;

    /* Set current timer mode, don't change it.*/
    vMBMasterSetCurTimerMode(MB_TMODE_CONVERT_DELAY);

    UserTimerModify(timer_id, timer_tick);

    UserTimerStartRun(timer_id);
}

void vMBMasterPortTimersRespondTimeoutEnable()
{
    int timer_tick = MB_MASTER_TIMEOUT_MS_RESPOND * TICK_PER_SECOND / 1000;

    /* Set current timer mode, don't change it.*/
    vMBMasterSetCurTimerMode(MB_TMODE_RESPOND_TIMEOUT);

    UserTimerModify(timer_id, timer_tick);

    UserTimerStartRun(timer_id);
}

void vMBMasterPortTimersDisable()
{
    PrivTimerQuitRun(timer_id);
}

void prvvTIMERExpiredISR(void)
{
    (void) pxMBMasterPortCBTimerExpired();
}

static void timer_timeout_ind(union sigval sig_val)
{
    prvvTIMERExpiredISR();
}
#endif

#endif
