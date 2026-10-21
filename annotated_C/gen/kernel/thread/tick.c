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
* @file:    xs_base.h
* @brief:   basic data type defintions 
* @version: 1.0
* @author:  AIIT XUOS Lab
* @date:    2020/3/10
*
*/
/*  import  board special configuration */
/*  Automatically generated file; DO NOT EDIT. */
/*  XiZi_IIoT Project Configuration */
// #define ARCH_CPU_64BIT
// #define ARCH_RISCV64
/*  kd233 feature */
/*  config default board resources */
/*  config board app name */
/*  config board service table */
/*  config board peripheral */
/*  Hardware feature */
/*  Kernel feature */
/*  separate compile(choose none for compile once) */
/*  Memory Management */
/*  Using small memory allocator */
/*  Task feature */
/*  Inter-Task communication */
/*  Kernel Console */
/*  Kernel Hook */
/*  Command shell */
/*  Set shell user control */
/*  Set shell config param */
/*  Kernel data structure Manage */
/*  Kernel components init */
/*  hash table config */
/*  Kernel Lib */
/*  C++ features */
/*  File system */
/*  Tool feature */
/*  OTA function */
/*  APP_Framework */
/*  Framework */
/*  Security */
/*  Applications */
/*  config stack size and priority of main task */
/*  test app */
/*  connection app */
/*  control app */
/*  knowing app */
/*  sensor app */
/*  app lib */
/*  lib using cJSON */
/*  lib using queue */
/*  lib using LVGL */
/*  lvgl image display parameter settings */
/*  lib using embedded_database */
/*  lib using LoRaWan */
/*  lib using MQTT */
/*  lib using JerryScript */
/*  lib using SQLite */
/*  lib using PikaPython */
typedef signed char int8;
typedef signed short int16;
typedef signed int int32;
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef signed long long int64;
typedef unsigned long long uint64;
typedef int x_bool;
typedef long x_base;
typedef unsigned long x_ubase;
typedef x_base x_err_t;
typedef uint32 x_time_t;
typedef uint32 x_ticks_t;
typedef x_base x_flag_t;
typedef x_ubase x_size_t;
typedef x_ubase x_dev_t;
typedef x_base x_OffPos;
/* the type of components*/
/* the type of error */
// void KPrintf(const char *fmt, ...);
/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosRules */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelay */
/*@ Import Coq Require Import CRTOS_Verify.libai.TickConversion */
/*@ Extern Coq (heartbeat_ticks_addr : Z) */
/*@ Extern Coq
      (tick_from_time_ms : Z -> Z)
      (time_ms_from_tick : Z -> Z)
 */
static x_ticks_t heartbeat_ticks = 0;
/**
 * get haertbeat count
 *
 * @return CurrentTicks
 */
x_ticks_t CurrentTicksGain(void)
/*@ With os_tick
    Require store_uint(heartbeat_ticks_addr, os_tick)
    Ensure __return == os_tick &&
           store_uint(heartbeat_ticks_addr, os_tick)
 */
{
    /*@ store_uint(heartbeat_ticks_addr, os_tick)
        which implies
        store_uint(&heartbeat_ticks, os_tick)
     */
    return heartbeat_ticks;
}
/**
 * this function increases global systick in tick interrupt,and process task time slice
 *
 */
// CheckTaskDelay --> KTaskTimeout --> DO_KTASK_ASSIGN
/* TickAndTaskTimesliceUpdate is outside this verification target. */










/**
 * This function will convert ms to ticks.
 *
 * @param ms time need to be converted
 * @return ticks
 */
x_ticks_t CalculateTickFromTimeMs(uint32 ms)
/*@ Require
      0 <= ms && ms <= UINT_MAX && emp
    Ensure
      __return == tick_from_time_ms(ms) && emp
 */
{
    uint32 tmp = 0;
    x_ticks_t ticks = 0;
    ticks = (uint32)(((uint64)(ms * 100)) / 1000) ;
    if (0 == ticks) {
        ticks = 1;
    } else {
        tmp = (uint32)(((uint64)(ms * 100)) % 1000);
        if(tmp >= 5 && tmp <= 9) {
            ticks = ticks + 1;
        }
    }
    return ticks;
}
/**
 * This function will convert ticks to ms.
 *
 * @param ticks ticks need to be converted
 * @return ms
 */
uint32 CalculateTimeMsFromTick(x_ticks_t ticks)
/*@ Require
      0 <= ticks && ticks <= UINT_MAX && emp
    Ensure
      __return == time_ms_from_tick(ticks) && emp
 */
{
    uint32 ms = 0;
    ms = (uint32)(((uint64)(ticks * 1000)) / 100);
    return ms;
}
