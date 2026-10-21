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

/*
 * @Description: 包含modbusTCP请求报文的包装解析，以及报文收发，和每种功能码对应操作的定义。 
 * @Version: V1.0.0
 * @Author: 快乐小组
 * @Date: 2023-05-24 03:59:45
 * @LastEditors: pgh_dd 1041315949@qq.com
 * @LastEditTime: 2023-07-25 16:53:39
 */


#ifndef __MODBUSTCP_H__
#define __MODBUSTCP_H__

#include<stdlib.h>
#include<stdio.h>
#include<transform.h>
#include <sys_arch.h>
#include <lwip/sockets.h>
#include "lwip/sys.h"

#define PORT 8888
#define RCOILMEM 1000
#define RREGMEM 1000
#define RWCOILMEM 1000
#define RWREGMEM 1000

#define MBTCP 1
#define MBRTU 2
//功能码
#define R_RW_COIL 0x01
#define R_R_COIL 0x02
#define R_RW_REG 0x03
#define R_R_REG 0x04
#define W_RW_COIL 0x05
#define W_RW_REG 0x06
#define DIAGNOSTIC 0x08
#define GET_COUNTER 0x0B
#define W_MRW_COIL 0x0F
#define W_MRW_REG 0x10
#define REPORT_SlAVE_ID 0x11


typedef u8_t coils8_t;
typedef u16_t reg_t;

#define MODBUS_MBAP 7
#define MODBUS_PDUHEAD 5


//定义存储区结构体
typedef struct MbMemory
{
    coils8_t*rcoil_mem;
    reg_t*rreg_mem;
    coils8_t*rwcoil_mem;
    reg_t*rwreg_mem;
}MBmemoryType;
//初始化存储区的函数
int MbMemoryInit(MBmemoryType*mb);
//释放存储区
void MbMemoryFree(MBmemoryType*mb);


//协议的固定部分为12个字节，当功能码为写多个数据时，后续还有不定长的数据部分
typedef struct mbap
{
    //MbapType
    u16_t tid;
    u16_t pid;
    u16_t len;
    u8_t uid;

    /* data */
}MbapType;

typedef struct pdu
{
    u8_t func;    

    u16_t addr;

    u8_t operand1;
    u8_t operand2;
    /* data */
}PduType;

int CreateSocket(int port);

int ReadMbtcpMBAP(int fd,MbapType*mb_s);
int ReadMbtcpPDU(int fd,PduType*mb_s);


//操作函数

int FuncReadRwCoilX01(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp);
int FuncReadRCoilX02(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp);
int FuncReadRwRegX03(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp);
int FuncReadRRegX04(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp);
int FuncWriteRwCoilX05(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp);
int FuncWriteRwRegX06(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp);
int FuncWriteRwMcoilsX0f(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp);
int FuncWriteRwMregsX10(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp);

int FuncReportSlaveIDX11(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp);
//位地址转换字节地址

//定义解析器结构体
typedef struct mbparser
{
    int (*func_set[20])(MBmemoryType*,int,MbapType*,PduType*,u8_t**resp);
}MbParserType;
//解析器初始化，实际上就是每个功能码对应的操作函数的注册
void MbparserInit(MbParserType*mbp,u8_t flag);

void MakeResponse(MbapType*,PduType*,u8_t**,u16_t);

int SendResponse(int fd,u8_t**buf,u16_t n);


// void func(PDU*pdu);

// void delete_modbus_request();
//主机程序
int GenerateModbusRequest(MbapType*,PduType*,u8_t flag,u8_t**request);

void SendModbus(int fd,u8_t**request,int n);

void GetRequest(int fd,MbapType*,PduType*);
#endif
