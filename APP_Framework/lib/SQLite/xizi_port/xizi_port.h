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
* @file xizi_port.h
* @brief support SQLite define for xizi port files
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-10-25
*/

/*************************************************
File name: xizi_port.h
Description: support SQLite define for xizi port files
Others: 
History: 
1. Date: 2023-10-25
Author: AIIT XUOS Lab
Modification: 
1、modify ifndef description
*************************************************/

#ifndef _XIZI_PORT_H_
#define _XIZI_PORT_H_

#include <transform.h>
#include <sqlite_config_xiuos.h>
#include <sqlite3.h>

typedef struct
{
    sqlite3_io_methods const *pMethod;
    sqlite3_vfs *pvfs;
    int fd;
    int eFileLock;
    int szChunk;
    sem_t sem;
} XIZI_SQLITE_FILE_T;


int _xizi_get_temp_name(int nBuf, char *zBuf);

#endif
