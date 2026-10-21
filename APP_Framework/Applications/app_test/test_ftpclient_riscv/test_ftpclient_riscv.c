/*
* Copyright (c) 2020 AIIT Ubiquitous Team
* XiUOS is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL
v2.
* You may obtain a copy of Mulan PSL v2 at:
*
http://license.coscl.org.cn/MulanPSL2
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
* See the Mulan PSL v2 for more details.
*/

#include <transform.h>
#include <socket.h>
#include <stdio.h>
#include <stdlib.h>
#include "test_ftpclient_riscv.h"
#define SOCKET_DATA 2
#define SOCKET_CMD 3
char sendBuffer[1024];
char recvBuffer[1024];

//quoted from https://kerndev.blog.csdn.net/article/details/89383888
int SendCommand(char *cmd)
{
    int ret;
    ret = wiz_sock_send(SOCKET_CMD,cmd,(int)strlen(cmd));
    if(ret < 0 ){
        return 0;
    }
    return 1;
}
int RecvRespond(char * respond,int len)
{
    int ret;
    int off;
    len -= -1;
    for(off = 0;off < len;off += ret){
        ret = wiz_sock_recv(SOCKET_CMD,&respond[off],1);
        if(ret < 0 ){
            printf("recv respond error\r\n");
            return 0;
        }
        if(respond[off] == '\n'){
            break;
        }
    } 
    respond[off + 1]=0;
    return atoi(respond);
}
int EnterPasv(uint8_t *ipaddr,int *port)
{
    int ret;
    char *find;
    int ip1,ip2,ip3,ip4,tmp1,tmp2;
    ret = SendCommand("PASV\r\n");
    if(ret != 1){
        return 0;
    }
    ret=RecvRespond(recvBuffer,1024);
    if(ret != 227){
        return 0;
    }
    find=strrchr(recvBuffer,'(');
    sscanf(find,"(%d,%d,%d,%d,%d,%d)",&ip1,&ip2,&ip3,&ip4,&tmp1,&tmp2);
    ipaddr[0] = ip1;
    ipaddr[1] = ip2;
    ipaddr[2] = ip3;
    ipaddr[3] = ip4;
    *port = tmp1 * 256 + tmp2;
    return 1;
}
int Login(uint8_t addr[4],int port,char *username,char *password)
{
    int ret;
    printf("connect....\n");
    ret = wiz_sock_connect(SOCKET_CMD,addr,port);
    if(ret != 1){
        printf("connect server failed\r\n");
        return 0;
    }
    printf("connect ok.\r\n");

    ret = RecvRespond(recvBuffer,1024);
    if(ret != 220){
        printf("bad server ret=%d\r\n",ret);
        return 0;
    }
    printf("login....\r\n");
    sprintf(sendBuffer,"USER %s\r\n",username);
    ret = SendCommand(sendBuffer);

    if(ret != 1){
        return 0;
    }
    ret = RecvRespond(recvBuffer,1024);
    if(ret == 220)ret = RecvRespond(recvBuffer,1024);
    if(ret != 331){
        return 0;
    }
    sprintf(sendBuffer,"PASS %s\r\n",password);
    ret = SendCommand(sendBuffer);
    if(ret != 1){
        return 0;
    }
    ret = RecvRespond(recvBuffer,1024);
    if(ret != 230){
        return 0;
    }
    printf("login sucess \r\n");


    ret = SendCommand("TYPE I\r\n");
    if(ret != 1){
        return 0;
    }
    ret = RecvRespond(recvBuffer,1024);
    if(ret != 200){
        return 0;
    }
    return 1;
}
int GetFileSize(char * name)
{
    int ret;
    int size;
    sprintf(sendBuffer,"SIZE %s\r\n",name);
    ret = SendCommand(sendBuffer);
    if(ret != 1){
        return 0;
    }
    ret = RecvRespond(recvBuffer,1024);
    if(ret != 213){
        printf("get file size failed\r\n");
        return 0;
    }
    size = atoi(recvBuffer + 4);
    return size;
}
int Download(char *name)
{
    wiz_socket(SOCKET_DATA, Sn_MR_TCP,12345,0);
    int len = GetFileSize(name);
    char *buf = malloc(len+1);
    printf("downloading file %s\r\n",name);
    int it;
    int ret;
    uint8_t addr[4];
    int port;
    ret = EnterPasv(addr,&port);

    if(ret != 1){
        wiz_sock_disconnect(SOCKET_DATA);
        return 0;
    }
    ret = wiz_sock_connect(SOCKET_DATA,addr,port);
    if(ret != 1){
        wiz_sock_disconnect(SOCKET_DATA);
        printf("fail to connect data port\r\n");
        return 0;
    }
    sprintf(sendBuffer,"RETR %s\r\n",name);
    ret = SendCommand(sendBuffer);
    if(ret != 1){
        wiz_sock_disconnect(SOCKET_DATA);
        return 0;
    }
    ret =  RecvRespond(recvBuffer,1024);
    if(ret!=150){
        wiz_sock_disconnect(SOCKET_DATA);
        return 0;
    }
    for(it = 0;it < len;it += ret){
        ret = wiz_sock_recv(SOCKET_DATA,((char *)buf + it),len);
        if(ret<0){
            printf("download was interupted\r\n");
            break;
        }
    }
    buf[len] = 0;
    printf("download %d/%d bytes complete. \r\n",it,len);
    ret = RecvRespond(recvBuffer,1024);
    if(ret != 226){
        wiz_sock_disconnect(SOCKET_DATA);
        return 0;
    }
    wiz_sock_disconnect(SOCKET_DATA);

    printf("creating file %s ....\r\n",name);
    int fd=open(name,O_RDWR | O_CREAT);
    if(fd > 0){
        ret = write(fd,buf,strlen(buf));
        if(ret < 0 ){
            printf("write failed\r\n");
        }
        else printf("success!\r\n");
    }
    else {
        printf("create file %s failed\r\n",name);
    }
    if(buf != NULL){
        free(buf);
    }
    return 1;
}
void Init()
{

    wiz_socket(SOCKET_CMD, Sn_MR_TCP,54321,0);
    printf("socket created\n");
}
void Quit()
{
    wiz_sock_disconnect(SOCKET_CMD);
}
int TestFtp()
{

    Init();

    uint8_t ip[4] = {192,168,130,70};
    Login(ip,21,"frank","114514");

    Download("File0.txt");
    Download("File1.txt");
    Download("File2.txt");
    Download("File3.txt");
    Download("File4.txt");
    Download("File5.txt");
    Download("File6.txt");
    Download("File7.txt");
    Download("File8.txt");
    Download("File9.txt");

    Quit();

    return 0;
}
PRIV_SHELL_CMD_FUNCTION(TestFtp, Implement ftp, PRIV_SHELL_CMD_MAIN_ATTR);
