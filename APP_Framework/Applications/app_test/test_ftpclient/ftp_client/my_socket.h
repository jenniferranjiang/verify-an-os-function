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
 * @file my_socket.h
 * @brief a abstract socket api
 * @version 1.0
 * @author bdislab_final
 * @date 2023/7/25
 */

#ifndef MYSOCKET_H
#define MYSOCKET_H

#ifdef __cplusplus
extern "C" {
#endif
/* create a socket */
int  SocketCreate(void);

/* connect a socket */
int  SocketConnect(int sock, const char *addr, int port);

/* send data through socket*/
int  SocketSend(int sock, void *data, int len);

/* receive data from socket*/
int  SocketRecv(int sock, void *data, int len);

/* close socket*/
void SocketClose(int sock);

#ifdef __cplusplus
}
#endif

#endif