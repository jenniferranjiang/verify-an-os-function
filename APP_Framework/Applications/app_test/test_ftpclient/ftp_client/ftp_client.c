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
* @file:    ftp_client.c
* @brief:   ftp client tool
* @version: 1.0
* @author:  bdislab_final
* @date:    2023/7/25
* @reference https://kerndev.blog.csdn.net/article/details/89383888
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include "my_socket.h"
#include "ftp_client.h"
 
static int  m_socket_cmd;
static int  m_socket_data;
static char m_send_buffer[1024];
static char m_recv_buffer[1024];
 
static int FtpSendCommand(char *cmd)
{
	int ret;
	printf("send command: %s\r\n", cmd);
	ret = SocketSend(m_socket_cmd, cmd, (int)strlen(cmd));
	if(ret < 0)
	{
		printf("failed to send command: %s\r\n",cmd);
		return 0;
	}
	return 1;
}
 
static int FtpRecvRespond(char *resp, int len)
{
	int ret;
	int off;
	len -= 1;
	for(off=0; off<len; off+=ret)
	{
		ret = SocketRecv(m_socket_cmd, &resp[off], 1);
		if(ret < 0)
		{
			printf("recv respond error(ret=%d)!\r\n", ret);
			return 0;
		}
		if(resp[off] == '\n')
		{
			break;
		}
	}
	resp[off+1] = 0;
	printf("respond:%s\r\n", resp);
	return atoi(resp);
}
 
static int FtpEnterPasv(char *ipaddr, int *port)
{
	int ret;
	char *find;
	int a,b,c,d;
	int pa,pb;
	ret = FtpSendCommand("PASV\r\n");
	if(ret != 1)
	{
		return 0;
	}
	ret = FtpRecvRespond(m_recv_buffer, 1024);
	if(ret != 227)
	{
		return 0;
	}
	find = strrchr(m_recv_buffer, '(');
	sscanf(find, "(%d,%d,%d,%d,%d,%d)", &a, &b, &c, &d, &pa, &pb);
	sprintf(ipaddr, "%d.%d.%d.%d", a, b, c, d);
	*port = pa * 256 + pb;
	return 1;
}
 
int  FtpDownload(char *name, char *buf, int len)
{
	int   i;
	int   ret;
	char  ipaddr[32];
	int   port;
    
	//查询数据地址
	ret = FtpEnterPasv(ipaddr, &port);
	if(ret != 1)
	{
		return 0;
	}
	//连接数据端口
	ret = SocketConnect(m_socket_data, ipaddr, port);
	if(ret != 1)
	{
		printf("failed to connect data port\r\n");
		return 0;
	}
 
	//准备下载
	sprintf(m_send_buffer, "RETR %s\r\n", name);
	ret = FtpSendCommand(m_send_buffer);
	if(ret != 1)
	{
		return 0;
	}
	ret = FtpRecvRespond(m_recv_buffer, 1024);
	if(ret != 150)
	{
		SocketClose(m_socket_data);
		return 0;
	}
	
	//开始下载,读取完数据后，服务器会自动关闭连接
	for(i=0; i<len; i+=ret)
	{
		ret = SocketRecv(m_socket_data, ((char *)buf) + i, len);
		printf("download %d/%d.\r\n", i + ret, len);
		if(ret < 0)
		{
			printf("download was interrupted.\r\n");
			break;
		}
	}
	//下载完成
	printf("download %d/%d bytes complete.\r\n", i, len);
	printf("====file content====\n");
	buf[100] = '\0';
	printf("%s\n",buf);
	printf("====================\n");
    // FILE *fp = NULL;

    // fp = fopen(name+1, "wb");
    // fwrite(buf,len,1,fp);
    // fclose(fp);

	SocketClose(m_socket_data);
	ret = FtpRecvRespond(m_recv_buffer, 1024);
	return (ret==226);
}
 
int  FtpFileSize(char *name)
{
	int ret;
	int size;
	sprintf(m_send_buffer,"SIZE %s\r\n",name);
	ret = FtpSendCommand(m_send_buffer);
	if(ret != 1)
	{
		return 0;
	}
	ret = FtpRecvRespond(m_recv_buffer, 1024);
	if(ret != 213)
	{
		return 0;
	}
	size = atoi(m_recv_buffer + 4);
	return size;
}
 
int FtpLogin(char *addr, int port, char *username, char *password)
{
	int ret;
	printf("connect...\r\n");
	ret = SocketConnect(m_socket_cmd, addr, port);
	if(ret != 1)
	{
		printf("connect server failed!\r\n");
		return 0;
	}
	printf("connect ok.\r\n");
    //等待欢迎信息
	ret = FtpRecvRespond(m_recv_buffer, 1024);
	if(ret != 220)
	{
		printf("bad server, ret=%d!\r\n", ret);
		SocketClose(m_socket_cmd);
		return 0;
	}
	
	printf("login...\r\n");
    //发送USER
	sprintf(m_send_buffer, "USER %s\r\n", username);
	ret = FtpSendCommand(m_send_buffer);
	if(ret != 1)
	{
		SocketClose(m_socket_cmd);
		return 0;
	}
	ret = FtpRecvRespond(m_recv_buffer, 1024);
	if(ret != 331)
	{
		SocketClose(m_socket_cmd);
		return 0;
	}
	
    //发送PASS
	sprintf(m_send_buffer, "PASS %s\r\n", password);
	ret = FtpSendCommand(m_send_buffer);
	if(ret != 1)
	{
		SocketClose(m_socket_cmd);
		return 0;
	}
	ret = FtpRecvRespond(m_recv_buffer, 1024);
	if(ret != 230)
	{
		SocketClose(m_socket_cmd);
		return 0;
	}
	printf("login success.\r\n");
	
    //设置为二进制模式
	ret = FtpSendCommand("TYPE I\r\n");
	if(ret != 1)
	{
		SocketClose(m_socket_cmd);
		return 0;
	}
	ret = FtpRecvRespond(m_recv_buffer, 1024);
	if(ret != 200)
	{
		SocketClose(m_socket_cmd);
		return 0;
	}
	return 1;
}
 
void FtpQuit(void)
{
	FtpSendCommand("QUIT\r\n");
	SocketClose(m_socket_cmd);
}
 
void FtpInitCmd(void)
{
	m_socket_cmd = SocketCreate();
}

void FtpInitData(void){
    m_socket_data= SocketCreate();
}