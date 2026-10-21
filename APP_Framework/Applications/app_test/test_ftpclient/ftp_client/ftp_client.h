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
* @date:    2023/7/25
*/

#ifndef FTP_CLIENT_H
#define FTP_CLIENT_H

/* init ftp cmd socket */ 
void FtpInitCmd(void);

/* init ftp data socket */
void FtpInitData(void);

/* quit ftp */
void FtpQuit(void);

/* fpt login */
int  FtpLogin(char *addr, int port, char *username, char *password);

/* get file size */
int  FtpFileSize(char *name);

/* ftp download file*/
int  FtpDownload(char *name, char *buf, int len);

#endif
