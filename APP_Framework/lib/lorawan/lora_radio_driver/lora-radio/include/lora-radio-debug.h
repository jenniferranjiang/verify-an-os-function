/*!
 * \file      lora-radio-debug.h
 *
 * \brief     control all LoRa Radio Driver debug features.
 *
 * \copyright SPDX-License-Identifier: Apache-2.0
 *
 * \author    Forest-Rain
 * 
 * \author    AIIT XUOS Lab
 */

/**
* @file lora-radio-debug.h
* @brief support lora-radio-driver for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-03-07
*/

/*************************************************
File name: lora-radio-debug.h
Description: support lora-radio-driver for XiUOS
Others: 
History: 
1. Date: 2023-03-07
Author: AIIT XUOS Lab
Modification: 
1、add LORA_RADIO_DRIVER_USING_RTOS_XIUOS to support XiUOS.
*************************************************/
 
#ifndef __LORA_RADIO_DEBUG_H__
#define __LORA_RADIO_DEBUG_H__

#include "lora-radio-rtos-config.h"

#if ( defined LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD ) || ( defined LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD_NANO )
#include "rtconfig.h"
#ifdef RT_USING_ULOG
#include <rtdbg.h>
#include <ulog.h> 
#else

#endif

#endif

//#define LORA_RADIO_DRIVER_USING_LORA_RADIO_DEBUG
/* Using this macro to control all LoRa Radio Driver debug features. */
#ifdef LORA_RADIO_DRIVER_USING_LORA_RADIO_DEBUG

/* Turn on some of these (set to non-zero) to debug LoRa Radio */

/* API interface */
#ifndef LR_DBG_INTERFACE
#define LR_DBG_INTERFACE                    1
#endif

/*lora chip driver, eg: sx126x.c\sx27x.c*/
#ifndef LR_DBG_CHIP
#define LR_DBG_CHIP                         1
#endif

/* spi driver ,eg: lora-spi-board.c*/
#ifndef LR_DBG_SPI
#define LR_DBG_SPI                          1
#endif

/* board driver ,eg: sx1268-board.c*/
#ifndef LR_DBG_BOARD
#define LR_DBG_BOARD                        1
#endif

#if ( defined LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD ) || ( defined LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD_NANO )

#if defined RT_USING_ULOG
#define LORA_RADIO_DEBUG_LOG(type, level, ...)                                \
do                                                                            \
{                                                                             \
    if (type)                                                                 \
    {                                                                         \
        ulog_output(level, LOG_TAG, RT_TRUE, __VA_ARGS__);                    \
    }                                                                         \
}                                                                             \
while (0)

#else

#define LORA_RADIO_DEBUG_LOG(type, level, ...)                                \
do                                                                            \
{                                                                             \
    if (type)                                                                 \
    {                                                                         \
        rt_kprintf(__VA_ARGS__);                                              \
        rt_kprintf("\r\n");                                                   \
    }                                                                         \
}                                                                             \
while (0)
#endif

#elif ( defined LORA_RADIO_DRIVER_USING_RTOS_XIUOS )

#define LORA_RADIO_DEBUG_LOG(type, level, ...)                                \
do                                                                            \
{                                                                             \
    if (type)                                                                 \
    {                                                                         \
        printf(__VA_ARGS__);                                                  \
        printf("\r\n");                                                       \
    }                                                                         \
}                                                                             \
while (0)  

#endif

#else /* LORA_RADIO_DEBUG */

#define LORA_RADIO_DEBUG_LOG(type, level, ...)

#endif /* LORA_RADIO_DEBUG */

#endif /* __LORA_RADIO_DEBUG_H__ */
