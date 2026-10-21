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
* @file:    test_ftpclient.c
* @brief:   a ftpClient test sample
* @version: 1.0
* @author:  bdislab_final
* @date:    2023/7/25
*/

#include "test_ftpclient.h"
#include "ftp_client/ftp_client.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <transform.h>


/* test for ftp client */
void TestFtpClient(int argc, char* argv[])
{
    FtpInitCmd();
    int ret = FtpLogin("192.168.1.248", 21, "anonymous", "anonymous");
    int size;
    char *buf;
    for(int i = 1;i <= 10;i++){
        char fileName[20] = "/file"; 
        char temp[5] = "";
        sprintf(temp,"%d",i-1);
        strcat(fileName,temp);
        size = FtpFileSize(fileName);
        buf = malloc(size);
        FtpInitData();  // data socket 每次下载都要重新创建，下载完都要关闭
        ret = FtpDownload(fileName, buf, size);
        free(buf);
    }
    FtpQuit();
    return;
}
PRIV_SHELL_CMD_FUNCTION(TestFtpClient, a ftpClient test sample, PRIV_SHELL_CMD_MAIN_ATTR);
