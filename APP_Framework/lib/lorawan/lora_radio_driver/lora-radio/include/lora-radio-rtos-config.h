/*!
 * \file      lora-radio-rtos-config.h
 *
 * \brief     adapter to different RTOS implementation
 *
 * \copyright SPDX-License-Identifier: Apache-2.0
 *
 * \author    Forest-Rain
 */

/**
* @file lora-radio-rtos-config.h
* @brief support lora-radio-driver for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-03-07
*/

/*************************************************
File name: lora-radio-rtos-config.h
Description: support lora-radio-driver for XiUOS
Others: 
History: 
1. Date: 2023-03-07
Author: AIIT XUOS Lab
Modification: 
1、add LORA_RADIO_DRIVER_USING_RTOS_XIUOS to support XiUOS.
*************************************************/
 
#ifndef __LORA_RADIO_RTOS_CONFIG_H_
#define __LORA_RADIO_RTOS_CONFIG_H_

#include <transform.h>

// default based on rt-thread
//#define LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD 
//#define LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD_NANO
//#define LORA_RADIO_DRIVER_USING_RTOS_XIUOS

#ifdef LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD
#elif defined LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD_NANO
#elif defined LORA_RADIO_DRIVER_USING_RTOS_XIUOS
#else
    #error "Please Choose your RTOS setup!"
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD
#include "rtconfig.h"
#include <rtthread.h>
#include <rtdevice.h>
#include "drv_spi.h"

#define LOG_LVL_ASSERT                 0
#define LOG_LVL_ERROR                  3
#define LOG_LVL_WARNING                4
#define LOG_LVL_INFO                   6
#define LOG_LVL_DBG                    7

#elif defined LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD_NANO
#include <rtthread.h>

#elif defined LORA_RADIO_DRIVER_USING_RTOS_XIUOS

#define LOG_LVL_ASSERT                 0
#define LOG_LVL_ERROR                  3
#define LOG_LVL_WARNING                4
#define LOG_LVL_INFO                   6
#define LOG_LVL_DBG                    7

#endif

#endif // end of __LORA_RADIO_RTOS_CONFIG_H_
