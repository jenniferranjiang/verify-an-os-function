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
* @date:    2023/9/16
*/

#include "test_ftpclient_final.h"
#include "ftp_client/ftp_client.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <transform.h>
#include <pthread.h>

int threadIDs[THREAD_NUM];

/*one client upLoad a file of 4K*/
void* UpLoad(void* arg){
    int *pThreadID = (int*)arg;
    printf("in thread:tid=%ld\n", pthread_self());
    FtpInitCmd(*pThreadID);
    int ret = FtpLogin(*pThreadID,"8.140.53.225", 9992, "anonymous", "anonymous");
    int size = 4096;
    char buf[size];
    char fileName[20];
    sprintf(fileName,"file%d",*pThreadID);
    for(int i = 0;i < size;++i){
        buf[i] = '0';
    }
    FtpInitData(*pThreadID);  // data socket 每次下载都要重新创建，下载完都要关闭
    ret = FtpUpload(*pThreadID,fileName,buf,size);
    FtpQuit(*pThreadID);
    return NULL;
}

/*one client downLoad a file of 4K*/
void* DownLoad(void* arg){
    int *pThreadID = (int*)arg;
    printf("in thread:tid=%ld\n", pthread_self());
    FtpInitCmd(*pThreadID);
    int ret = FtpLogin(*pThreadID,"8.140.53.225", 9992, "anonymous", "anonymous");
    int size;
    char *buf;
    char fileName[20] = "/file1"; 
    size = FtpFileSize(*pThreadID,fileName);
    buf = malloc(size);
    FtpInitData(*pThreadID);  // data socket 每次下载都要重新创建，下载完都要关闭
    ret = FtpDownload(*pThreadID,fileName, buf, size);
    free(buf);
    FtpQuit(*pThreadID);
    return NULL;
}

/* test for 10 ftp client */
void TestFtpClient(int argc, char* argv[])
{
    int options = atoi(argv[1]);
    int n = atoi(argv[2]);
    pthread_t threads[THREAD_NUM];
    for(int i = 0;i < n;++i){
        threadIDs[i] = i;
        if(options == 1){ // 全部都是下载
            pthread_create(&threads[i],NULL,&DownLoad,&threadIDs[i]);
        }else if(options == 2){ // 全部都是上传
            pthread_create(&threads[i],NULL,&UpLoad,&threadIDs[i]);
        }else if(options == 3){  // 随机下载/上传
            int r = rand()%2;
            if(r == 0){
                printf("===============download===============\n");
                pthread_create(&threads[i],NULL,&DownLoad,&threadIDs[i]);
            }else{
                printf("===============upload===============\n");
                pthread_create(&threads[i],NULL,&UpLoad,&threadIDs[i]);
            }
        }
    }
    return;
}
PRIV_SHELL_CMD_FUNCTION(TestFtpClient, a ftpClient test sample, PRIV_SHELL_CMD_MAIN_ATTR);
