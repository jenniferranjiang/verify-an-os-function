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
 * @file test_ftpclient.h
 * @brief a ftpClient test sample
 * @version 1.0
 * @author bdislab_final
 * @date 2023/9/16
 */

#ifndef TEST_FTPCLIENT_H
#define TEST_FTPCLIENT_H

#ifdef __cplusplus
extern "C" {
#endif
/*one client upLoad a file of 4K*/
void* UpLoad(void* arg);
/*one client downLoad 10 files of 4K*/
void* DownLoad(void* arg);
/* test for ftp client */
void TestFtpClient(int argc, char* argv[]);
#ifdef __cplusplus
}
#endif

#endif