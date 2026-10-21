# AB_L30ERM通信测试

[TOC]

## 通信接线及参数设置

* 网口

  *Ethernet/ip协议，IP：192.168.250.57，Port：44818

## 存储区

- Ethernet/ip协议是根据变量名称搜索寄存器地址

## JSON配方设计

* 本实例共测试Word和real共2种类型数据，以下为JSON文件解释。

  - ```json
    {
        "device_id": “ab_l30”,              //
        "device_name": "robot",            //设备名称，自定义
        "communication_type": 0,            //通讯协议类型 0是以太网，1是串口 
        "socket_config": {                  //以太网配置
            "plc_ip": "192.168.250.37",     //PLC的IP地址
            "local_ip": "192.168.250.123",   //矽达通IP地址设定
            "gateway": "192.168.250.1",     //矽达通的网关地址设定
            "netmask": "255.255.255.0",     //矽达通子网掩码设定
            "port":502                      //端口号设定
            },
        "protocol_type": 12,                 //通讯协议，12代表ethernet/ip协议
        "read_period": 100,                 //交互周期ms
        "read_item_list": [
            {
                "value_name": "L30_SPEED",  //变量名称，自定义
                "value_type": 3,      //变量类型，BOOL = 1,INT8 = 2,INT16,INT32,UINT8,UINT16,UINT32,DOUBLE,FLOAT = 9
            	"wordlen": "WORD",    //以WORD方式传输
                "amount": 1           //默认是1，代表读取1个数据类型长度
            },
            {
                "value_name": "L30_TORQUE",  //变量名称，自定义
                "value_type": 9,      //变量类型，BOOL = 1,INT8 = 2,INT16,INT32,UINT8,UINT16,UINT32,DOUBLE,FLOAT = 9
            	"wordlen": 2,        //以WORD方式传输
                "amount": 1          //默认是1，代表读取1个数据类型长度
            },
            {
                "value_name": "D",     //变量名称，自定义
                "value_type": 3,      //变量类型，BOOL = 1,INT8 = 2,INT16,INT32,UINT8,UINT16,UINT32,DOUBLE,FLOAT = 9
            	"wordlen": 3,         //以WORD方式传输
                "amount": 1           //默认是1，代表读取1个数据类型长度
            }
        ]
    }
    ```
  

## 通信测试

 (1) 新增1个通信demo，命名为ab_l30erm.c；

 (2) 复制modbus_tcp样例代码程序到ab_l30erm.c文件中；

 (3) void **ControlABL30Test**(void) 更改函数名；

 (4) PRIV_SHELL_CMD_FUNCTION(**ControlABL30Test**, AB Plc l30ermDemo**, PRIV_SHELL_CMD_MAIN_ATTR);更改测试指令；

 (5) 剪裁配置完成后，用过烧写器下载至矽数通中，重启后完成测试。



 
