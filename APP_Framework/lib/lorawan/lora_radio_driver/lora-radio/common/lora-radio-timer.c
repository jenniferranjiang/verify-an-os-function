/*!
 * \file      lora-radio-timer.c
 *
 * \brief     lora-radio timer 
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * \author    DerekChen
 * 
 * \author    AIIT XUOS Lab
 */

/**
* @file lora-radio-timer.c
* @brief support lora-radio-driver for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-03-08
*/

/*************************************************
File name: lora-radio-timer.c
Description: support lora-radio-driver for XiUOS
Others: 
History: 
1. Date: 2023-03-08
Author: AIIT XUOS Lab
Modification: 
1、add LORA_RADIO_DRIVER_USING_RTOS_XIUOS to support XiUOS.
*************************************************/

#include <lora-radio-rtos-config.h>
#include <stdint.h>
#include "lora-radio-timer.h"

#if defined ( LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD ) || defined ( LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD_NANO )
#ifndef PKG_USING_MULTI_RTIMER

void rtick_timer_init( rtick_timer_event_t *obj, void ( *callback )( void ) )
{
    int count = 0;
    
    char name[RT_NAME_MAX];
    rt_snprintf(name,8,"rtk_%d",count++);

    rt_timer_init(&(obj->timer),name,(void (*)(void*))callback,RT_NULL,1000,RT_TIMER_FLAG_ONE_SHOT|RT_TIMER_FLAG_SOFT_TIMER);
}

void rtick_timer_start( rtick_timer_event_t *obj )
{
    rt_timer_start(&(obj->timer));
}

void rtick_timer_stop( rtick_timer_event_t *obj )
{
    rt_timer_stop(&(obj->timer));
}

void rtick_timer_reset( rtick_timer_event_t *obj )
{
    rtick_timer_stop(obj);
    rtick_timer_start(obj);
}

void rtick_timer_set_value( rtick_timer_event_t *obj, uint32_t value )
{
    uint32_t tick = rt_tick_from_millisecond(value);
    rt_timer_control(&(obj->timer),RT_TIMER_CTRL_SET_TIME,&tick);
}

TimerTime_t rtick_timer_get_current_time( void )
{
    uint32_t now = rt_tick_get();
    return  now;
}

TimerTime_t rtick_timer_get_elapsed_time( TimerTime_t past )
{
    return rt_tick_get() - past;
}

#endif

#endif // End Of  ( LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD ) || defined ( LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD_NANO )

#if defined LORA_RADIO_DRIVER_USING_RTOS_XIUOS

#define TIMER_NUM 20

typedef void (*timer_input_callback_entry)(void);
typedef struct {
    timer_input_callback_entry callback_entry;
}timer_input_callback_entry_fun;

static timer_input_callback_entry_fun g_timer_input_callback_entry_fun[TIMER_NUM];

static void timer_callback(union sigval sig_val) 
{
    uint8_t timer_id = *((uint8_t *)sig_val.sival_ptr);
    g_timer_input_callback_entry_fun[timer_id].callback_entry();
}

void rtick_timer_init( rtick_timer_event_t *obj, void ( *callback )( void ) )
{
    int ret = 0;
    int timer_flags;
    static int count = 0; 

    struct sigevent evp;
    memset(&evp, 0, sizeof(struct sigevent));
    
    timer_flags = TIMER_TRIGGER_ONCE;

    count++;

    g_timer_input_callback_entry_fun[count].callback_entry = callback;
    evp.sigev_notify = SIGEV_THREAD; 
    evp.sigev_notify_function = timer_callback;
    evp.sigev_notify_attributes = &timer_flags;

    ret = PrivTimerCreate(count, &evp, &(obj->timer_id));
    if (ret < 0) {
        printf("%s create timer failed ret %d\n", __func__, ret);
        return;
    }
}

void rtick_timer_start( rtick_timer_event_t *obj )
{
    PrivTimerStartRun(obj->timer_id);
}

void rtick_timer_stop( rtick_timer_event_t *obj )
{
    PrivTimerQuitRun(obj->timer_id);
}

void rtick_timer_reset( rtick_timer_event_t *obj )
{
    rtick_timer_stop(obj);
    rtick_timer_start(obj);
}

void rtick_timer_set_value( rtick_timer_event_t *obj, uint32_t value )
{
    int ret;
    uint32_t input_value, ms_value, s_value;
    struct itimerspec it_value; 
    //active time interval
    input_value = value;
    if (input_value >= 1000) {
        ms_value = input_value % 1000;
        s_value = (input_value - ms_value) / 1000;
    } else {
        ms_value = input_value;
        s_value = 0;
    }

    it_value.it_interval.tv_sec = s_value; 
    it_value.it_interval.tv_nsec = ms_value * 1000000;//1ms = 1000000ns

    ret = PrivTimerModify(obj->timer_id, 0, &it_value, NULL);
    if (ret < 0) { 
        printf("%s set timer time failed ret %d\n", __func__, ret);
        return;
    }
}

TimerTime_t rtick_timer_get_current_time( void )
{
    uint32_t now = PRIV_SYSTICK_GET;
    return now;
}

TimerTime_t rtick_timer_get_elapsed_time( TimerTime_t past )
{
    return PRIV_SYSTICK_GET - past;
}

#endif

