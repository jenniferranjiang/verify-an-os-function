/*
 * Copyright (c) 2022 AIIT XUOS Lab
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
 * @file CIP.c
 * @brief plc protocol CIP Ethernet/IP
 * @version 3.0
 * @author AIIT XUOS Lab
 * @date 2023-4-14
 */
#pragma warning(disable : 4996)
#include <cip.h>
#include "ab_cip.h"


CIPReadItem CIP_read_item[1024] = {0};

/**
 * @description: S7 Receive Plc Data Task
 * @param parameter - parameter pointer
 * @return
 */
void *ReceivePlcDataTask(void *parameter)
{
    struct ControlProtocol *control_protocol = (struct ControlProtocol *)parameter; 
    ReadPlcDataByRecipe(control_protocol->recipe);
}

/**
 * @description: S7 Protocol Open
 * @param control_protocol - control protocol pointer
 * @return success : 0 error
 */
int CIPOpen(struct ControlProtocol *control_protocol)
{
    ControlProtocolOpenDef(control_protocol);
    return 0;
}

/**
 * @description: S7 Protocol Close
 * @param control_protocol - control protocol pointer
 * @return success : 0 error
 */
int CIPClose(struct ControlProtocol *control_protocol)
{    
    ControlProtocolCloseDef();
    return 0;
}

/**
 * @description: S7 Protocol Read Data
 * @param control_protocol - control protocol pointer
 * @param buf - read data buffer pointer
 * @param len - read data length
 * @return success : data length error : 0
 */
int CIPRead(struct ControlProtocol *control_protocol, void *buf, size_t len)
{
    struct CircularAreaApp *circular_area = (struct CircularAreaApp *)control_protocol->args;
    return CircularAreaAppRead(circular_area, buf, len);
}

static struct ControlDone CIP_protocol_done = 
{
    ._open = CIPOpen,
    ._close = CIPClose,
    ._read = CIPRead,
    ._write = NULL,
    ._ioctl = NULL,
};

/**
 * @description: Push Data Onto a Stack One By One
 * @param datastack - data stack pointer
 * @param args - data pointer
 * @param length - data length
 * @return 
 */
void PushDataIntoStack(uint8_t *datastack,uint8_t* args,uint16_t length)
{
    static int index = 8;    
    for(int i =0; i < length; i ++) {
        datastack[index] = args[i];
        index++;
        if(index >= control_protocol->recipe->protocol_data.data_length){
            index = 8;
        }     
    }
}

#define GET_RESULT(ret)    \
	{                      \
		if (ret != 0)      \
			faild_count++; \
	}

/**
 * @description: Read PLC Data By Recipe
 * @param p_recipe - recipe pointer
 * @return success : 0 error : -1
 */
int8_t ReadPlcDataByRecipe(struct ControlRecipe *p_recipe)
{   
    static BasicSocketPlc plc_socket = {0};
    uint16_t data_length = control_protocol->recipe->protocol_data.data_length;
    uint8_t *CIP_data = control_protocol->recipe->protocol_data.data;
    struct CircularAreaApp *circular_area = (struct CircularAreaApp *)control_protocol->args;
    memset(&plc_socket, 0, sizeof(BasicSocketPlc));
    char plc_ip_string[15] = {0};
    sprintf(plc_ip_string, "%u.%u.%u.%u",
        p_recipe->socket_config.plc_ip[0],
        p_recipe->socket_config.plc_ip[1],
        p_recipe->socket_config.plc_ip[2],
        p_recipe->socket_config.plc_ip[3]);
    char *plc_ip = plc_ip_string;
    plc_socket.port = control_protocol->recipe->socket_config.port;
    int fd = -1;
	int slot = 0;
	bool ret_con = ab_cip_connect(plc_ip, plc_socket.port, 0, &fd);
    cip_error_code_e ret = CIP_ERROR_CODE_FAILED;
    int faild_count = 0;
    char address[50] = {0};
    int i = 0;
    uint8_t val[8] = {0} ;
    bool all_success = false;
    bool b_val = true;
    short s_val = 0;
    ushort us_val = 0;
    int i_val = 0;
    uint32 ui_val = 0;
    float f_val = 0;
    double d_val = 0;
    while (1){
        if (ret_con || fd > 0)
        {
            faild_count = 0;
            for (i = 0; i < p_recipe->read_item_count; i++)
            {  
                printf("==============Test count: %d==============\n", i + 1);
                strcpy(address, CIP_read_item[i].value_name);
                switch (CIP_read_item[i].value_type)
                {
                case 1:
                    ////////////////////////////////////////////////////////////////////////// 
                    // strcpy(address, CIP_read_item[i].value_name);//
                    // ret = ab_cip_write_bool(fd, address, val);
                    // printf("Write\t %s \tbool:\t %d, \tret: %d\n", address, val, ret);
                    // GET_RESULT(ret);

                    b_val = false;
                    ret = ab_cip_read_bool(fd, address, &b_val);
                    // printf("Read\t %s \tbool:\t %d\n", address, b_val);
                    GET_RESULT(ret);
                    memcpy(val,&b_val,sizeof(b_val));
                    PushDataIntoStack(CIP_data,val,1);
                    break;  

                case 3:
                    //////////////////////////////////////////////////////////////////////////
                    // short w_s_val = 23;
                    // strcpy(address, CIP_read_item[i].value_name);
                    // ret = ab_cip_write_short(fd, address, w_s_val);
                    // printf("Write\t %s \tshort:\t %d, \tret: %d\n", address, w_s_val, ret);
                    // GET_RESULT(ret);

                    s_val = 0;
                    ret = ab_cip_read_short(fd, address, &s_val);
                    printf("Read\t %s \tshort:\t %d\n", address, s_val);
                    GET_RESULT(ret); 
                    memcpy(val,&s_val,sizeof(s_val));
                    PushDataIntoStack(CIP_data,val,2);
                    break;

                case 4:
                    //////////////////////////////////////////////////////////////////////////
                    // int32 w_i_val = 12345;
                    strcpy(address, CIP_read_item[i].value_name);
                    // ret = ab_cip_write_int32(fd, address, w_i_val);
                    // printf("Write\t %s \tint32:\t %d, \tret: %d\n", address, w_i_val, ret);
                    // GET_RESULT(ret);

                    i_val = 0;
                    ret = ab_cip_read_int32(fd, address, &i_val);
                    // printf("Read\t %s \tint32:\t %d\n", address, i_val);
                    GET_RESULT(ret);
                    memcpy(val,&i_val,sizeof(s_val));
                    PushDataIntoStack(CIP_data,val,2);
                    break;
                
                case 6:
                    //////////////////////////////////////////////////////////////////////////
                    // ushort w_us_val = 22;
                    strcpy(address, CIP_read_item[i].value_name);
                    // ret = ab_cip_write_ushort(fd, address, w_us_val);
                    // printf("Write\t %s \tushort:\t %d, \tret: %d\n", address, w_us_val, ret);
                    // GET_RESULT(ret);

                    us_val = 0;
                    ret = ab_cip_read_ushort(fd, address, &us_val);
                    // printf("Read\t %s \tushort:\t %d\n", address, us_val);
                    GET_RESULT(ret);
                    memcpy(val,&us_val,sizeof(us_val));
                    PushDataIntoStack(CIP_data,val,1);
                    break;

                case 7:
                    // //////////////////////////////////////////////////////////////////////////
                    // uint32 w_ui_val = 22345;
                    strcpy(address, CIP_read_item[i].value_name);
                    // ret = ab_cip_write_uint32(fd, address, w_ui_val);
                    // printf("Write\t %s \tuint32:\t %d, \tret: %d\n", address, w_ui_val, ret);
                    // GET_RESULT(ret);
    
                    ui_val = 0;
                    ret = ab_cip_read_uint32(fd, address, &ui_val);
                    // printf("Read\t %s \tuint32:\t %d\n", address, ui_val);
                    GET_RESULT(ret);
                    memcpy(val,&ui_val,sizeof(us_val));
                    PushDataIntoStack(CIP_data,val,1);
                    break;

                case 8:
                    ////////////////////////////////////////////////////////////////////////
                    // double w_d_val = 12345.6789;
                    strcpy(address, CIP_read_item[i].value_name);
                    // ret = ab_cip_write_double(fd, address, w_d_val);
                    // printf("Write\t %s \tdouble:\t %lf, \tret: %d\n", address, w_d_val, ret);
                    // GET_RESULT(ret);

                    d_val = 0.0;
                    ret = ab_cip_read_double(fd, address, &d_val);
                    // printf("Read\t %s \tdouble:\t %lf\n", address, d_val);
                    GET_RESULT(ret);
                    memcpy(val,&d_val,sizeof(us_val));
                    PushDataIntoStack(CIP_data,val,1);
                    break;

                case 9:
                    //////////////////////////////////////////////////////////////////////////
                    // float w_f_val = 32.454f;
                    // strcpy(address, CIP_read_item[i].value_name);
                    // ret = ab_cip_write_float(fd, address, w_f_val);
                    // printf("Write\t %s \tfloat:\t %f, \tret: %d\n", address, w_f_val, ret);
                    // GET_RESULT(ret);

                    f_val = 0.0;
                    ret = ab_cip_read_float(fd, address, &f_val);
                    printf("Read\t %s \tfloat:\t %f\n", address, f_val);
                    GET_RESULT(ret);
                    memcpy(val,&f_val,sizeof(us_val));
                    PushDataIntoStack(CIP_data,val,4);               
                    break;

                default:
                    printf("value type no found!\n");
                    break;
                }
                // ControlPrintfList("CIP RECV", CIP_data, data_length);
            }      
            printf("All Failed count: %d\n", faild_count);
            if(faild_count != 0)
            {         
                ab_cip_disconnect(fd);
                printf("get value failed!\n");
                break;
            }
            /*read all variable item data, put them into circular_area*/
            printf("%s get %d item %d length\n", __func__, i, data_length);
            CircularAreaAppWrite(circular_area, CIP_data, data_length, 0);
            PrivTaskDelay(100);
        }
    }    
    return ret; 
}

/**
 * @description: CIP Protocol Cmd Generate
 * @param p_recipe - recipe pointer
 * @param protocol_format_info - protocol format info pointer
 * @return success : 0 error : -1
 */
int CIPProtocolFormatCmd(struct ControlRecipe *p_recipe, ProtocolFormatInfo *protocol_format_info)
{
    int ret = 0;
    int i = protocol_format_info->read_item_index;
    // CIPReadItem *CIP_read_item = (CIPReadItem *)p_recipe->read_item; 
    CIP_read_item[i].value_type = cJSON_GetObjectItem(protocol_format_info->read_single_item_json, "value_type")->valueint;
    strncpy(CIP_read_item[i].value_name, cJSON_GetObjectItem(protocol_format_info->read_single_item_json, "value_name")->valuestring, 20);    
    
    return ret;
}
/**
 * @description: CIP Protocol Init
 * @param p_recipe - recipe pointer
 * @return success : 0 error : -1
 */
int CipProtocolInit(struct ControlRecipe *p_recipe)
{   
    p_recipe->read_item = PrivMalloc(sizeof(CIPReadItem) * p_recipe->read_item_count);
    if (NULL == p_recipe->read_item) {
        PrivFree(p_recipe->read_item);
        return -1;
    }
    memset(p_recipe->read_item, 0, sizeof(CIPReadItem));
    p_recipe->ControlProtocolFormatCmd = CIPProtocolFormatCmd;
    p_recipe->done = &CIP_protocol_done;
    return 0;
}
