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
* @file sqlite_config_xiuos.h
* @brief support SQLite define for XiUOS, include rtthread and xizi kernel
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-10-16
*/

/*************************************************
File name: sqlite_config_xiuos.h
Description: support SQLite define for XiUOS, include rtthread and xizi kernel
Others: 
History: 
1. Date: 2023-10-16
Author: AIIT XUOS Lab
Modification: 
1、modify ifndef description
*************************************************/

#ifndef _SQLITE_CONFIG_XIUOS_H_
#define _SQLITE_CONFIG_XIUOS_H_

#include <transform.h>

/*
* SQLite compile macro
*/
#ifndef SQLITE_MINIMUM_FILE_DESCRIPTOR
#define SQLITE_MINIMUM_FILE_DESCRIPTOR  0
#endif

#define SQLITE_OMIT_LOAD_EXTENSION 0

#define SQLITE_OMIT_WAL 1

#define SQLITE_OMIT_AUTOINIT 1

#ifndef SQLITE_RTTHREAD_NO_WIDE
#define SQLITE_RTTHREAD_NO_WIDE 1
#endif

#ifndef SQLITE_TEMP_STORE
#define SQLITE_TEMP_STORE 1
#endif

#ifndef SQLITE_THREADSAFE
#define SQLITE_THREADSAFE 1
#endif

#ifndef HAVE_READLINE
#define HAVE_READLINE 0
#endif

#ifndef NDEBUG
#define NDEBUG
#endif

#ifndef SQLITE_OS_OTHER
#define SQLITE_OS_OTHER 1
#endif

#ifndef SQLITE_OS_XIUOS
#define SQLITE_OS_XIUOS 1
#endif

#ifndef PKG_SQLITE_SQL_MAX_LEN
#define PKG_SQLITE_SQL_MAX_LEN LIB_SQLITE_SQL_MAX_LEN
#endif

#ifndef PKG_SQLITE_DB_NAME_MAX_LEN
#define PKG_SQLITE_DB_NAME_MAX_LEN LIB_SQLITE_DB_NAME_MAX_LEN
#endif

#ifndef SQLITE_ASSERT
#define SQLITE_ASSERT(EXPR)                                                    \
if (!(EXPR))                                                                   \
{                                                                              \
    printf("(%s) has CHECK failed at %s.", #EXPR, __FUNCTION__);               \
    while (1);                                                                 \
}

#endif

#endif
