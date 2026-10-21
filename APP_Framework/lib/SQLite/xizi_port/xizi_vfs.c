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
* @file xizi_vfs.c
* @brief support SQLite vfs function in XiZi kernel
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-10-16
*/

/*************************************************
File name: xizi_vfs.c
Description: support SQLite vfs function in XiZi kernel
Others: 
History: 
1. Date: 2023-10-16
Author: AIIT XUOS Lab
Modification: 
1、add xizi vfs function.
*************************************************/

#include "xizi_port.h"

#ifndef SQLITE_OMIT_LOAD_EXTENSION
    #error "not support load extension, compile with SQLITE_OMIT_LOAD_EXTENSION."
#endif

#define MAX_PATHNAME       256

/*
** Define various macros that are missing from some systems.
*/
#ifndef O_LARGEFILE
# define O_LARGEFILE 0
#endif
#ifdef SQLITE_DISABLE_LFS
# undef O_LARGEFILE
# define O_LARGEFILE 0
#endif
#ifndef O_NOFOLLOW
# define O_NOFOLLOW 0
#endif
#ifndef O_BINARY
# define O_BINARY 0
#endif

#ifndef RT_USING_NEWLIB

#ifndef EINTR
#define EINTR        4  /* Interrupted system call */
#endif

#ifndef ENOLCK
#define ENOLCK      46  /* No record locks available */
#endif

#ifndef EACCES
#define EACCES      13  /* Permission denied */
#endif

#ifndef EPERM
#define EPERM        1  /* Operation not permitted */
#endif

#ifndef ETIMEDOUT
#define ETIMEDOUT   145 /* Connection timed out */
#endif

#ifndef ENOTCONN
#define ENOTCONN    134 /* Transport endpoint is not connected */
#endif

#if defined(__GNUC__) || defined(__ADSPBLACKFIN__)
int _gettimeofday(struct timeval *tp, void *ignore) __attribute__((weak));
int _gettimeofday(struct timeval *tp, void *ignore)
#elif defined(__CC_ARM)
__weak int _gettimeofday(struct timeval *tp, void *ignore)
#elif defined(__IAR_SYSTEMS_ICC__)
    #if __VER__ > 540
    __weak
    #endif
int _gettimeofday(struct timeval *tp, void *ignore)
#else
int _gettimeofday(struct timeval *tp, void *ignore)
#endif
{
    return 0;
}

#endif

static int _Access(const char *pathname, int mode)
{
    int fd = -1;

    fd = PrivOpen(pathname, O_RDONLY);

    if (fd >= 0) {
        PrivClose(fd);
        return 0;
    }

    return -1;
}

#define _XIZI_LOG_ERROR(a,b,c) _xizi_log_error_at_line(a,b,c,__LINE__)

static int _xizi_log_error_at_line(
  int errcode,                    /* SQLite error code */
  const char *zFunc,              /* Name of OS function that failed */
  const char *zPath,              /* File path associated with error */
  int iLine                       /* Source line number where error occurred */
)
{
    char *zErr;                     /* Message from strerror() or equivalent */
    int iErrno = errno;             /* Saved syscall error number */

    /* If this is not a threadsafe build (SQLITE_THREADSAFE==0), then use
    ** the strerror() function to obtain the human-readable error message
    ** equivalent to errno. Otherwise, use strerror_r().
    */
#if SQLITE_THREADSAFE && defined(HAVE_STRERROR_R)
    char aErr[80];
    memset(aErr, 0, sizeof(aErr));
    zErr = aErr;

    /* If STRERROR_R_CHAR_P (set by autoconf scripts) or __USE_GNU is defined,
    ** assume that the system provides the GNU version of strerror_r() that
    ** returns a pointer to a buffer containing the error message. That pointer
    ** may point to aErr[], or it may point to some static storage somewhere.
    ** Otherwise, assume that the system provides the POSIX version of
    ** strerror_r(), which always writes an error message into aErr[].
    **
    ** If the code incorrectly assumes that it is the POSIX version that is
    ** available, the error message will often be an empty string. Not a
    ** huge problem. Incorrectly concluding that the GNU version is available
    ** could lead to a segfault though.
    */
#if defined(STRERROR_R_CHAR_P) || defined(__USE_GNU)
    zErr =
#endif
    strerror_r(iErrno, aErr, sizeof(aErr)-1);

#elif SQLITE_THREADSAFE
    /* This is a threadsafe build, but strerror_r() is not available. */
    zErr = "";
#else
    /* Non-threadsafe build, use strerror(). */
    zErr = strerror(iErrno);
#endif

    if( zPath==0 )
        zPath = "";

    sqlite3_log(errcode, "os_xizi.c:%d: (%d) %s(%s) - %s",
                iLine, iErrno, zFunc, zPath, zErr);

    return errcode;
}

static const char* _xizi_temp_file_dir(void)
{
    const char *azDirs[] = {
        0,
        "/sql",
        "/sql/tmp"
        "/tmp",
        0        /* List terminator */
    };
    unsigned int i;
    struct stat buf;
    const char *zDir = 0;

    azDirs[0] = sqlite3_temp_directory;

    for (i = 0; i < sizeof(azDirs) / sizeof(azDirs[0]); zDir = azDirs[i++])
    {
        if( zDir == 0 ) continue;
        if( PrivStat(zDir, &buf) ) continue;
        if( !S_ISDIR(buf.st_mode) ) continue;
        break;
    }

    return zDir;
}

/*
** Create a temporary file name in zBuf.  zBuf must be allocated
** by the calling process and must be big enough to hold at least
** pVfs->mxPathname bytes.
*/
int _xizi_get_temp_name(int nBuf, char *zBuf)
{
    const unsigned char zChars[] = "abcdefghijklmnopqrstuvwxyz"
                                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                    "0123456789";
    unsigned int i, j;
    const char *zDir;

    zDir = _xizi_temp_file_dir();

    if (zDir == 0)
    {
        zDir = ".";
    }

    /* Check that the output buffer is large enough for the temporary file
    ** name. If it is not, return SQLITE_ERROR.
    */
    if ((strlen(zDir) + strlen("etilqs_") + 18) >= (size_t)nBuf)
    {
        return SQLITE_ERROR;
    }

    do {
        sqlite3_snprintf(nBuf-18, zBuf, "%s/""etilqs_", zDir);
        j = (int)strlen(zBuf);
        sqlite3_randomness(15, &zBuf[j]);

        for (i = 0; i < 15; i++, j++)
        {
            zBuf[j] = (char)zChars[((unsigned char)zBuf[j]) % (sizeof(zChars) - 1)];
        }

        zBuf[j] = 0;
        zBuf[j + 1] = 0;
    } while (_Access(zBuf, 0) == 0);

    return SQLITE_OK;
}

#include "xizi_io_methods.c"

/*
** Invoke open().  Do so multiple times, until it either succeeds or
** fails for some reason other than EINTR.
**
** If the file creation mode "m" is 0 then set it to the default for
** SQLite.  The default is SQLITE_DEFAULT_FILE_PERMISSIONS (normally
** 0644) as modified by the system umask.  If m is not 0, then
** make the file creation mode be exactly m ignoring the umask.
**
** The m parameter will be non-zero only when creating -wal, -journal,
** and -shm files.  We want those files to have *exactly* the same
** permissions as their original database, unadulterated by the umask.
** In that way, if a database file is -rw-rw-rw or -rw-rw-r-, and a
** transaction crashes and leaves behind hot journals, then any
** process that is able to write to the database will also be able to
** recover the hot journals.
*/
static int _xizi_fs_open(const char *file_path, int f, mode_t m)
{
    int fd = -1;

    while (fd < 0)
    {
        fd = PrivOpen(file_path, f);

        if (fd < 0)
        {
            if (errno == EINTR)
                continue;

            break;
        }
    }

    return fd;
}

static int _xizi_vfs_open(sqlite3_vfs *pvfs, const char *file_path, sqlite3_file *file_id, int flags, int *pOutFlags)
{
    XIZI_SQLITE_FILE_T *p;
    int fd;
    int eType = flags & 0xFFFFFF00;  /* Type of file to open */
    int rc = SQLITE_OK;            /* Function Return Code */
    int openFlags = 0;
    mode_t openMode = 0;

    int isExclusive  = (flags & SQLITE_OPEN_EXCLUSIVE);
    int isDelete     = (flags & SQLITE_OPEN_DELETEONCLOSE);
    int isCreate     = (flags & SQLITE_OPEN_CREATE);
    int isReadonly   = (flags & SQLITE_OPEN_READONLY);
    int isReadWrite  = (flags & SQLITE_OPEN_READWRITE);

    /* If argument zPath is a NULL pointer, this function is required to open
    ** a temporary file. Use this buffer to store the file name in.
    */
    char zTmpname[MAX_PATHNAME + 2];

    p = (XIZI_SQLITE_FILE_T*)file_id;

    /* Check the following statements are true:
    **
    **   (a) Exactly one of the READWRITE and READONLY flags must be set, and
    **   (b) if CREATE is set, then READWRITE must also be set, and
    **   (c) if EXCLUSIVE is set, then CREATE must also be set.
    **   (d) if DELETEONCLOSE is set, then CREATE must also be set.
    */
    SQLITE_ASSERT((isReadonly==0 || isReadWrite==0) && (isReadWrite || isReadonly));
    SQLITE_ASSERT(isCreate==0 || isReadWrite);
    SQLITE_ASSERT(isExclusive==0 || isCreate);
    SQLITE_ASSERT(isDelete==0 || isCreate);

    /* The main DB, main journal, WAL file and master journal are never
    ** automatically deleted. Nor are they ever temporary files.  */
    SQLITE_ASSERT( (!isDelete && file_path) || eType!=SQLITE_OPEN_MAIN_DB );
    SQLITE_ASSERT( (!isDelete && file_path) || eType!=SQLITE_OPEN_MAIN_JOURNAL );
    SQLITE_ASSERT( (!isDelete && file_path) || eType!=SQLITE_OPEN_MASTER_JOURNAL );
    SQLITE_ASSERT( (!isDelete && file_path) || eType!=SQLITE_OPEN_WAL );

    /* Assert that the upper layer has set one of the "file-type" flags. */
    SQLITE_ASSERT( eType==SQLITE_OPEN_MAIN_DB      || eType==SQLITE_OPEN_TEMP_DB
        || eType==SQLITE_OPEN_MAIN_JOURNAL || eType==SQLITE_OPEN_TEMP_JOURNAL
        || eType==SQLITE_OPEN_SUBJOURNAL   || eType==SQLITE_OPEN_MASTER_JOURNAL
        || eType==SQLITE_OPEN_TRANSIENT_DB || eType==SQLITE_OPEN_WAL
    );

    /* Database filenames are double-zero terminated if they are not
    ** URIs with parameters.  Hence, they can always be passed into
    ** sqlite3_uri_parameter(). */
    SQLITE_ASSERT((eType != SQLITE_OPEN_MAIN_DB) || (flags & SQLITE_OPEN_URI) || file_path[strlen(file_path) + 1] == 0);

    memset(p, 0, sizeof(XIZI_SQLITE_FILE_T));
    if (!file_path)
    {
        rc = _xizi_get_temp_name(MAX_PATHNAME + 2, zTmpname);
        if (rc != SQLITE_OK )
        {
            return rc;
        }
        file_path = zTmpname;

        /* Generated temporary filenames are always double-zero terminated
        ** for use by sqlite3_uri_parameter(). */
        SQLITE_ASSERT(file_path[strlen(file_path) + 1] == 0);
    }

    /* Determine the value of the flags parameter passed to POSIX function
    ** open(). These must be calculated even if open() is not called, as
    ** they may be stored as part of the file handle and used by the
    ** 'conch file' locking functions later on.  */
    if (isReadonly)  openFlags |= O_RDONLY;
    if (isReadWrite) openFlags |= O_RDWR;
    if (isCreate)    openFlags |= O_CREAT;
    if (isExclusive) openFlags |= (O_EXCL | O_NOFOLLOW);
    openFlags |= (O_LARGEFILE | O_BINARY);

    fd = _xizi_fs_open(file_path, openFlags, openMode);

    if (fd < 0 && (errno != -EISDIR) && isReadWrite && !isExclusive)
    {
        /* Failed to open the file for read/write access. Try read-only. */
        flags &= ~(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE);
        openFlags &= ~(O_RDWR | O_CREAT);
        flags |= SQLITE_OPEN_READONLY;
        openFlags |= O_RDONLY;
        isReadonly = 1;
        fd = _xizi_fs_open(file_path, openFlags, openMode);
    }

    if (fd < 0)
    {
        // rc = _XIZI_LOG_ERROR(SQLITE_CANTOPEN_BKPT, "open", file_path);
        printf("%s line %d open %s fd failed\n", __func__, __LINE__, file_path);
        return rc;
    }

    if (pOutFlags)
    {
        *pOutFlags = flags;
    }

    if (isDelete)
    {
        PrivUnlink(file_path);
    }

    p->fd = fd;
    p->pMethod = &_xizi_io_method;
    p->eFileLock = 0;
    p->szChunk = 0;
    p->pvfs = pvfs;
    PrivSemaphoreCreate(&p->sem, 0, 1);

    return rc;
}

int _xizi_vfs_delete(sqlite3_vfs* pvfs, const char *file_path, int syncDir)
{
    int rc = SQLITE_OK;

    if (PrivUnlink(file_path) == (-1))
    {
        if (errno == -ENOENT)
        {
            rc = SQLITE_IOERR_DELETE_NOENT;
        }
        else
        {
            rc = _XIZI_LOG_ERROR(SQLITE_IOERR_DELETE, "unlink", file_path);
        }

        return rc;
    }

    // sync dir: open dir -> fsync -> close
    if ((syncDir & 1) != 0)
    {
        int ii;
        int fd = -1;
        char zDirname[MAX_PATHNAME + 1];

        sqlite3_snprintf(MAX_PATHNAME, zDirname, "%s", file_path);
        for (ii=(int)strlen(zDirname); ii > 1 && zDirname[ii] != '/'; ii--);

        if (ii > 0)
        {
            zDirname[ii] = '\0';
            fd = _xizi_fs_open(zDirname, O_RDONLY | O_BINARY, 0);
        }

        if (fd >= 0)
        {
            if (PrivFsync(fd))
            {
                rc = _XIZI_LOG_ERROR(SQLITE_IOERR_DIR_FSYNC, "fsync", file_path);
            }

            PrivClose(fd);
        }

        rc = SQLITE_OK;
    }

    return rc;
}

static int _xizi_vfs_access(sqlite3_vfs* pvfs, const char *file_path, int flags, int *pResOut)
{
    int amode = 0;

#ifndef F_OK
# define F_OK 0
#endif
#ifndef R_OK
# define R_OK 4
#endif
#ifndef W_OK
# define W_OK 2
#endif

    switch (flags)
    {
    case SQLITE_ACCESS_EXISTS:
        amode = F_OK;
        break;

    case SQLITE_ACCESS_READWRITE:
        amode = W_OK | R_OK;
        break;

    case SQLITE_ACCESS_READ:
        amode = R_OK;
        break;

    default:
        _XIZI_LOG_ERROR(flags, "access", file_path);
        return -1;
    }

    *pResOut = (_Access(file_path, amode) == 0);

    if (flags == SQLITE_ACCESS_EXISTS && *pResOut)
    {
        struct stat buf;

        if (0 == PrivStat(file_path, &buf) && (buf.st_size == 0))
        {
            *pResOut = 0;
        }
    }

    return SQLITE_OK;
}

static int _xizi_vfs_fullpathname(sqlite3_vfs* pvfs, const char *file_path, int nOut, char *zOut)
{
    SQLITE_ASSERT(pvfs->mxPathname == MAX_PATHNAME);

    zOut[nOut - 1] = '\0';

    if (file_path[0] == '/')
    {
        sqlite3_snprintf(nOut, zOut, "%s", file_path);
    }
    else
    {
        int nCwd;

        if (PrivGetcwd(zOut, nOut - 1) == 0)
        {
            printf("%s line %d get ced %s failed\n", __func__, __LINE__, file_path);
            return -1;
        }

        nCwd = (int)strlen(zOut);
        sqlite3_snprintf(nOut - nCwd, &zOut[nCwd], "/%s", file_path);
    }

    return SQLITE_OK;
}

static int _xizi_vfs_randomness(sqlite3_vfs* pvfs, int nByte, char *zOut)
{
    SQLITE_ASSERT((size_t)nByte >= (sizeof(time_t) + sizeof(int)));

    memset(zOut, 0, nByte);
    {
        int i;
        char tick8, tick16;

        tick8 = (char)PrivGetTickTime();
        tick16 = (char)(PrivGetTickTime() >> 8);

        for (i = 0; i < nByte; i++)
        {
            zOut[i] = (char)(i ^ tick8 ^ tick16);
            tick8 = zOut[i];
            tick16 = ~(tick8 ^ tick16);
        }
    }

    return nByte;
}

static int _xizi_vfs_sleep(sqlite3_vfs* pvfs, int microseconds)
{
    int millisecond = (microseconds + 999) / 1000;

    PrivTaskDelay(millisecond);

    return millisecond * 1000;
}

static int _xizi_vfs_current_time_int64(sqlite3_vfs*, sqlite3_int64*);
static int _xizi_vfs_current_time(sqlite3_vfs* pvfs, double* pnow)
{
    sqlite3_int64 i = 0;
    int rc;

    rc = _xizi_vfs_current_time_int64(0, &i);

    *pnow = i / 86400000.0;

    return rc;
}

static int _xizi_vfs_get_last_error(sqlite3_vfs* pvfs, int nBuf, char *zBuf)
{
    return 0;
}

static int _xizi_vfs_current_time_int64(sqlite3_vfs* pvfs, sqlite3_int64*pnow)
{
#ifndef NO_GETTOD
#define NO_GETTOD 1
#endif

    static const sqlite3_int64 rtthreadEpoch = 24405875 * (sqlite3_int64)8640000;
    int rc = SQLITE_OK;

#if defined(NO_GETTOD)
    time_t t;
    time(&t);
    *pnow = ((sqlite3_int64)t) * 1000 + rtthreadEpoch;
#else

    struct timeval sNow;

    if (gettimeofday(&sNow, 0) == 0)
    {
        *pnow = rtthreadEpoch + 1000 * (sqlite3_int64)sNow.tv_sec + sNow.tv_usec / 1000;
    }
    else
    {
        rc = SQLITE_ERROR;
    }

#endif

#ifdef SQLITE_TEST

    if( sqlite3_current_time )
    {
        *pnow = 1000 * (sqlite3_int64)sqlite3_current_time + rtthreadEpoch;
    }

#endif

    return rc;
}

static int _xizi_vfs_set_system_call(sqlite3_vfs* pvfs, const char *file_path, sqlite3_syscall_ptr pfn)
{
    return SQLITE_NOTFOUND;
}

static sqlite3_syscall_ptr _xizi_vfs_get_system_call(sqlite3_vfs* pvfs, const char *file_path)
{
    return 0;
}

static const char*  _xizi_vfs_next_system_call(sqlite3_vfs *pvfs, const char *file_path)
{
    return 0;
}

/*
** Initialize and deinitialize the operating system interface.
*/
SQLITE_API int sqlite3_os_init(void)
{
    static sqlite3_vfs _xizi_vfs = {
        3,                     /* iVersion */
        sizeof(XIZI_SQLITE_FILE_T),       /* szOsFile */
        MAX_PATHNAME, /* mxPathname */
        0,                     /* pNext */
        "xiuos",               /* zName */
        0,           /* pAppData */
        _xizi_vfs_open,               /* xOpen */
        _xizi_vfs_delete,             /* xDelete */
        _xizi_vfs_access,             /* xAccess */
        _xizi_vfs_fullpathname,       /* xFullPathname */
        0,             /* xDlOpen */
        0,            /* xDlError */
        0,              /* xDlSym */
        0,            /* xDlClose */
        _xizi_vfs_randomness,         /* xRandomness */
        _xizi_vfs_sleep,              /* xSleep */
        _xizi_vfs_current_time,        /* xCurrentTime */
        _xizi_vfs_get_last_error,       /* xGetLastError */
        _xizi_vfs_current_time_int64,   /* xCurrentTimeInt64 */
        _xizi_vfs_set_system_call,      /* xSetSystemCall */
        _xizi_vfs_get_system_call,      /* xGetSystemCall */
        _xizi_vfs_next_system_call,     /* xNextSystemCall */
    };

    sqlite3_vfs_register(&_xizi_vfs, 1);

    return SQLITE_OK;
}

SQLITE_API int sqlite3_os_end(void)
{
    return SQLITE_OK;
}

