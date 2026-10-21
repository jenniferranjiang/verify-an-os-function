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
 * File: $Id: portserial_m.c,v 1.60 2013/08/13 15:07:05 Armink add Master Functions $
 */

/**
* @file portserial_m.c
* @brief support freemodbus port for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-10-12
*/

/*************************************************
File name: portserial_m.c
Description: support freemodbus port for XiUOS
Others: 
History: 
1. Date: 2023-10-12
Author: AIIT XUOS Lab
Modification: 
1、support XiUOS serial for master.
*************************************************/

#include "port.h"

/* ----------------------- Modbus includes ----------------------------------*/
#include "mb.h"
#include "mbport.h"

#ifdef ADD_RTTHREAD_FEATURES
#include "rtdevice.h"
#include "board.h"
#endif

#if MB_MASTER_RTU_ENABLED > 0 || MB_MASTER_ASCII_ENABLED > 0
#ifdef ADD_RTTHREAD_FEATURES
/* ----------------------- Static variables ---------------------------------*/
/* software simulation serial transmit IRQ handler thread stack */
#ifdef rt_align
rt_align(RT_ALIGN_SIZE)
#else
ALIGN(RT_ALIGN_SIZE)
#endif
static rt_uint8_t serial_soft_trans_irq_stack[512];
/* software simulation serial transmit IRQ handler thread */
static struct rt_thread thread_serial_soft_trans_irq;
/* serial event */
static struct rt_event event_serial;
/* modbus master serial device */
static struct rt_serial_device *serial;

/* ----------------------- Defines ------------------------------------------*/
/* serial transmit event */
#define EVENT_SERIAL_TRANS_START    (1<<0)

/* ----------------------- static functions ---------------------------------*/
static void prvvUARTTxReadyISR(void);
static void prvvUARTRxISR(void);
static rt_err_t serial_rx_ind(rt_device_t dev, rt_size_t size);
static void serial_soft_trans_irq(void* parameter);

/* ----------------------- Start implementation -----------------------------*/
BOOL xMBMasterPortSerialInit(UCHAR ucPORT, ULONG ulBaudRate, UCHAR ucDataBits,
        eMBParity eParity)
{
    rt_device_t dev = RT_NULL;
    char uart_name[20];

    /**
     * set 485 mode receive and transmit control IO
     * @note MODBUS_MASTER_RT_CONTROL_PIN_INDEX need be defined by user
     */
#if defined(RT_MODBUS_MASTER_USE_CONTROL_PIN)
    rt_pin_mode(MODBUS_MASTER_RT_CONTROL_PIN_INDEX, PIN_MODE_OUTPUT);
#endif
    /* set serial name */
    rt_snprintf(uart_name,sizeof(uart_name), "uart%d", ucPORT);

    dev = rt_device_find(uart_name);
    if(dev == RT_NULL)
    {
        /* can not find uart */
        return FALSE;
    }
    else
    {
        serial = (struct rt_serial_device*)dev;
    }

    /* set serial configure parameter */
    serial->config.baud_rate = ulBaudRate;
    serial->config.stop_bits = STOP_BITS_1;
    switch(eParity){
    case MB_PAR_NONE: {
        serial->config.data_bits = DATA_BITS_8;
        serial->config.parity = PARITY_NONE;
        break;
    }
    case MB_PAR_ODD: {
        serial->config.data_bits = DATA_BITS_9;
        serial->config.parity = PARITY_ODD;
        break;
    }
    case MB_PAR_EVEN: {
        serial->config.data_bits = DATA_BITS_9;
        serial->config.parity = PARITY_EVEN;
        break;
    }
    }
    /* set serial configure */
    serial->ops->configure(serial, &(serial->config));

    /* open serial device */
    if (!rt_device_open(&serial->parent, RT_DEVICE_OFLAG_RDWR | RT_DEVICE_FLAG_INT_RX)) {
        rt_device_set_rx_indicate(&serial->parent, serial_rx_ind);
    } else {
        return FALSE;
    }

    /* software initialize */
    rt_event_init(&event_serial, "master event", RT_IPC_FLAG_PRIO);
    rt_thread_init(&thread_serial_soft_trans_irq,
                   "master trans",
                   serial_soft_trans_irq,
                   RT_NULL,
                   serial_soft_trans_irq_stack,
                   sizeof(serial_soft_trans_irq_stack),
                   10, 5);
    rt_thread_startup(&thread_serial_soft_trans_irq);

    return TRUE;
}

void vMBMasterPortSerialEnable(BOOL xRxEnable, BOOL xTxEnable)
{
    rt_uint32_t recved_event;
    if (xRxEnable)
    {
        /* enable RX interrupt */
        serial->ops->control(serial, RT_DEVICE_CTRL_SET_INT, (void *)RT_DEVICE_FLAG_INT_RX);
        /* switch 485 to receive mode */
#if defined(RT_MODBUS_MASTER_USE_CONTROL_PIN)
        rt_pin_write(MODBUS_MASTER_RT_CONTROL_PIN_INDEX, PIN_LOW);
#endif
    }
    else
    {
        /* switch 485 to transmit mode */
#if defined(RT_MODBUS_MASTER_USE_CONTROL_PIN)
        rt_pin_write(MODBUS_MASTER_RT_CONTROL_PIN_INDEX, PIN_HIGH);
#endif
        /* disable RX interrupt */
        serial->ops->control(serial, RT_DEVICE_CTRL_CLR_INT, (void *)RT_DEVICE_FLAG_INT_RX);
    }
    if (xTxEnable)
    {
        /* start serial transmit */
        rt_event_send(&event_serial, EVENT_SERIAL_TRANS_START);
    }
    else
    {
        /* stop serial transmit */
        rt_event_recv(&event_serial, EVENT_SERIAL_TRANS_START,
                RT_EVENT_FLAG_OR | RT_EVENT_FLAG_CLEAR, 0,
                &recved_event);
    }
}

void vMBMasterPortClose(void)
{
    serial->parent.close(&(serial->parent));
}

BOOL xMBMasterPortSerialPutByte(CHAR ucByte)
{
    serial->parent.write(&(serial->parent), 0, &ucByte, 1);
    return TRUE;
}

BOOL xMBMasterPortSerialGetByte(CHAR * pucByte)
{
    serial->parent.read(&(serial->parent), 0, pucByte, 1);
    return TRUE;
}

/*
 * Create an interrupt handler for the transmit buffer empty interrupt
 * (or an equivalent) for your target processor. This function should then
 * call pxMBFrameCBTransmitterEmpty( ) which tells the protocol stack that
 * a new character can be sent. The protocol stack will then call
 * xMBPortSerialPutByte( ) to send the character.
 */
void prvvUARTTxReadyISR(void)
{
    pxMBMasterFrameCBTransmitterEmpty();
}

/*
 * Create an interrupt handler for the receive interrupt for your target
 * processor. This function should then call pxMBFrameCBByteReceived( ). The
 * protocol stack will then call xMBPortSerialGetByte( ) to retrieve the
 * character.
 */
void prvvUARTRxISR(void)
{
    pxMBMasterFrameCBByteReceived();
}

/**
 * Software simulation serial transmit IRQ handler.
 *
 * @param parameter parameter
 */
static void serial_soft_trans_irq(void* parameter) {
    rt_uint32_t recved_event;
    while (1)
    {
        /* waiting for serial transmit start */
        rt_event_recv(&event_serial, EVENT_SERIAL_TRANS_START, RT_EVENT_FLAG_OR,
                RT_WAITING_FOREVER, &recved_event);
        /* execute modbus callback */
        prvvUARTTxReadyISR();
    }
}

/**
 * This function is serial receive callback function
 *
 * @param dev the device of serial
 * @param size the data size that receive
 *
 * @return return RT_EOK
 */
static rt_err_t serial_rx_ind(rt_device_t dev, rt_size_t size) {
    prvvUARTRxISR();
    return RT_EOK;
}

#endif

#ifdef ADD_XIZI_FEATURES
/* ----------------------- Static variables ---------------------------------*/
/* software simulation serial transmit IRQ handler thread */
static pthread_t thread_serial_soft_trans_irq;
static pthread_t thread_serial_recv_irq;
/* serial event */
static int event_serial;
/* modbus master serial device */
static int pin_fd = 0;
static int uart_fd = 0;

/* ----------------------- Defines ------------------------------------------*/
/* serial transmit event */
#define EVENT_SERIAL_TRANS_START    (1<<0)
#define RTU_RECV_DATA_LENGTH 8

/* ----------------------- static functions ---------------------------------*/
static void prvvUARTTxReadyISR(void);
static void prvvUARTRxISR(CHAR pucByte);

static void *serial_soft_trans_irq(void* parameter);
static void *serial_recv_irq(void* parameter);

/* ----------------------- Start implementation -----------------------------*/
BOOL xMBMasterPortSerialInit(UCHAR ucPORT, ULONG ulBaudRate, UCHAR ucDataBits,
        eMBParity eParity)
{
    int ret = 0;
    uint32_t baud_rate; 
    uint8_t data_bits, parity;
    
    baud_rate = ulBaudRate; 
    data_bits = ucDataBits;
    /* set serial configure parameter */
    switch(eParity){
        case MB_PAR_NONE: {
            parity = PARITY_NONE;
            break;
        }
        case MB_PAR_ODD: {
            parity = PARITY_ODD;
            break;
        }
        case MB_PAR_EVEN: {
            parity = PARITY_EVEN;
            break;
        }
    }
    
    pin_fd = PrivOpen(CONNECTION_MODBUS_RTU_PIN_DEV, O_RDWR);
    if (pin_fd < 0) {
        printf("open %s error\n", CONNECTION_MODBUS_RTU_PIN_DEV);
        return FALSE;
    }

    struct PinParam pin_param;
    pin_param.cmd = GPIO_CONFIG_MODE;
    pin_param.mode = GPIO_CFG_OUTPUT;
    pin_param.pin = CONNECTION_MODBUS_RTU_UART_485_DIR;

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = PIN_TYPE;
    ioctl_cfg.args = &pin_param;
    PrivIoctl(pin_fd, OPE_CFG, &ioctl_cfg);

    uart_fd = PrivOpen(CONNECTION_MODBUS_RTU_UART_DEV, O_RDWR);
    if (uart_fd < 0) {
        printf("open fd error %d\n", uart_fd);
        return FALSE;
    }
    printf("%s open fd %d baud_rate %d data_bits %d check_mode %d\n", 
        __func__, uart_fd, baud_rate, data_bits, parity);

    struct SerialDataCfg cfg;
    cfg.serial_baud_rate = baud_rate;
    cfg.serial_data_bits = data_bits;
    cfg.serial_stop_bits = STOP_BITS_1;
    cfg.serial_buffer_size = 128;
    cfg.serial_parity_mode = parity;
    cfg.serial_bit_order = 1;
    cfg.serial_invert_mode = 1;
#ifdef CONNECTION_MODBUS_RTU_EXTUART
    cfg.ext_uart_no = 0;
    cfg.port_configure = PORT_CFG_INIT;
#endif
    cfg.serial_timeout = -1;
    cfg.dev_recv_callback = NULL;

    ioctl_cfg.ioctl_driver_type = SERIAL_TYPE;
    ioctl_cfg.args = &cfg;
    ret = PrivIoctl(uart_fd, OPE_INT, &ioctl_cfg);
    if (0 != ret) {
        printf("ioctl fd error %d\n", ret);
        return FALSE;
    }

    printf("%s serial init done!\n", __func__);

    /* software initialize */
    event_serial = PrivEventCreate(LINKLIST_FLAG_PRIO);

    pthread_attr_t attr;
    attr.schedparam.sched_priority = 21;
    attr.stacksize = 2048;

    char task1_name[] = "master_trans";
    pthread_args_t args;
    args.pthread_name = task1_name;

    PrivTaskCreate(&thread_serial_soft_trans_irq, &attr, &serial_soft_trans_irq, (void *)&args);
    PrivTaskStartup(&thread_serial_soft_trans_irq);

    attr.schedparam.sched_priority = 22;
    attr.stacksize = 2048;

    char task2_name[] = "master_recv";
    args.pthread_name = task2_name;

    PrivTaskCreate(&thread_serial_recv_irq, &attr, &serial_recv_irq, (void *)&args);
    PrivTaskStartup(&thread_serial_recv_irq);

    return TRUE;
}

/**
 * @description: Set Uart 485 Input
 * @return 
 */
static void Set485Input(void)
{
    PrivTaskDelay(15);
    
    struct PinStat pin_stat;
    pin_stat.pin = CONNECTION_MODBUS_RTU_UART_485_DIR;
    pin_stat.val = GPIO_LOW;
    PrivWrite(pin_fd, &pin_stat, 1);
}

/**
 * @description: Set Uart 485 Output
 * @return
 */
static void Set485Output(void)
{
    struct PinStat pin_stat;
    pin_stat.pin = CONNECTION_MODBUS_RTU_UART_485_DIR;
    pin_stat.val = GPIO_HIGH;
    PrivWrite(pin_fd, &pin_stat, 1);

    PrivTaskDelay(20);
}

void vMBMasterPortSerialEnable(BOOL xRxEnable, BOOL xTxEnable)
{
    unsigned int recved_event;
    if (xRxEnable) {
        /* switch 485 to receive mode */
        Set485Input();
    } else {
        /* switch 485 to transmit mode */
        Set485Output();
    }
    if (xTxEnable) {
        /* start serial transmit */
        PrivEvenTrigger(event_serial, EVENT_SERIAL_TRANS_START);
    } else {
        /* stop serial transmit */
        PrivEventProcess(event_serial, EVENT_SERIAL_TRANS_START, EVENT_OR | EVENT_AUTOCLEAN, 0, &recved_event);
    }
}

void vMBMasterPortClose(void)
{

}

BOOL xMBMasterPortSerialPutByte(CHAR ucByte)
{
    PrivWrite(uart_fd, &ucByte, 1);
    return TRUE;
}

BOOL xMBMasterPortSerialGetByte(CHAR * pucByte)
{
    PrivRead(uart_fd, pucByte, 1);

    PrivTaskDelay(30);

    return TRUE;
}

/*
 * Create an interrupt handler for the transmit buffer empty interrupt
 * (or an equivalent) for your target processor. This function should then
 * call pxMBFrameCBTransmitterEmpty( ) which tells the protocol stack that
 * a new character can be sent. The protocol stack will then call
 * xMBPortSerialPutByte( ) to send the character.
 */
void prvvUARTTxReadyISR(void)
{
    pxMBMasterFrameCBTransmitterEmpty();
}

/*
 * Create an interrupt handler for the receive interrupt for your target
 * processor. This function should then call pxMBFrameCBByteReceived( ). The
 * protocol stack will then call xMBPortSerialGetByte( ) to retrieve the
 * character.
 */
void prvvUARTRxISR(CHAR pucByte)
{
    pxMBMasterFrameCBByteReceived(pucByte);
}

/**
 * Software simulation serial transmit IRQ handler.
 *
 * @param parameter parameter
 */
static void *serial_soft_trans_irq(void* parameter) {
    unsigned int recved_event;
    while (1) {
        /* waiting for serial transmit start */
        if (0 == PrivEventProcess(event_serial, EVENT_SERIAL_TRANS_START, EVENT_OR, 0, &recved_event)) {
            /* execute modbus callback */
            prvvUARTTxReadyISR();
        }
    }
}

/**
 * Software simulation serial receive data IRQ handler.
 *
 * @param parameter parameter
 */
static void *serial_recv_irq(void* parameter) {
    int i;
    int data_size = 0;
    int data_recv_size = 0;
    char recv_data[RTU_RECV_DATA_LENGTH] = {0};
    
    while (1) {
        while (data_size < RTU_RECV_DATA_LENGTH) {
            data_recv_size = PrivRead(uart_fd, recv_data + data_size, RTU_RECV_DATA_LENGTH - data_size);
            data_size += data_recv_size;
        }
        /* execute modbus recv callback */
        for (i = 0; i < RTU_RECV_DATA_LENGTH; i ++) {
            prvvUARTRxISR(recv_data[i]);
        }
        data_size = 0;
        data_recv_size = 0;
    }
}

#endif

#endif
