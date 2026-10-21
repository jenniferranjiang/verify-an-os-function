# 决赛一级赛题3：基于初赛一级赛题3，在云服务器上实现FTP Server功能

## 1. 简介
本项目是基于赛事提供的云服务器，实现FTP协议的Server功能，其功能支持至少10个Client端并发向Server端传输4KB大小的文件，
支持Server端并发地向至少10个Client端传输4KB大小的文件。
test_ftpclient_final.h声明了多个客户端并发下载文件、并发上传文件的测试函数
test_ftpclient_final.c实现了多个客户端并发下载文件、并发上传文件的测试函数
ftp_client文件夹定义了ftp_client的相关类库其中my_socket.h,my_socket.c定义了socket抽象层，并基于
Lwip实现了该抽象层，ftp_client.h,ftp_client.c实现了ftp登录，获取文件大小，下载文件等功能
注意:在赛事提供的云服务器/root/yanglongFTP上有对应服务器代码 ./server运行服务器，为了方便查看代码我们讲服务器代码备份存放在ftp_server目录下
## 2. 数据结构设计说明
- ftp_client.c 的设计
分别定义了发送命令和接收数据的socket和相应的缓冲区并且实现了登录、发送命令、接收响应数据、查找文件大小、进入被动模式、下载文件、关闭ftp客户端等操作
```c
static int  m_socket_cmd[THREAD_NUM]; // 发送命令的socket文件描述符,THREAD_NUM表示线程数目，用来模拟多个客户端并发访问
static int  m_socket_data[THREAD_NUM]; // 接收ftp服务器文件的socket文件描述符
static char m_send_buffer[THREAD_NUM][1024]; // 发送缓冲区
static char m_recv_buffer[THREAD_NUM][1024]; // 接收缓冲区
```
- server.c 的设计(具体代码在赛事提供的云服务器的/root/yanglongFTP下)
```c
#define THREAD_NUM 10000 // thread num
static int isBinary = 0; // transmit binary data
static int port = 9992; // service port
static int dataPort = 9993; // the port for file download
static char order[4]; // receive order
static char param[20]; // receive order param
static char *respMessage; // respose message
static int serverFd;  // the server fd for deal with order requests
static int dataServerFd; // the server fd for file download
sem_t mutex; // mutex lock
struct Data{ // 线程间通信传输的数据
    char fileName[20]; // file name
    int type; // 0:download 1:upload
    sem_t isDone;  // complete file downlaod
    sem_t isReady;  // 文件准备好了
} data;
```
## 3. 测试程序说明
- test_ftpclient_final.c用于测试多个客户端并发下载文件
通过多线程模拟多个客户端并发访问服务器，通过 TestFtpClient options threads进行测试
其中options=1表示下载options=2表示上传，threads表示线程数/模拟的并发客户端数目
```c
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
```

## 4. 运行结果（##需结合运行测试截图按步骤说明##）
1. 配置开启BSP_USING_LWIP、USER_TEST_FTPCLIENT
![](./img/image.png)
![](./img/image-1.png)
![](./img/image-2.png)
2. 编译
![](./img/image-3.png)
3. 烧写
![](./img/image-4.png)
4. xshell连接串口终端并配置ip
![](./img/image-5.png)
5. 通过./server在云服务器运行FTP服务器
![](./img/image-6.png)
6. 运行TestFtpClient 1 10，模拟10个客户端并发下载文件
- 客户端日志
![](./img/image-7.png)
![](./img/image-8.png)
![](./img/image-9.png)
![](./img/image-10.png)
![](./img/image-11.png)
![](./img/image-12.png)
![](./img/image-13.png)
![](./img/image-14.png)
![](./img/image-15.png)
![](./img/image-16.png)
- 服务器日志
![](./img/image-17.png)
![](./img/image-18.png)
![](./img/image-19.png)
![](./img/image-20.png)
![](./img/image-21.png)
7. 运行TestFtpClient 2 10，模拟10个客户端并发上传文件
- 客户端日志
![](./img/image-22.png)
![](./img/image-23.png)
![](./img/image-24.png)
![](./img/image-25.png)
![](./img/image-26.png)
![](./img/image-27.png)
![](./img/image-28.png)
- 服务器日志
![](./img/image-29.png)
![](./img/image-30.png)
![](./img/image-31.png)
![](./img/image-32.png)
- 上传结果
![](./img/image-33.png)
8. 运行TestFtpClient 3 10，模拟10个客户端混合并发下载和上传文件
- 客户端日志
![](./img/image-34.png)
![](./img/image-35.png)
![](./img/image-36.png)
![](./img/image-37.png)
![](./img/image-38.png)
![](./img/image-39.png)

- 服务器日志
![](./img/image-40.png)
![](./img/image-41.png)
![](./img/image-42.png)

- 下载和上传结果
![](./img/image-43.png)
![](./img/image-44.png)