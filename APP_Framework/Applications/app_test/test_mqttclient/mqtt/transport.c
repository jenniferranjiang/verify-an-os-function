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
 * @file transport.c
 * @brief mqtt transport function
 * @version 3.0
 * @author AIIT XUOS Lab
 * @date 2023.8.10
 */

#include "transport.h"
#include "lwip/opt.h"
#include "lwip/arch.h"
#include "lwip/api.h"
#include "lwip/inet.h"
#include "lwip/sockets.h"
#include "string.h"

static int mysock;


int32_t transport_sendPacketBuffer( uint8_t* buf, int32_t buflen)
{
	int32_t rc;
	rc = write(mysock, buf, buflen);
	return rc;
}


int transport_getdata(unsigned char* buf, int count)
{
	int32_t rc;
	
  rc = recv(mysock, buf, count, 0);
  lw_print("get data : %lx\n",rc);
	return rc;
}


int32_t transport_close(void)
{
  
	int rc;
//	rc = close(mysock);
  rc = shutdown(mysock, SHUT_WR);
	rc = recv(mysock, NULL, (size_t)0, 0);
	rc = close(mysock);
	return rc;
}
