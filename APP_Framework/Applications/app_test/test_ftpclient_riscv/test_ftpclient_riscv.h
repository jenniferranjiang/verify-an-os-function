#include <transform.h>
#include <socket.h>
#include <stdio.h>
#include <stdlib.h>

int SendCommand(char *cmd);
int RecvRespond(char * respond,int len);
int EnterPasv(uint8_t *ipaddr,int *port);
int Login(uint8_t addr[4],int port,char *username,char *password);
int GetFileSize(char * name);
int Download(char *name);
void Init();
void Quit();
int TestFtp();