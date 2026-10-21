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
 * @file ab_l30.c
 * @brief PLC ABB L30 app
 * @version 3.0
 * @author AIIT XUOS Lab
 * @date 2023.8.27
 */

#include <control.h>

void ControlABL30Test(void)
{
    int i = 0;
    uint16_t read_data_length = 0;
    uint8_t read_data[1024] = {0};
    ControlProtocolType CIP_protocol = ControlProtocolFind();
    if (NULL == CIP_protocol) {
        printf("%s get CIP protocol %p failed\n", __func__, CIP_protocol);
        return;
    }

    printf("%s get CIP protocol %p successfull\n", __func__, CIP_protocol);
    if (CONTROL_REGISTERED == CIP_protocol->protocol_status) {
        ControlProtocolOpen(CIP_protocol);

        for (;;) {
            read_data_length = ControlProtocolRead(CIP_protocol, read_data, sizeof(read_data));
            printf("%s read [%d] CIP data %d using receipe file\n", __func__, i, read_data_length);
            i++;
            PrivTaskDelay(1000);
        }

        //ControlProtocolClose(CIP_protocol);
    }
}
PRIV_SHELL_CMD_FUNCTION(ControlABL30Test, Ab Plc CIP Demo, PRIV_SHELL_CMD_MAIN_ATTR);
