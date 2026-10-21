/*
 * Copyright (c) 2022 AIIT XUOS Lab
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
 * @file setjmp.h
 * @brief support jerryscript
 * @version 1.0
 * @author AIIT XUOS Lab
 * @date 2023.08.07
 */

#ifndef SETJMP_H
#define SETJMP_H

#include <stdint.h>

typedef uint64_t jmp_buf[14];

int setjmp (jmp_buf env);
void longjmp (jmp_buf env, int val);

#endif /* !SETJMP_H */
