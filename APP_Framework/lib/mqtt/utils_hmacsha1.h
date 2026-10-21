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
* @file:    utils_hmacsha1.h
* @brief:   utils_hmacsha1.h file
* @version: 1.0
* @author:  AIIT XUOS Lab
* @date:    2023/7/27
*
*/

#ifndef UTILS_HMACSHA1_H_
#define UTILS_HMACSHA1_H_

#include "stdio.h"
#include "stdint.h"
#include "stdlib.h"
#include "string.h"

/* SHA-1 context structure */
typedef struct {
    uint32_t total[2];          /* number of bytes processed */
    uint32_t state[5];          /* intermediate digest state */
    unsigned char buffer[64];   /* data block being processed */
} iot_sha1_context;


void utils_hmac_sha1(const char *msg, int msg_len, char *digest, const char *key, int key_len);

#endif

