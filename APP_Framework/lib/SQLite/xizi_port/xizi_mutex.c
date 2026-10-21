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
* @file xizi_mutex.c
* @brief support SQLite mutex function in XiZi kernel
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-10-16
*/

/*************************************************
File name: xizi_mutex.c
Description: support SQLite mutex function in XiZi kernel
Others: 
History: 
1. Date: 2023-10-16
Author: AIIT XUOS Lab
Modification: 
1、add xizi mutex function.
*************************************************/

#include "xizi_port.h"

struct sqlite3_mutex {
    pthread_mutex_t mutex;          /* Mutex controlling the lock */
    int id;                         /* Mutex type */
};

static void sqlite3MemoryBarrier(void)
{

}

/*
** Initialize and deinitialize the mutex subsystem.
The argument to sqlite3_mutex_alloc() must one of these integer constants:
    SQLITE_MUTEX_FAST
    SQLITE_MUTEX_RECURSIVE
    SQLITE_MUTEX_STATIC_MASTER
    SQLITE_MUTEX_STATIC_MEM
    SQLITE_MUTEX_STATIC_OPEN
    SQLITE_MUTEX_STATIC_PRNG
    SQLITE_MUTEX_STATIC_LRU
    SQLITE_MUTEX_STATIC_PMEM
    SQLITE_MUTEX_STATIC_APP1
    SQLITE_MUTEX_STATIC_APP2
    SQLITE_MUTEX_STATIC_APP3
    SQLITE_MUTEX_STATIC_VFS1
    SQLITE_MUTEX_STATIC_VFS2
    SQLITE_MUTEX_STATIC_VFS3
The first two constants (SQLITE_MUTEX_FAST and SQLITE_MUTEX_RECURSIVE)
cause sqlite3_mutex_alloc() to create a new mutex. The new mutex is recursive
when SQLITE_MUTEX_RECURSIVE is used but not necessarily so when SQLITE_MUTEX_FAST
is used. The mutex implementation does not need to make a distinction between
SQLITE_MUTEX_RECURSIVE and SQLITE_MUTEX_FAST if it does not want to.
SQLite will only request a recursive mutex in cases where it really needs one.
If a faster non-recursive mutex implementation is available on the host platform,
the mutex subsystem might return such a mutex in response to SQLITE_MUTEX_FAST.

The other allowed parameters to sqlite3_mutex_alloc()
(anything other than SQLITE_MUTEX_FAST and SQLITE_MUTEX_RECURSIVE) each return
a pointer to a static preexisting mutex. Nine static mutexes are used by the
current version of SQLite. Future versions of SQLite may add additional static
mutexes. Static mutexes are for internal use by SQLite only. Applications that
use SQLite mutexes should use only the dynamic mutexes returned by SQLITE_MUTEX_FAST
or SQLITE_MUTEX_RECURSIVE.

Note that if one of the dynamic mutex parameters (SQLITE_MUTEX_FAST or SQLITE_MUTEX_RECURSIVE)
is used then sqlite3_mutex_alloc() returns a different mutex on every call.
For the static mutex types, the same mutex is returned on every call that has the same type number.

*/
static sqlite3_mutex _static_mutex[12];

static int _xizi_mtx_init(void)
{
    int i;
    int err;

    for (i = 0; i < sizeof(_static_mutex) / sizeof(_static_mutex[0]); i++) {
        err = PrivMutexCreate(&_static_mutex[i].mutex, 0);
        if (err != 0) {
            return SQLITE_ERROR;
        }
    }

    return SQLITE_OK;
}

static int _xizi_mtx_end(void)
{
    int i;
    int err;

    for (i = 0; i < sizeof(_static_mutex) / sizeof(_static_mutex[0]); i++)
    {
        err = PrivMutexDelete(&_static_mutex[i].mutex);

        if (err != 0) {
            return SQLITE_ERROR;
        }
    }

    return SQLITE_OK;
}

static sqlite3_mutex * _xizi_mtx_alloc(int id)
{
    sqlite3_mutex *p = NULL;

    switch (id)
    {
        case SQLITE_MUTEX_FAST:
        case SQLITE_MUTEX_RECURSIVE:
            p = sqlite3_malloc(sizeof(sqlite3_mutex));

            if (p != NULL) {
                PrivMutexCreate(&p->mutex, 0);
                p->id = id;
            }
            break;

        default:
            SQLITE_ASSERT(id - 2 >= 0);
            // SQLITE_ASSERT(id - 2 < ArraySize(_static_mutex));
            p = &_static_mutex[id - 2];
            p->id = id;
            break;
    }

    return p;
}

static void _xizi_mtx_free(sqlite3_mutex * p)
{
    SQLITE_ASSERT(p != 0);

    PrivMutexDelete(&p->mutex);

    switch (p->id) {
        case SQLITE_MUTEX_FAST:
        case SQLITE_MUTEX_RECURSIVE:
            sqlite3_free(p);
            break;

        default:
            break;
    }
}

static void _xizi_mtx_enter(sqlite3_mutex *p)
{
    SQLITE_ASSERT(p != 0);

    PrivMutexObtain(&p->mutex);
}

static int _xizi_mtx_try(sqlite3_mutex *p)
{
    SQLITE_ASSERT(p != 0);

    if (PrivMutexObtain(&p->mutex) != 0) {
        return SQLITE_BUSY;
    }

    return SQLITE_OK;
}

static void _xizi_mtx_leave(sqlite3_mutex *p)
{
    SQLITE_ASSERT(p != 0);

    PrivMutexAbandon(&p->mutex);
}

static sqlite3_mutex_methods const *sqlite3DefaultMutex(void)
{
    static const sqlite3_mutex_methods sMutex = {
        _xizi_mtx_init,
        _xizi_mtx_end,
        _xizi_mtx_alloc,
        _xizi_mtx_free,
        _xizi_mtx_enter,
        _xizi_mtx_try,
        _xizi_mtx_leave,
        0,
        0
    };

    return &sMutex;
}

