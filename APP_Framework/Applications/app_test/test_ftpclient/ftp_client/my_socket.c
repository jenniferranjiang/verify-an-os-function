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
* @file:    my_socket.c
* @brief:   a abstract socket api
* @version: 1.0
* @author:  bdislab_final
* @date:    2023/7/25
* @reference https://kerndev.blog.csdn.net/article/details/89383888
*/

#include "my_socket.h"
#include <sockets.h>
#include <def.h>
#include <errno.h>

int  SocketCreate(void){
    return socket(AF_INET,SOCK_STREAM,0);
}

int  SocketConnect(int sock, const char *addr, int port){
	// unsigned int iRemoteAddr = 0;
	struct sockaddr_in stRemoteAddr = {0}; //对端，即目标地址信息
	
	stRemoteAddr.sin_family = AF_INET;
	stRemoteAddr.sin_port = htons(port);
	stRemoteAddr.sin_addr.s_addr = inet_addr(addr);
	// inet_pton(AF_INET, addr, &iRemoteAddr);
	// stRemoteAddr.sin_addr.s_addr=iRemoteAddr;
	int res = connect(sock,(struct sockaddr *)&stRemoteAddr,sizeof(stRemoteAddr));
	if(res == -1){
		printf("error:%d\n",errno);
	}
    return res == 0 ? 1 : 0;
}

int  SocketSend(int sock, void *data, int len){
    return send(sock,data,len,0);
}

int  SocketRecv(int sock, void *data, int len){
    return recv(sock,data,len,0);
}

void SocketClose(int sock){
	close(sock);
}
