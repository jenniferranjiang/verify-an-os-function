/*
 * FreeModbus Libary: RT-Thread Port
 * Copyright (C) 2013 Armink <armink.ztl@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * File: $Id: portevent.c,v 1.60 2013/08/13 15:07:05 Armink $
 */

/**
* @file portevent.c
* @brief support freemodbus port for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-10-12
*/

/*************************************************
File name: portevent.c
Description: support freemodbus port for XiUOS
Others: 
History: 
1. Date: 2023-10-12
Author: AIIT XUOS Lab
Modification: 
1、support XiUOS event for slave.
*************************************************/

/* ----------------------- Modbus includes ----------------------------------*/
#include "mb.h"
#include "mbport.h"

#ifdef ADD_RTTHREAD_FEATURES
/* ----------------------- Variables ----------------------------------------*/
static struct rt_event     xSlaveOsEvent;
/* ----------------------- Start implementation -----------------------------*/
BOOL
xMBPortEventInit( void )
{
    rt_event_init(&xSlaveOsEvent,"slave event",RT_IPC_FLAG_PRIO);
    return TRUE;
}

BOOL
xMBPortEventPost( eMBEventType eEvent )
{
    rt_event_send(&xSlaveOsEvent, eEvent);
    return TRUE;
}

BOOL
xMBPortEventGet( eMBEventType * eEvent )
{
    rt_uint32_t recvedEvent;
    /* waiting forever OS event */
    rt_event_recv(&xSlaveOsEvent,
            EV_READY | EV_FRAME_RECEIVED | EV_EXECUTE | EV_FRAME_SENT,
            RT_EVENT_FLAG_OR | RT_EVENT_FLAG_CLEAR, RT_WAITING_FOREVER,
            &recvedEvent);
    switch (recvedEvent)
    {
    case EV_READY:
        *eEvent = EV_READY;
        break;
    case EV_FRAME_RECEIVED:
        *eEvent = EV_FRAME_RECEIVED;
        break;
    case EV_EXECUTE:
        *eEvent = EV_EXECUTE;
        break;
    case EV_FRAME_SENT:
        *eEvent = EV_FRAME_SENT;
        break;
    }
    return TRUE;
}
#endif

#ifdef ADD_XIZI_FEATURES
/* ----------------------- Variables ----------------------------------------*/
static int     xSlaveOsEvent;
/* ----------------------- Start implementation -----------------------------*/
BOOL
xMBPortEventInit( void )
{
    xSlaveOsEvent = PrivEventCreate(LINKLIST_FLAG_PRIO);
    return TRUE;
}

BOOL
xMBPortEventPost( eMBEventType eEvent )
{
    PrivEvenTrigger(xSlaveOsEvent, eEvent);
    return TRUE;
}

BOOL
xMBPortEventGet( eMBEventType * eEvent )
{
    unsigned int recvedEvent;

    /* waiting forever OS event */
    PrivEventProcess(xSlaveOsEvent, 
        EV_READY | EV_FRAME_RECEIVED | EV_EXECUTE | EV_FRAME_SENT,
        EVENT_OR | EVENT_AUTOCLEAN, 0, &recvedEvent);

    switch (recvedEvent)
    {
    case EV_READY:
        *eEvent = EV_READY;
        break;
    case EV_FRAME_RECEIVED:
        *eEvent = EV_FRAME_RECEIVED;
        break;
    case EV_EXECUTE:
        *eEvent = EV_EXECUTE;
        break;
    case EV_FRAME_SENT:
        *eEvent = EV_FRAME_SENT;
        break;
    }
    return TRUE;
}
#endif
