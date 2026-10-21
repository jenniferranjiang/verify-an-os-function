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
 * @Description:包含modbusTCP请求报文的包装解析，以及报文收发，和每种功能码对应操作的实现。 
 * @Version: V1.0.0
 * @Author: pgh_dd 1041315949@qq.com
 * @Date: 2023-05-24 04:00:02
 * @LastEditors: pgh_dd 1041315949@qq.com
 * @LastEditTime: 2023-07-25 16:36:53
 */



#include"modbus_tcp.h"

u16_t Func0x_response_length[20]=
{
    0,9,9,9,9,12,12,0,0,0,0,0,0,0,0,12,12
};


/**
 * @description: 初始化功能码解析器
 * @param {MbParserType*}mbp {u8_t} type
 * @return {void}
 * @Date: 2023-07-25 16:59:23
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 * @LastEditTime: 2023-07-25 17:10:31
 */
void MbparserInit(MbParserType*mbp,u8_t type)
{
    mbp->func_set[R_RW_COIL]=FuncReadRwCoilX01;
    mbp->func_set[R_R_COIL]=FuncReadRCoilX02;
    mbp->func_set[R_RW_REG]=FuncReadRwRegX03;
    mbp->func_set[R_R_REG]=FuncReadRRegX04;
    mbp->func_set[W_RW_COIL]=FuncWriteRwCoilX05;
    mbp->func_set[W_RW_REG]=FuncWriteRwRegX06;
    mbp->func_set[W_MRW_REG]=FuncWriteRwMregsX10;
    mbp->func_set[W_MRW_COIL]=FuncWriteRwMcoilsX0f;
    mbp->func_set[REPORT_SlAVE_ID]=FuncReportSlaveIDX11;
};


/**
 * @description:初始化存储区 
 * @return {int}
 * @Date: 2023-07-25 17:01:47
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 * @LastEditTime: 2023-07-25 17:10:31
 */
int MbMemoryInit(MBmemoryType*mbm)
{
    mbm->rcoil_mem=(coils8_t*)malloc(sizeof(coils8_t)*RCOILMEM);
    mbm->rreg_mem=(reg_t*)malloc(sizeof(reg_t)*RREGMEM);
    mbm->rwcoil_mem=(coils8_t*)malloc(sizeof(coils8_t)*RWCOILMEM);
    mbm->rwreg_mem=(reg_t*)malloc(sizeof(reg_t)*RWREGMEM);

    memset(mbm->rwreg_mem,0,RWREGMEM);
    memset(mbm->rreg_mem,0,RREGMEM);
    memset(mbm->rcoil_mem,0,RCOILMEM);
    memset(mbm->rwcoil_mem,0,RWCOILMEM);

    // mbm->rwreg_mem[0]=3;
    // mbm->rwreg_mem[1]=0x30ff;
    mbm->rwcoil_mem[0]=1;mbm->rwcoil_mem[2]=1;mbm->rwcoil_mem[4]=1;

    if(mbm->rcoil_mem==NULL||mbm->rreg_mem==NULL||mbm->rwcoil_mem==NULL||mbm->rwreg_mem==NULL)
    {
        lw_error("memory is not full\n");
        return -1;
    }
    return 0;
}

/**
 * @description: 释放存储区
 * @return {void}
 * @Date: 2023-07-25 17:02:22
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 * @LastEditTime: 2023-07-25 17:10:31
 */
void MbMemoryFree(MBmemoryType*mbm)
{
    free(mbm->rcoil_mem);
    free(mbm->rreg_mem);
    free(mbm->rwcoil_mem);
    free(mbm->rwreg_mem);
}

/**
 * @description: 创建tcp通信套接字
 * @param {int} port
 * @return {int}
 * @Date: 2023-07-25 17:02:39
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 * @LastEditTime: 2023-07-25 17:10:31
 */
int CreateSocket(int port)
{
    int fd = -1, clientfd;
    fd = socket(AF_INET, SOCK_STREAM, 0);
    if(fd==-1)return -1;
    int recv_len;
    char *recv_buf;
    struct sockaddr_in tcp_addr;
    socklen_t addr_len;

    tcp_addr.sin_family = AF_INET;
    tcp_addr.sin_addr.s_addr = INADDR_ANY;
    tcp_addr.sin_port = htons(port);
    memset(&(tcp_addr.sin_zero), 0, sizeof(tcp_addr.sin_zero));

    if (bind(fd, (struct sockaddr *)&tcp_addr, sizeof(struct sockaddr)) == -1) {
        lw_error("Unable to bind\n");
        close(fd);
        return -1;
    }

    lw_print("tcp bind success, start to receive.\n");
    lw_notice("\nLocal Port:%d\n", port);

    // setup socket fd as listening mode
    if (listen(fd,128) != 0 ) {
        lw_error("Unable to listen\n");
        close(fd);
        return -1;
    }
    lw_print("Tcp start to listen.\n");
    return fd;
}

/**
 * @description: 读取请求报文的MBAP头部分
 * @param {int} fd {MbapType*}mbap
 * @return {}
 * @Date: 2023-07-25 17:03:04
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 * @LastEditTime: 2023-07-25 17:10:31
 */
int ReadMbtcpMBAP(int fd,MbapType*mbap)
{
    char buf[MODBUS_MBAP];
    read(fd,buf,MODBUS_MBAP);
    mbap->tid=(((u16_t)buf[0])<<8)+(u16_t)buf[1];//高位左移8位再加低位
    mbap->pid=(((u16_t)buf[2])<<8)+(u16_t)buf[3];
    mbap->len=(((u16_t)buf[4])<<8)+(u16_t)buf[5];
    mbap->uid=((u8_t)buf[6]);

};

/**
 * @description: 读取请求报文的PDU部分
 * @param {int} fd {PduType*}pdu
 * @return {}
 * @Date: 2023-07-25 17:03:04
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 * @LastEditTime: 2023-07-25 17:10:31
 */
int ReadMbtcpPDU(int fd,PduType*pdu)
{
    char buf[MODBUS_PDUHEAD];

    int n=read(fd,buf,MODBUS_PDUHEAD);


    pdu->func=(u8_t)buf[0];//高位左移8位再加低位
    
    if(n>3)
    {
        pdu->addr=(((u16_t)buf[1])<<8)+(u16_t)buf[2];
        pdu->operand1=(u8_t)buf[3];
        pdu->operand2=(u8_t)buf[4];
    }
};

/**
 * @description: 制作响应报文
 * @param  {MbapType*mbap,PduType*pdu,u8_t**resp,u16_t buf_len}
 * @return {}
 * @Date: 2023-07-25 17:11:23
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 * @LastEditTime: 2023-07-25 17:10:31
 */
void MakeResponse(MbapType*mbap,PduType*pdu,u8_t**resp,u16_t buf_len)
{
    buf_len-=6;
    //这个长度实际是从数据长度位置到结束的长度，因此要将响应报文的总长减去事务头、协议、长度三个两字节数共6个
    (*resp)[0]=(u8_t)(mbap->tid>>8);(*resp)[1]=(u8_t)(0xff&mbap->tid);
    (*resp)[2]=(u8_t)(mbap->pid>>8);(*resp)[3]=(u8_t)(0xff&mbap->pid);
    (*resp)[4]=(u8_t)(buf_len>>8);(*resp)[5]=(u8_t)(0xff&buf_len);
    (*resp)[6]=mbap->uid;
    (*resp)[7]=pdu->func;
}


/**
 * @description: 功能码0x1，负责读取从设备线圈的状态
 * @param {MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp}
 * @return {}
 * @Date: 2023-07-25 17:12:00
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 * @LastEditTime: 2023-07-25 17:10:31
 */
int FuncReadRwCoilX01(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp)
{
    printf("enter x01\n");
    printf("coils num:%d\n");
    u16_t coils_num=((u16_t)pdu->operand1<<8)+(u16_t)pdu->operand2;//线圈个数
    u16_t bytes_num=(coils_num/8+((coils_num%8)!=0));//输出的字节长度
    u16_t buf_len=Func0x_response_length[R_RW_COIL]+bytes_num;//response报文所占长度

    *resp=(u8_t*)malloc(buf_len); memset(*resp,0,buf_len);
    MakeResponse(mbap,pdu,resp,buf_len);
    (*resp)[8]=(u8_t)bytes_num;
    u8_t*sub_mem=mem->rwcoil_mem;
    for(int i=0;i<coils_num;i++)
    {   
        //按位将线圈值赋给response报文数据区,在内存区中，线圈按u8_t存放，但读取时要将其转换成位
        (*resp)[9+i/8]|=(sub_mem[i+pdu->addr]==1?((u8_t)1<<(i%8)):0);
    }
    
    return buf_len;
    // u8_t 
};

/**
 * @Description: 0x2功能码，读离散输入状态
 * @param {MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp}
 * @return {}
 * @Date: 2023-07-25 17:20:13
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
int FuncReadRCoilX02(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp)
{
    printf("enter x02\n");

    u16_t coils_num=((u16_t)pdu->operand1<<8)+(u16_t)pdu->operand2;//线圈个数
    u16_t bytes_num=(coils_num/8+((coils_num%8)!=0));//输出的字节长度
    u16_t buf_len=Func0x_response_length[R_RW_COIL]+bytes_num;//response报文所占长度

    *resp=(u8_t*)malloc(buf_len); memset(*resp,0,buf_len);
    MakeResponse(mbap,pdu,resp,buf_len);
    (*resp)[8]=(u8_t)bytes_num;
    u8_t*sub_mem=mem->rcoil_mem;
    for(int i=0;i<coils_num;i++)
    {   
        //按位将线圈值赋给response报文数据区,在内存区中，线圈按u8_t存放，但读取时要将其转换成位
        (*resp)[9+i/8]|=(sub_mem[i+pdu->addr]==1?((u8_t)1<<(i%8)):0);
    }
    
    return buf_len;
};


/**
 * @Description: 读保持寄存器
 * @param {MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp}
 * @return {}
 * @Date: 2023-07-25 17:21:01
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
int FuncReadRwRegX03(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp)
{
    printf("enter x03\n");
    u16_t data_len=((u16_t)pdu->operand1<<8)+(u16_t)pdu->operand2;

    u16_t buf_len=Func0x_response_length[R_RW_REG]+data_len*2;
    *resp=(u8_t*)malloc(buf_len);

    MakeResponse(mbap,pdu,resp,buf_len);

    (*resp)[8]=(u8_t)data_len*2;

    u16_t*sub_mem=mem->rwreg_mem;

    u16_t addr_mem=pdu->addr,addr_resp=9;
    int c=0;
    while(c<data_len)
    {
        (*resp)[addr_resp]=(u8_t)(sub_mem[addr_mem]>>8);
        (*resp)[addr_resp+1]=(u8_t)(sub_mem[addr_mem]&0xff);
        addr_resp+=2;addr_mem++;
        c++;
    }

    return buf_len;
};

/**
 * @Description: 0x4功能码，读输入寄存器
 * @param {MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp} 
 * @return {}
 * @Date: 2023-07-25 17:21:22
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
int FuncReadRRegX04(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp)
{
    printf("enter x04\n");
    u16_t data_len=((u16_t)pdu->operand1<<8)+(u16_t)pdu->operand2;

    u16_t buf_len=Func0x_response_length[R_R_REG]+data_len*2;
    *resp=(u8_t*)malloc(buf_len);

    MakeResponse(mbap,pdu,resp,buf_len);

    (*resp)[8]=(u8_t)data_len*2;

    u16_t*sub_mem=mem->rreg_mem;

    u16_t addr_mem=pdu->addr,addr_resp=9;

    int c=0;
    while(c<data_len)
    {
        (*resp)[addr_resp]=(u8_t)(sub_mem[addr_mem]>>8);
        (*resp)[addr_resp+1]=(u8_t)(sub_mem[addr_mem]&0xff);
        addr_resp+=2;addr_mem++;
        c++;
    }

    return buf_len;
};

/**
 * @Description: 0x5功能码，写单个线圈
 * @param {MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp}
 * @return {int}
 * @Date: 2023-07-25 17:21:51
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
int FuncWriteRwCoilX05(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp)
{
    printf("enter x05\n");
    u16_t addr_coil=pdu->addr;
    u16_t operand=(((u16_t)pdu->operand1)<<8)+(u16_t)pdu->operand2;
    if(operand==0xff00||operand==0x0000)
    {
        mem->rwcoil_mem[addr_coil]=(operand==0xff00?1:0);
    }

    u16_t buf_len=Func0x_response_length[W_RW_COIL];
    *resp=(u8_t*)malloc(buf_len);

    MakeResponse(mbap,pdu,resp,buf_len);

    (*resp)[8]=(u8_t)((pdu->addr)>>8);
    (*resp)[9]=(u8_t)(pdu->addr&0xff);
    (*resp)[10]=(u8_t)(pdu->operand1);
    (*resp)[11]=(u8_t)(pdu->operand2);

    printf("write data:%x\n",operand);

    return buf_len;

};

/**
 * @Description: 0x6功能码，写单个保持寄存器
 * @param {MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp}
 * @return {int}
 * @Date: 2023-07-25 17:22:38
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
int FuncWriteRwRegX06(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp)
{
    printf("enter x06\n");
    u16_t addr_reg=pdu->addr;
    u16_t reg_data=(u16_t)((pdu->operand1)<<8)+(u16_t)(pdu->operand2);
    mem->rwreg_mem[addr_reg]=reg_data;
    u16_t buf_len=Func0x_response_length[W_RW_REG];
    *resp=(u8_t*)malloc(buf_len);

    MakeResponse(mbap,pdu,resp,buf_len);

    (*resp)[8]=(u8_t)((pdu->addr)>>8);
    (*resp)[9]=(u8_t)(pdu->addr&0xff);
    (*resp)[10]=(u8_t)(pdu->operand1);
    (*resp)[11]=(u8_t)(pdu->operand2);

    printf("write data:%x\n",reg_data);
    return buf_len;
};

/**
 * @Description: 0xf功能码，写多个线圈
 * @param {MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp}
 * @return {int}
 * @Date: 2023-07-25 17:23:16
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
int FuncWriteRwMcoilsX0f(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp)
{
    printf("enter x0f\n");
    u16_t coils_num=(((u16_t)(pdu->operand1))<<8)+(u16_t)(pdu->operand2);

    u16_t res_num=coils_num/8+(coils_num%8!=0)+1;

    u8_t*recv_buf=(u8_t*)malloc(sizeof(u8_t)*res_num);

    int n=read(fd,(char*)recv_buf,res_num);


    u8_t*sub_mem=mem->rwcoil_mem;

    for(int i=0;i<coils_num;i++)
    {
        sub_mem[pdu->addr+i]=((recv_buf[1+i/8]&(1<<(i%8)))==0?0:1);
    }


    u16_t buf_len=Func0x_response_length[W_MRW_COIL];
    *resp=(u8_t*)malloc(buf_len);

    MakeResponse(mbap,pdu,resp,buf_len);

    (*resp)[8]=(u8_t)((pdu->addr)>>8);
    (*resp)[9]=(u8_t)(pdu->addr&0xff);
    (*resp)[10]=(u8_t)(pdu->operand1);
    (*resp)[11]=(u8_t)(pdu->operand2);

    free(recv_buf);

    
    
    return buf_len;
};

/**
 * @Description: 0x10功能码，写多个保持寄存器
 * @param {MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp}
 * @return {int}
 * @Date: 2023-07-25 17:23:56
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
int FuncWriteRwMregsX10(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp)
{
    printf("enter x10\n");
    u16_t data_num=(((u16_t)(pdu->operand1))<<8)+(u16_t)(pdu->operand2);
    u16_t res_num=data_num*2+1;
    u8_t*recv_buf=(u8_t*)malloc(sizeof(u8_t)*res_num);

    
    int n=read(fd,(char*)recv_buf,res_num);

    // printf("%x %x %x\n",recv_buf[0],recv_buf[1],recv_buf[2]);

    u16_t*sub_mem=mem->rwreg_mem;

    for(int i=0;i<data_num;i++)
    {
        sub_mem[pdu->addr+i]=(((u16_t)(recv_buf[1+i*2]))<<8)+(u16_t)(recv_buf[1+i*2+1]);
    }


    u16_t buf_len=Func0x_response_length[W_MRW_REG];
    *resp=(u8_t*)malloc(buf_len);

    MakeResponse(mbap,pdu,resp,buf_len);

    (*resp)[8]=(u8_t)((pdu->addr)>>8);
    (*resp)[9]=(u8_t)(pdu->addr&0xff);
    (*resp)[10]=(u8_t)(pdu->operand1);
    (*resp)[11]=(u8_t)(pdu->operand2);

    
    free(recv_buf);

    return buf_len;
};

/**
 * @Description: 报告从设备id
 * @param {int} fd
 * @return {}
 * @Date: 2023-07-25 17:24:43
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
int FuncReportSlaveIDX11(MBmemoryType*mem,int fd,MbapType*mbap,PduType*pdu,u8_t**resp)
{
    printf("enter x11\n");

};

/**
 * @Description: 发送响应报文
 * @param {int} fd
 * @param {u16_t} n
 * @return {}
 * @Date: 2023-07-25 17:24:55
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
int SendResponse(int fd,u8_t**buf,u16_t n)
{
    printf("Response:");
    for(int i=0;i<n;i++)printf("%x ",(*buf)[i]);
    printf("\n\n");
    int num=write(fd,(char*)*buf,n);
    free(*buf);
    return num;
};

/**
 * @Description: 读取键盘输入，并生成请求报文
 * @param {u8_t} flag
 * @return {}
 * @Date: 2023-07-25 17:25:26
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
int GenerateModbusRequest(MbapType*mbap,PduType*pdu,u8_t flag,u8_t**request)
{
    int send_buf_length=0;
    while(1)
    {
        printf("\nPlease set the region of command\n");

        printf("The slave id:");
        scanf("%d",&mbap->uid);printf("%d",mbap->uid);printf("\n");

        printf("Please input function code:");
        scanf("%x",&pdu->func);printf("%x",pdu->func);printf("\n");

        printf("The address:");
        scanf("%d",&pdu->addr);printf("%d",pdu->addr);printf("\n");

        switch (pdu->func)
        {
            case R_RW_COIL:
            case R_R_COIL:printf("The number of coils you want read:");break;
            case R_RW_REG:
            case R_R_REG:printf("The number of registers you want read:");break;

            case W_RW_COIL:printf("The value of coil you want write(1 or 0):");break;
            case W_RW_REG:printf("The value of register you want write:");break;
            
            case W_MRW_COIL:printf("The number of coils you want write:");break;
            case W_MRW_REG:printf("The number of registers you want write:");break;
            
            default:
                break;
        }
        u16_t num;
        scanf("%d",&num);printf("%d\n",num);
        if(pdu->func==W_RW_COIL)
        {
            pdu->operand2=0;
            pdu->operand1=(num==1?0xff:0);
        }
        else {
            pdu->operand1=(u8_t)(num>>8);
            pdu->operand2=(u8_t)(num&0x00ff);
        }
        

        if(pdu->func==W_MRW_REG)
        {
            send_buf_length=num*2+1+12;
            *request=(u8_t*)malloc(send_buf_length);
            memset(*request,0,send_buf_length);
            printf("input register data(decimal integer,in total %d):",num);
            (*request)[12]=(u8_t)(num*2);
            for(int i=0;i<num;i++)
            {
                u16_t tem;
                scanf("%d",&tem);printf("%d ",tem);
                (*request)[i*2+13]=(u8_t)(tem>>8);
                (*request)[i*2+13+1]=(u8_t)(tem&0x00ff);
            }
            printf("\n");
        }
        else if(pdu->func==W_MRW_COIL)
        {
            send_buf_length=num/8+(num%8!=0)+1+12;
            *request=(u8_t*)malloc(send_buf_length);
            memset(*request,0,send_buf_length);
            printf("input coil data(0 or 1,in total %d):",num);
            (*request)[12]=(u8_t)(num/8+(num%8!=0));
            for(int i=0;i<num;i++)
            {
                u16_t tem;
                scanf("%d",&tem);printf("%d ",tem);
                if(tem==1)
                {
                    (*request)[i/8+13]|=(1<<(i%8));
                    // (*resp)[9+i/8]|=(sub_mem[i+pdu->addr]==1?((u8_t)1<<(i%8)):0);
                }
            }
            printf("\n");
        }
        else 
        {
            send_buf_length=12;
            *request=(u8_t*)malloc(send_buf_length);
            if((*request)==NULL)printf("erro\n");
            
        }

        (*request)[0]=(u8_t)(mbap->tid>>8);(*request)[1]=(u8_t)(0xff&mbap->tid);
        (*request)[2]=(u8_t)(mbap->pid>>8);(*request)[3]=(u8_t)(0xff&mbap->pid);
        (*request)[4]=(u8_t)((send_buf_length-6)>>8);(*request)[5]=(u8_t)(0xff&(send_buf_length-6));
        (*request)[6]=mbap->uid;
        (*request)[7]=pdu->func;
        (*request)[8]=(u8_t)(pdu->addr>>8);(*request)[9]=(u8_t)(0xff&pdu->addr);
        (*request)[10]=pdu->operand1;(*request)[11]=pdu->operand2;

        printf("messege is:");
        for(int i=0;i<send_buf_length;i++)printf("%x ",(*request)[i]);
        printf("\n");


        printf("Decide to send? input 's' to send,else to reset the command:");
        char c;
        scanf("%c",&c);printf("%c\n",c);
        if(c=='s')break;
        else {
            free(*request);
            continue;
        };
    }
    
    return send_buf_length;
};


/**
 * @Description: 发送请求报文
 * @param {int fd,u8_t**request,int n}
 * @return {}
 * @Date: 2023-07-25 17:26:10
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
void SendModbus(int fd,u8_t**request,int n)
{
    n=write(fd,(char*)*request,n);
    free(*request);
}

/**
 * @Description: 读取请求报文
 * @param {(int fd,MbapType*mbap,PduType*pdu}
 * @return {void}
 * @Date: 2023-07-25 17:26:49
 * @Author: pgh_dd 1041315949@qq.com
 * @LastEditors: pgh_dd 1041315949@qq.com
 */
void GetRequest(int fd,MbapType*mbap,PduType*pdu)
{
    u16_t data_num;
    ReadMbtcpMBAP(fd,mbap);//先读取定长的MBAP部分
    

    read(fd,(char*)&pdu->func,1);//读取功能码

    u8_t byte_num=0;
    u8_t *recv_buf;
    switch (pdu->func)
    {
        case R_R_COIL:
        case R_R_REG:
        case R_RW_COIL:
        case R_RW_REG:
            data_num=(((u16_t)(pdu->operand1))<<8)+(u16_t)(pdu->operand2);
            read(fd,&byte_num,1);
            recv_buf=(u8_t*)malloc(byte_num);
            read(fd,recv_buf,byte_num);
        /* code */
        break;
        case W_RW_COIL:
        case W_RW_REG:
        case W_MRW_REG:
        case W_MRW_COIL:
            recv_buf=(u8_t*)malloc(4);
            read(fd, recv_buf,4);
        break;
    default:
        break;
    }
    
    printf("Response: TID:%x func code:%x byte num:%x\n",mbap->tid,pdu->func,byte_num);
    
    if(pdu->func==R_R_COIL||pdu->func==R_RW_COIL)
    {   
        printf("coils:");
        for(int i=0;i<data_num;i++)
        {
            printf("%d ",(recv_buf[i/8]&(1<<(i%8)))==0?0:1);
        }
        printf("\n");
    }
    else if(pdu->func==R_R_REG||pdu->func==R_RW_REG)
    {
        printf("registers:");
        // for(int i=0;i<byte_num;i++)printf("%x ",recv_buf[i]);printf("\n");
        for(int i=0;i<data_num;i++)
        {
            printf("%d ",(((u16_t)(recv_buf[i*2]))<<8)+(u16_t)(recv_buf[i*2+1]));
        }
        printf("\n");
    }
    free(recv_buf);
}