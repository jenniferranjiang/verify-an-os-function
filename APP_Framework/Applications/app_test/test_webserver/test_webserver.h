/**
* @file:    test_webserver.h
* @brief:   a application of test webserver function
* @version: 1.0
* @author:  Yao wenying
* @date:    2023/08/20
*/


#ifndef __WEBSERVER_H__
#define __WEBSERVER_H__

#include "lwip/opt.h"
#include <lwip/sockets.h>
#include "lwip/api.h"
#include "lwip/sys.h"
#include "netif/ethernet.h"
#include "lwip/tcpip.h"
#include "sys_arch.h"
#include <netdev.h>
#include "dns.h"
#include "string.h"


#define PORT              80
#define RECV_DATA         1024
struct ServerNet 
{
    char local_ip[20];
    char local_mask[20];
    char local_gw[20];
    char local_dns[20];
}ServerNet;

void LwipShowIP();
void LwipSetIP(int argc, char *argv[]); 
void ShowDns();
void SetDns();
void AddrUpdate();  //更新本机网络参数信息
void HandleHttpRequest(); //解析报文，并返回响应
void TcpThread();//建立socket监听，循环等待网络通信事件到来

#endif