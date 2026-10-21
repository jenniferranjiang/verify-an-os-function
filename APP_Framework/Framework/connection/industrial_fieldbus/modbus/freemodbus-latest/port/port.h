/*
 * FreeModbus Libary: BARE Port
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
 * File: $Id: port.h ,v 1.60 2013/08/13 15:07:05 Armink add Master Functions $
 */

/**
* @file port.h
* @brief support freemodbus port for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-10-12
*/

/*************************************************
File name: port.h
Description: support freemodbus port for XiUOS
Others: 
History: 
1. Date: 2023-10-12
Author: AIIT XUOS Lab
Modification: 
1、add transform.h to support XiUOS.
*************************************************/

#ifndef _PORT_H
#define _PORT_H

#include <transform.h>
#include "mbconfig.h"

#ifdef ADD_RTTHREAD_FEATURES
#include <rthw.h>
#include <rtthread.h>
#endif

#include <assert.h>
#include <inttypes.h>

#define INLINE
#define PR_BEGIN_EXTERN_C           extern "C" {
#define PR_END_EXTERN_C             }

#define ENTER_CRITICAL_SECTION()    EnterCriticalSection()
#define EXIT_CRITICAL_SECTION()     ExitCriticalSection()

typedef uint8_t BOOL;

typedef unsigned char UCHAR;
typedef char    CHAR;

typedef uint16_t USHORT;
typedef int16_t SHORT;

typedef uint32_t ULONG;
typedef int32_t LONG;

#ifndef TRUE
#define TRUE            1
#endif

#ifndef FALSE
#define FALSE           0
#endif

#ifdef ADD_XIZI_FEATURES
#define MB_CHECK(TRUE_CONDITION)                                                                                            \
    do {                                                                                                                 \
        if (!(TRUE_CONDITION)) {                                                                                         \
            KPrintf("%s CHECK condition is false at line[%d] of [%s] func.\n", #TRUE_CONDITION, __LINE__, __FUNCTION__); \
            while (RET_TRUE)                                                                                             \
                ;                                                                                                        \
        }                                                                                                                \
    } while (0)
#endif

void EnterCriticalSection(void);
void ExitCriticalSection(void);

#endif
