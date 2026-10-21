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
* @date:    2023/9/16
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include "my_socket.h"
#include "ftp_client.h"
 

static int  m_socket_cmd[THREAD_NUM];
static int  m_socket_data[THREAD_NUM];
static char m_send_buffer[THREAD_NUM][1024];
static char m_recv_buffer[THREAD_NUM][1024];
 
static int FtpSendCommand(int threadID,char *cmd)
{
	int ret;
	printf("send command: %s,threadID=%d\r\n", cmd,threadID);
	ret = SocketSend(m_socket_cmd[threadID], cmd, (int)strlen(cmd));
	if(ret < 0)
	{
		printf("failed to send command: %s\r\n",cmd);
		return 0;
	}
	return 1;
}
 
static int FtpRecvRespond(int threadID,char *resp, int len)
{
	int ret;
	int off;
	len -= 1;
	for(off=0; off<len; off+=ret)
	{
		ret = SocketRecv(m_socket_cmd[threadID], &resp[off], 1);
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
	printf("respond:%s,threadID=%d\r\n", resp,threadID);
	return atoi(resp);
}
 
static int FtpEnterPasv(int threadID,char *ipaddr, int *port)
{
	int ret;
	char *find;
	int a,b,c,d;
	int pa,pb;
	ret = FtpSendCommand(threadID,"PASV\r\n");
	if(ret != 1)
	{
		return 0;
	}
	ret = FtpRecvRespond(threadID,m_recv_buffer[threadID], 1024);
	if(ret != 227)
	{
		return 0;
	}
	find = strrchr(m_recv_buffer[threadID], '(');
	sscanf(find, "(%d,%d,%d,%d,%d,%d)", &a, &b, &c, &d, &pa, &pb);
	sprintf(ipaddr, "%d.%d.%d.%d", a, b, c, d);
	*port = pa * 256 + pb;
	return 1;
}

int  FtpUpload(int threadID,char *name, void *buf, int len)
{
	int  ret;
	char ipaddr[32];
	int  port;
	
	//查询数据地址
	ret=FtpEnterPasv(threadID,ipaddr, &port);
	if(ret != 1)
	{
		return 0;
	}
	ret=SocketConnect(m_socket_data[threadID], ipaddr, port);
	if(ret != 1)
	{
		return 0;
	}
	//准备上传
	sprintf(m_send_buffer[threadID], "STOR %s\r\n", name);
	ret = FtpSendCommand(threadID,m_send_buffer[threadID]);
	if(ret != 1)
	{
		return 0;
	}
	ret = FtpRecvRespond(threadID,m_recv_buffer[threadID], 1024);
	if(ret != 150)
	{
		SocketClose(m_socket_data[threadID]);
		return 0;
	}
	
	//开始上传
	ret = SocketSend(m_socket_data[threadID], buf, len);
	if(ret != len)
	{	
		printf("send data error!\r\n");
		SocketClose(m_socket_data[threadID]);
		return 0;
	}
	SocketClose(m_socket_data[threadID]);
 
	//上传完成，等待回应
	ret = FtpRecvRespond(threadID,m_recv_buffer[threadID], 1024);
	return (ret==226);
}

int  FtpDownload(int threadID,char *name, void *buf, int len)
{
	int   i;
	int   ret;
	char  ipaddr[32];
	int   port;
    
	//查询数据地址
	ret = FtpEnterPasv(threadID,ipaddr, &port);
	if(ret != 1)
	{
		return 0;
	}
	printf("m_socket_data[threadID]=%d,threadID=%d\n",m_socket_data[threadID],threadID);
	//连接数据端口
	ret = SocketConnect(m_socket_data[threadID], ipaddr, port);
	if(ret != 1)
	{
		printf("failed to connect data port\r\n");
		return 0;
	}
 
	//准备下载
	sprintf(m_send_buffer[threadID], "RETR %s\r\n", name);
	ret = FtpSendCommand(threadID,m_send_buffer[threadID]);
	if(ret != 1)
	{
		return 0;
	}
	ret = FtpRecvRespond(threadID,m_recv_buffer[threadID], 1024);
	if(ret != 150)
	{
		SocketClose(m_socket_data[threadID]);
		return 0;
	}
	
	//开始下载,读取完数据后，服务器会自动关闭连接
	for(i=0; i<len; i+=ret)
	{
		ret = SocketRecv(m_socket_data[threadID], ((char *)buf) + i, len);
		printf("download %d/%d.,threadID=%d\r\n", i + ret, len,threadID);
		if(ret < 0)
		{
			printf("download was interrupted.\r\n");
			break;
		}
	}
	//下载完成
	printf("download %d/%d bytes complete.,threadID=%d\r\n", i, len,threadID);
    // FILE *fp = NULL;

    // fp = fopen(name+1, "wb");
    // fwrite(buf,len,1,fp);
    // fclose(fp);

	SocketClose(m_socket_data[threadID]);
	ret = FtpRecvRespond(threadID,m_recv_buffer[threadID], 1024);
	return (ret==226);
}
 
int  FtpFileSize(int threadID,char *name)
{
	int ret;
	int size;
	sprintf(m_send_buffer[threadID],"SIZE %s\r\n",name);
	ret = FtpSendCommand(threadID,m_send_buffer[threadID]);
	if(ret != 1)
	{
		return 0;
	}
	ret = FtpRecvRespond(threadID,m_recv_buffer[threadID], 1024);
	if(ret != 213)
	{
		return 0;
	}
	size = atoi(m_recv_buffer[threadID] + 4);
	return size;
}
 
int FtpLogin(int threadID,char *addr, int port, char *username, char *password)
{
	int ret;
	printf("connect...,threadID=%d\r\n",threadID);
	ret = SocketConnect(m_socket_cmd[threadID], addr, port);
	if(ret != 1)
	{
		printf("connect server failed!\r\n");
		return 0;
	}
	printf("connect ok.,threadID=%d\r\n",threadID);
    //等待欢迎信息
	ret = FtpRecvRespond(threadID,m_recv_buffer[threadID], 1024);
	if(ret != 220)
	{
		printf("bad server, ret=%d!\r\n", ret);
		SocketClose(m_socket_cmd[threadID]);
		return 0;
	}
	
	printf("login...threadID=%d\r\n",threadID);
    //发送USER
	sprintf(m_send_buffer[threadID], "USER %s\r\n", username);
	ret = FtpSendCommand(threadID,m_send_buffer[threadID]);
	if(ret != 1)
	{
		SocketClose(m_socket_cmd[threadID]);
		return 0;
	}
	ret = FtpRecvRespond(threadID,m_recv_buffer[threadID], 1024);
	if(ret != 331)
	{
		SocketClose(m_socket_cmd[threadID]);
		return 0;
	}
	
    //发送PASS
	sprintf(m_send_buffer[threadID], "PASS %s\r\n", password);
	ret = FtpSendCommand(threadID,m_send_buffer[threadID]);
	if(ret != 1)
	{
		SocketClose(m_socket_cmd[threadID]);
		return 0;
	}
	ret = FtpRecvRespond(threadID,m_recv_buffer[threadID], 1024);
	if(ret != 230)
	{
		SocketClose(m_socket_cmd[threadID]);
		return 0;
	}
	printf("login success.threadID=%d\r\n",threadID);
	
    //设置为二进制模式
	ret = FtpSendCommand(threadID,"TYPE I\r\n");
	if(ret != 1)
	{
		SocketClose(m_socket_cmd[threadID]);
		return 0;
	}
	ret = FtpRecvRespond(threadID,m_recv_buffer[threadID], 1024);
	if(ret != 200)
	{
		SocketClose(m_socket_cmd[threadID]);
		return 0;
	}
	return 1;
}
 
void FtpQuit(int threadID)
{
	FtpSendCommand(threadID,"QUIT\r\n");
	SocketClose(m_socket_cmd[threadID]);
}
 
void FtpInitCmd(int threadID)
{
	m_socket_cmd[threadID] = SocketCreate();
}

void FtpInitData(int threadID){
    m_socket_data[threadID]= SocketCreate();
}