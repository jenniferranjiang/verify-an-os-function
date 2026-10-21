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
* @file:    ftp_client.h
* @brief:   ftp client tool
* @version: 1.0
* @author:  bdislab_final
* @date:    2023/9/16
*/

#ifndef FTP_CLIENT_H
#define FTP_CLIENT_H

#define THREAD_NUM 10

/* init ftp cmd socket */ 
void FtpInitCmd(int threadID);

/* init ftp data socket */
void FtpInitData(int threadID);

/* quit ftp */
void FtpQuit(int threadID);

/* fpt login */
int  FtpLogin(int threadID,char *addr, int port, char *username, char *password);

/* get file size */
int  FtpFileSize(int threadID,char *name);

/* ftp download file*/
int  FtpDownload(int threadID,char *name, void *buf, int len);

/*ftp upload*/
int  FtpUpload(int threadID,char *name, void *buf, int len);
#endif
