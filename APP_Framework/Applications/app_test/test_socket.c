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

#include <argparse.h>
#include <stdbool.h>
#include <transform.h>

#include "lwip/sockets.h"
#include "sys_arch.h"

#define IPERF_PORT 5001
#define IPERF_BUFSZ (4 * 1024)

enum IperfMode {
    IPERF_MODE_STOP = (1 << 0),
    IPERF_MODE_SERVER = (1 << 1),
    IPERF_MODE_CLIENT = (1 << 2),
};

struct AtomicIperfMode {
    /* pthread_mutex_t here is a int */
    pthread_mutex_t mtx;
    enum IperfMode mode;
};

static struct AtomicIperfMode* GetGlobalIperfMode()
{
    /* init when used */
    static struct AtomicIperfMode g_iperf_mode = {
        -1,
        IPERF_MODE_STOP,
    };
    if (g_iperf_mode.mtx < 0) {
        /* mtx is a static obj, so there is only creation but not destruction */
        PrivMutexCreate(&g_iperf_mode.mtx, NULL);
        /* init lwip if necessary */
        lwip_config_tcp(0, lwip_ipaddr, lwip_netmask, lwip_gwaddr);
    }
    return &g_iperf_mode;
}

static enum IperfMode GetGlobalMode()
{
    enum IperfMode mode = IPERF_MODE_STOP;
    struct AtomicIperfMode* g_mode = GetGlobalIperfMode();

    PrivMutexObtain(&g_mode->mtx);
    mode = g_mode->mode;
    PrivMutexAbandon(&g_mode->mtx);

    return mode;
}

static void SetGlobalMode(enum IperfMode mode)
{
    struct AtomicIperfMode* g_mode = GetGlobalIperfMode();
    PrivMutexObtain(&g_mode->mtx);
    g_mode->mode = mode;
    PrivMutexAbandon(&g_mode->mtx);
}

struct IperfParam {
    char host[16];
    int port;
};

static void* TestIperfServer(void* param)
{
    struct IperfParam* iperf_param = (struct IperfParam*)param;
    int sock = socket(AF_INET, SOCK_STREAM, 6);
    if (sock < 0) {
        printf("[%s] Err: Can't create socker.\n", __func__);
        return NULL;
    } else {
        printf("[%s] Info Create server socket %d\n", __func__, sock);
    }

    uint8_t* recv_data = (uint8_t*)malloc(IPERF_BUFSZ);
    if (recv_data == NULL) {
        KPrintf("[%s] No memory to alloc buffer!\n", __func__);
        goto __exit;
    }

    struct sockaddr_in server_addr, client_addr;
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(iperf_param->port);
    server_addr.sin_addr.s_addr = INADDR_ANY;
    memset(&(server_addr.sin_zero), 0x0, sizeof(server_addr.sin_zero));

    if (bind(sock, (struct sockaddr*)&server_addr, sizeof(struct sockaddr)) == -1) {
        KPrintf("[%s] Err: Unable to bind socket: %d!\n", __func__, sock);
        goto __exit;
    }

    if (listen(sock, 5) == -1) {
        KPrintf("[%s] Err: Listen error!\n", __func__);
        goto __exit;
    }

    struct timeval timeout = {
        .tv_sec = 3,
        .tv_usec = 0,
    };

    fd_set readset;
    while (GetGlobalMode() == IPERF_MODE_SERVER) {
        FD_ZERO(&readset);
        FD_SET(sock, &readset);

        if (select(sock + 1, &readset, NULL, NULL, &timeout) == 0) {
            continue;
        }

        socklen_t sin_size = sizeof(struct sockaddr_in);
        struct sockaddr_in client_addr;
        int connection = accept(sock, (struct sockaddr*)&client_addr, &sin_size);
        printf("[%s] Info: New client connected from (%s, %d), connect: %d\n", __func__,
            inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port),
            connection);

        int flag = 1;
        setsockopt(connection,
            IPPROTO_TCP, /* set option at TCP level */
            TCP_NODELAY, /* name of option */
            (void*)&flag, /* the cast is historical cruft */
            sizeof(int)); /* length of option value */

        int recvlen = 0;
        int tick_beg = PrivGetTickTime();
        int tick_end = tick_beg;
        while (GetGlobalMode() == IPERF_MODE_SERVER) {
            int bytes_received = recv(connection, recv_data, IPERF_BUFSZ, 0);
            if (bytes_received == 0) {
                KPrintf("client disconnected (%s, %d)\n",
                    inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
                break;
            } else if (bytes_received < 0) {
                KPrintf("recv error: %d, client: (%s, %d)\n",
                    bytes_received, inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
                break;
            }

            recvlen += bytes_received;

            tick_end = PrivGetTickTime();
            if (tick_end - tick_beg >= 5000) {
                double speed;
                // int integer, decimal;

                speed = (double)(recvlen / (tick_end - tick_beg));
                speed = speed / 1000.0f;
                printf("[%s]: %2.4f MBps!\n", __func__, speed);
                tick_beg = tick_end;
                recvlen = 0;
            }
        }
        if (connection >= 0)
            closesocket(connection);
        connection = -1;
    }

__exit:
    if (sock >= 0)
        closesocket(sock);
    if (recv_data)
        free(recv_data);
    return NULL;
}

static void* TestIperfClient(void* param)
{
    struct IperfParam* iperf_param = (struct IperfParam*)param;

    uint8_t* send_buf
        = (uint8_t*)malloc(IPERF_BUFSZ);
    if (NONE == send_buf) {
        printf("[%s] Err: Unable to alloc buffer\n", __func__);
        return NULL;
    }
    for (int i = 0; i < IPERF_BUFSZ; i++) {
        send_buf[i] = i & 0xff;
    }

    struct sockaddr_in addr;
    while (GetGlobalMode() == IPERF_MODE_CLIENT) {
        int sock = socket(AF_INET, SOCK_STREAM, 0);
        if (sock < 0) {
            printf("[%s] Warning: Can't create socker.\n", __func__);
            PrivTaskDelay(1000);
            continue;
        }

        addr.sin_family = PF_INET;
        addr.sin_port = htons(iperf_param->port);
        addr.sin_addr.s_addr = inet_addr((char*)iperf_param->host);

        int ret = connect(sock, (const struct sockaddr*)&addr, sizeof(addr));
        if (ret == -1) {
            printf("[%s] Warning: Connect to iperf server faile, Waiting for the server to open!\n", __func__);
            closesocket(sock);
            DelayKTask(TICK_PER_SECOND);
            continue;
        }
        printf("[%s] Connect to iperf server successful!\n", __func__);

        int flag = 1;
        setsockopt(sock,
            IPPROTO_TCP, /* set option at TCP level */
            TCP_NODELAY, /* name of option */
            (void*)&flag, /* the cast is historical cruft */
            sizeof(int)); /* length of option value */

        int tick_beg = PrivGetTickTime();
        int tick_end = tick_beg;
        int sentlen = 0;
        while (GetGlobalMode() == IPERF_MODE_CLIENT) {
            tick_end = PrivGetTickTime();
            /* Print every 5 second */
            if (tick_end - tick_beg >= 5000) {
                double speed;

                speed = (double)(sentlen / (tick_end - tick_beg));
                speed = speed / 1000.0f;
                printf("[%s]: %2.4f MBps!\n", __func__, speed);
                tick_beg = tick_end;
                sentlen = 0;
            }

            ret = send(sock, send_buf, IPERF_BUFSZ, 0);
            if (ret > 0) {
                sentlen += ret;
            }

            if (ret < 0)
                break;
        }

        closesocket(sock);
        printf("[%s] Info: Disconnected, iperf server shut down!\n", __func__);
    }
    free(send_buf);
    return NULL;
}

enum IperfParamEnum {
    IPERF_PARAM_SERVER = 's',
    IPERF_PARAM_CLIENT = 'c',
    IPERF_PARAM_STOP = 0,
    IPERF_PARAM_IPADDR = 0,
    IPERF_PARAM_PORT = 'p',
};

void TestSocket(int argc, char* argv[])
{
    static char usage_info[] = "Run either a iperf server or iperf client.";
    static char program_info[] = "Lwip socket test task, a simple iperf.";
    static const char* const usages[] = {
        "TestIperf -c [--ip arg] [-p arg]",
        "TestIperf -s [-p arg]",
        NULL,
    };

    static struct IperfParam iperf_param = {
        .host = "255.255.255.255",
        .port = 5001,
    };

    enum IperfMode mode = 0;
    char* ip_ptr = NULL;
    bool is_help = false;
    struct argparse_option options[] = {
        OPT_HELP(&is_help),
        OPT_GROUP("Bit Options"),
        OPT_BIT(IPERF_PARAM_SERVER, "server", &mode, "start a iperf server", NULL, IPERF_MODE_SERVER, 0),
        OPT_BIT(IPERF_PARAM_CLIENT, "client", &mode, "start a iperf client", NULL, IPERF_MODE_CLIENT, 0),
        OPT_BIT(IPERF_PARAM_STOP, "stop", &mode, "stop iperf", NULL, IPERF_MODE_STOP, OPT_NONEG),
        OPT_GROUP("Param Options"),
        OPT_STRING(IPERF_PARAM_IPADDR, "ip", &ip_ptr, "server IP if iperf is a client", NULL, 0, 0),
        OPT_INTEGER(IPERF_PARAM_PORT, "port", &iperf_param.port, "server PORT needed for iperf", NULL, 0, 0),
        OPT_END(),
    };

    struct argparse argparse;
    argparse_init(&argparse, options, usages, 0);
    argparse_describe(&argparse, usage_info, program_info);
    argc = argparse_parse(&argparse, argc, (const char**)argv);
    /* help task */
    if (is_help) {
        return;
    }

    /* stop iperf task */
    if (mode & IPERF_MODE_STOP) {
        SetGlobalMode(IPERF_MODE_STOP);
        return;
    }
    if (mode & IPERF_MODE_SERVER && mode & IPERF_MODE_CLIENT) {
        printf("[%s] Err: Can't run iperf server and client at one time.\n", __func__);
    }

    /* iperf server or iperf client*/
    struct AtomicIperfMode* iperf_mode = GetGlobalIperfMode();
    PrivMutexObtain(&iperf_mode->mtx);
    if (iperf_mode->mode != IPERF_MODE_STOP) {
        PrivMutexAbandon(&iperf_mode->mtx);
        printf("[%s] Err: There is already a iperf running, please stop it before running a new one\n", __func__);
        return;
    }

    if (mode & IPERF_MODE_SERVER) {
        iperf_mode->mode = IPERF_MODE_SERVER;
    } else if (mode & IPERF_MODE_CLIENT) {
        if (ip_ptr == NONE) {
            PrivMutexAbandon(&iperf_mode->mtx);
            printf("[%s] Err: Iperf client must assign a server ip.\n", __func__);
            return;
        } else {
            memset(iperf_param.host, 0, sizeof(iperf_param.host));
            strncpy(iperf_param.host, ip_ptr, sizeof(iperf_param.host));
        }
        iperf_mode->mode = IPERF_MODE_CLIENT;
    }
    PrivMutexAbandon(&iperf_mode->mtx);

    pthread_t thd;
    mode = GetGlobalMode();
    if (mode == IPERF_MODE_SERVER) {
        printf("[%s] Running iperf server at port %d.\n", __func__, iperf_param.port);

#ifdef ADD_XIZI_FEATURES
        char task_name[] = "test_iperf_server";
        pthread_args_t args;
        args.pthread_name = task_name;
        args.arg = (void *)&iperf_param;
        PrivTaskCreate(&thd, NULL, TestIperfServer, (void*)&args);
#endif
    } else if (mode == IPERF_MODE_CLIENT) {
        printf("[%s] Running iperf client to server at %s:%d.\n", __func__, iperf_param.host, iperf_param.port);
#ifdef ADD_XIZI_FEATURES
        char task_name[] = "test_iperf_client";
        pthread_args_t args;
        args.pthread_name = task_name;
        args.arg = (void *)&iperf_param;
        PrivTaskCreate(&thd, NULL, TestIperfClient, (void*)&args);
#endif
    }

    PrivTaskStartup(&thd);
}

PRIV_SHELL_CMD_FUNCTION(TestSocket, Test socket using iperf, PRIV_SHELL_CMD_MAIN_ATTR | SHELL_CMD_PARAM_NUM(8));