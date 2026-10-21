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
* @file lwip_tcp_socket_demo.c
* @brief TCP socket demo based on LwIP
* @version 1.0
* @author AIIT XUOS Lab
* @date 2022-03-21
*/

#include <transform.h>
#include"modbus_tcp.h"

#ifdef ADD_XIZI_FEATURES
#include <sys_arch.h>
#include <lwip/sockets.h>
#include "lwip/sys.h"
#endif

#ifdef ADD_NUTTX_FEATURES
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "stdio.h"
#endif

#define TCP_DEMO_BUF_SIZE                    65535
#define TCP_DEMO_SEND_TIMES                  20
#define LWIP_TCP_DEMO_TASK_STACK_SIZE        4096
#define LWIP_TCP_DEMO_TASK_PRIO              20

static pthread_t tcp_client_task;
static pthread_t tcp_server_task;

static char tcp_demo_ipaddr[] = {192, 168, 31, 77};
static char tcp_demo_netmask[] = {255, 255, 255, 0};
static char tcp_demo_gwaddr[] = {192, 168, 31, 1};

#ifdef ADD_NUTTX_FEATURES
#define lw_print printf
#define lw_notice printf
#define lw_error printf

#define LWIP_DEMO_TIMES 3
#define LWIP_TARGET_PORT 4840
#endif

static uint16_t tcp_socket_port = 8888;
static char tcp_ip_str[128] = {0};

/******************************************************************************/
static void TcpSocketConfigParam(char *ip_str)
{
    int ip1, ip2, ip3, ip4, port = 0;

    if(ip_str == NULL)
        return;

    if(sscanf(ip_str, "%d.%d.%d.%d:%d", &ip1, &ip2, &ip3, &ip4, &port)) {
        printf("config ip %s port %d\n", ip_str, port);
        strcpy(tcp_ip_str, ip_str);
        if(port)
            tcp_socket_port = port;
        return;
    }

    if(sscanf(ip_str, "%d.%d.%d.%d", &ip1, &ip2, &ip3, &ip4)) {
        printf("config ip %s\n", ip_str);
        strcpy(tcp_ip_str, ip_str);
    }
}

static void *ModbusTcpServer(void *arg)
{

    u8_t uid=1;//定义从设备id和存储区
    
    MBmemoryType mbm;//定义存储区
    if(MbMemoryInit(&mbm)==-1)//初始化存储区，包括对四个存储区进行内存分配
    {
        return 0;
    };

    MbParserType mb_parser;//初始化功能码解析器
    MbparserInit(&mb_parser,MBTCP);//初始化解析器，将功能码对应函数注册

    int fd=CreateSocket(PORT);//创建监听套接字
    if(fd==-1)return 0;

    int recv_len;
    char *recv_buf;
    struct sockaddr_in tcp_addr;
    socklen_t addr_len;

    while(1)
    {
        struct sockaddr_in tcp_addr;
        socklen_t addr_len;

        printf("wait accept\n");
        int clientfd = accept(fd, (struct sockaddr *)&tcp_addr, (socklen_t*)&addr_len);

        if(clientfd==-1)
        {
            lw_error("Unable to listen\n");
            return 0;
        }

        while(1)
        {
            MbapType mbap;
            PduType pdu;
            ReadMbtcpMBAP(clientfd,&mbap);//读取数据前7字节为mbap初始化
            
            if(mbap.uid!=uid){//检验是否为此从机
                close(clientfd);
                break;
            }
            

            ReadMbtcpPDU(clientfd,&pdu);//读取pdu和一些定长部分

            printf("OP:%x\n",pdu.func);
            printf("ADDR:%x\n",pdu.addr);
            
            u8_t* response_buf;//定义操作返回的指针
            u8_t buf_len=mb_parser.func_set[pdu.func](&mbm,clientfd,&mbap,&pdu,&response_buf);
            
            SendResponse(clientfd,&response_buf,buf_len);
            // return NULL;
            //执行操作

        }
        close(clientfd);
    }
    close(fd);
    MbMemoryFree(&mbm);//释放存储区
}

void TestModbusTcpServer(int argc, char *argv[])
{
    if(argc >= 2) {
        lw_print("lw: [%s] target ip %s\n", __func__, argv[1]);
        TcpSocketConfigParam(argv[1]);
    }

#ifdef ADD_XIZI_FEATURES
    lwip_config_tcp(0, tcp_demo_ipaddr, tcp_demo_netmask, tcp_demo_gwaddr);

#endif

#ifdef ADD_NUTTX_FEATURES
    pthread_attr_t attr = PTHREAD_ATTR_INITIALIZER;
    attr.priority = LWIP_TCP_DEMO_TASK_PRIO;
    attr.stacksize = LWIP_TCP_DEMO_TASK_STACK_SIZE;
#endif

    ModbusTcpServer(NULL);
}

PRIV_SHELL_CMD_FUNCTION(TestModbusTcpServer, a modbusS test sample, PRIV_SHELL_CMD_MAIN_ATTR);

static void *ModbusTcpClient(void *arg)
{
    u16_t counter=0;
    int fd = -1;
    int ret;

	// lw_print("2023-05-27 Peng Guanhua\n");
    lw_print("%s start\n", __func__);

    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) {
        lw_print("Socket error\n");
        return NULL;
    }

    char tcp_ip_str[128]="192.168.31.148";
    u16_t tcp_socket_port=6000;
    

    printf("%s\n",tcp_ip_str);
    struct sockaddr_in tcp_sock;
    tcp_sock.sin_family = AF_INET;
    tcp_sock.sin_port = htons(tcp_socket_port);
    tcp_sock.sin_addr.s_addr = inet_addr(tcp_ip_str);
    printf("%s\n",tcp_ip_str);

    memset(&(tcp_sock.sin_zero), 0, sizeof(tcp_sock.sin_zero));

    ret = connect(fd, (struct sockaddr *)&tcp_sock, sizeof(struct sockaddr));

    if (ret < 0) {
        lw_print("Unable to connect %s:%d = %d\n", tcp_ip_str, tcp_socket_port, ret);
        close(fd);
        return NULL;
    }

    lw_print("TCP connect %s:%d success, start.\n", tcp_ip_str, tcp_socket_port);


    while (1) {

        MbapType mbap={counter,0,0,0};
        PduType pdu;
        u8_t*request;
        
        int mesg_len=GenerateModbusRequest(&mbap,&pdu,MBTCP,&request);
        SendModbus(fd,&request,mesg_len);
        GetRequest(fd,&mbap,&pdu);
        counter++;
    }

    close(fd);
    return NULL;
}

void TestModbusTcpClient(int argc, char *argv[])
{
    if(argc >= 2) {
        lw_print("lw: [%s] target ip %s\n", __func__, argv[1]);
        TcpSocketConfigParam(argv[1]);
    }

#ifdef ADD_XIZI_FEATURES
    lwip_config_tcp(0, tcp_demo_ipaddr, tcp_demo_netmask, tcp_demo_gwaddr);

#endif
#ifdef ADD_NUTTX_FEATURES
    pthread_attr_t attr = PTHREAD_ATTR_INITIALIZER;
    attr.priority = LWIP_TCP_DEMO_TASK_PRIO;
    attr.stacksize = LWIP_TCP_DEMO_TASK_STACK_SIZE;
#endif

    ModbusTcpClient(NULL);
}
PRIV_SHELL_CMD_FUNCTION(TestModbusTcpClient, a modbustcpC test sample, PRIV_SHELL_CMD_MAIN_ATTR);

