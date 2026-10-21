/*!
 * \file      lora-spi-SX126x.c
 *
 * \brief     spi driver implementation for SX126X
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * \author    Forest-Rain
 * 
 * \author    AIIT XUOS Lab
 */
 
/**
* @file lora-spi-SX126x.c
* @brief support lora-radio-driver for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-03-13
*/

/*************************************************
File name: lora-spi-SX126x.c
Description: support lora-radio-driver for XiUOS
Others: 
History: 
1. Date: 2023-03-13
Author: AIIT XUOS Lab
Modification: 
1、add LORA_RADIO_DRIVER_USING_RTOS_XIUOS to support XiUOS.
*************************************************/

#include <sx126x-board.h>

#define LOG_TAG "LoRa.SX126X.SPI"
#define LOG_LEVEL  LOG_LVL_DBG 
#include <lora-radio-debug.h>

void SX126xWakeup( void )
{
#ifdef LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD
#ifdef RT_USING_SPI
    uint8_t msg[2] = { RADIO_GET_STATUS, 0x00 };
    
    rt_spi_transfer(SX126x.spi,msg,RT_NULL,2);
    
    // Wait for chip to be ready.
    SX126xWaitOnBusy( );
    
    // Update operating mode context variable
    SX126xSetOperatingMode( MODE_STDBY_RC );
#endif
#endif
    
#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    int spi_fd;
    uint8_t msg[2] = { RADIO_GET_STATUS, 0x00 };
    
    spi_fd = PrivOpen(LORA_SPI_DEV_NAME, O_RDWR);

    PrivWrite(spi_fd, msg, 2);

    PrivClose(spi_fd);
    
    // Wait for chip to be ready.
    SX126xWaitOnBusy( );
    
    // Update operating mode context variable
    SX126xSetOperatingMode( MODE_STDBY_RC );
#endif
}

void SX126xWriteCommand( RadioCommands_t command, uint8_t *buffer, uint16_t size )
{
#ifdef LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD        
#ifdef RT_USING_SPI
    SX126xCheckDeviceReady( );

    rt_spi_send_then_send(SX126x.spi,&command,1,buffer,size);
    
    if( command != RADIO_SET_SLEEP )
    {
        SX126xWaitOnBusy( );
    }
#endif 
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    int spi_fd;
    SX126xCheckDeviceReady( );

    spi_fd = PrivOpen(LORA_SPI_DEV_NAME, O_RDWR);

    PrivWrite(spi_fd, &command, 1);

    PrivWrite(spi_fd, buffer, size);

    PrivClose(spi_fd);
    
    if( command != RADIO_SET_SLEEP )
    {
        SX126xWaitOnBusy( );
    }
#endif
}

uint8_t SX126xReadCommand( RadioCommands_t command, uint8_t *buffer, uint16_t size )
{
#ifdef LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD
#ifdef RT_USING_SPI
    uint8_t status = 0;
    uint8_t buffer_temp[16] = {0}; // command size is 2 size
    
    SX126xCheckDeviceReady( );
    
    rt_spi_send_then_recv(SX126x.spi,&command,1,buffer_temp,size + 1);
    
    status = buffer_temp[0];
    
    rt_memcpy(buffer,buffer_temp+1,size);
    
    SX126xWaitOnBusy( );
    
    return status;
#endif
#endif    

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    int spi_fd;
    uint8_t status = 0;
    uint8_t buffer_temp[16] = {0}; // command size is 2 size
    
    SX126xCheckDeviceReady( );

    spi_fd = PrivOpen(LORA_SPI_DEV_NAME, O_RDWR);

    PrivWrite(spi_fd, &command, 1);

    PrivRead(spi_fd, buffer_temp, size + 1);

    PrivClose(spi_fd);
    
    status = buffer_temp[0];
    
    memcpy(buffer, buffer_temp + 1, size);
    
    SX126xWaitOnBusy( );
    
    return status;
#endif
}

void SX126xWriteRegisters( uint16_t address, uint8_t *buffer, uint16_t size )
{
#ifdef LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD
#ifdef RT_USING_SPI
    uint8_t msg[3] = {0};
    
    msg[0] = RADIO_WRITE_REGISTER;
    msg[1] = ( address & 0xFF00 ) >> 8;
    msg[2] = address & 0x00FF;
    
    SX126xCheckDeviceReady( );
    
    rt_spi_send_then_send(SX126x.spi,msg,3,buffer,size);

    SX126xWaitOnBusy( );
#endif
#endif    

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    int spi_fd;
    uint8_t msg[3] = {0};
    
    msg[0] = RADIO_WRITE_REGISTER;
    msg[1] = ( address & 0xFF00 ) >> 8;
    msg[2] = address & 0x00FF;
    
    SX126xCheckDeviceReady( );
    
    spi_fd = PrivOpen(LORA_SPI_DEV_NAME, O_RDWR);

    PrivWrite(spi_fd, msg, 3);

    PrivWrite(spi_fd, buffer, size);

    PrivClose(spi_fd);

    SX126xWaitOnBusy( );
#endif
}

void SX126xWriteRegister( uint16_t address, uint8_t value )
{
    SX126xWriteRegisters( address, &value, 1 );
}

void SX126xReadRegisters( uint16_t address, uint8_t *buffer, uint16_t size )
{ 
#ifdef LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD
#ifdef RT_USING_SPI
    uint8_t msg[4] = {0};
    
    msg[0] = RADIO_READ_REGISTER;
    msg[1] = ( address & 0xFF00 ) >> 8;
    msg[2] = address & 0x00FF;
    msg[3] = 0;
    
    SX126xCheckDeviceReady( );

    rt_spi_send_then_recv(SX126x.spi,msg,4,buffer,size);

    SX126xWaitOnBusy( );
#endif
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    int spi_fd;
    uint8_t msg[4] = {0};
    
    msg[0] = RADIO_READ_REGISTER;
    msg[1] = ( address & 0xFF00 ) >> 8;
    msg[2] = address & 0x00FF;
    msg[3] = 0;
    
    SX126xCheckDeviceReady( );

    spi_fd = PrivOpen(LORA_SPI_DEV_NAME, O_RDWR);

    PrivWrite(spi_fd, msg, 4);

    PrivRead(spi_fd, buffer, size);

    PrivClose(spi_fd);

    SX126xWaitOnBusy( );
#endif
}

uint8_t SX126xReadRegister( uint16_t address )
{
    uint8_t data;
    SX126xReadRegisters( address, &data, 1 );
    return data;
}

void SX126xWriteBuffer( uint8_t offset, uint8_t *buffer, uint8_t size )
{
#ifdef LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD
#ifdef RT_USING_SPI

    uint8_t msg[2] = {0};
    
    msg[0] = RADIO_WRITE_BUFFER;
    msg[1] = offset;
    
    SX126xCheckDeviceReady( );
    
    rt_spi_send_then_send(SX126x.spi,msg,2,buffer,size);
    
    SX126xWaitOnBusy( );  

#endif    
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    int spi_fd;
    uint8_t msg[2] = {0};
    
    msg[0] = RADIO_WRITE_BUFFER;
    msg[1] = offset;
    
    SX126xCheckDeviceReady( );

    spi_fd = PrivOpen(LORA_SPI_DEV_NAME, O_RDWR);

    PrivWrite(spi_fd, msg, 2);

    PrivWrite(spi_fd, buffer, size);
    
    PrivClose(spi_fd);

    SX126xWaitOnBusy( );  
#endif
}

void SX126xReadBuffer( uint8_t offset, uint8_t *buffer, uint8_t size )
{
#ifdef LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD
#ifdef RT_USING_SPI
    uint8_t msg[3] = {0};
    
    msg[0] = RADIO_READ_BUFFER;
    msg[1] = offset;
    msg[2] = 0;
    
    SX126xCheckDeviceReady( );

    rt_spi_send_then_recv(SX126x.spi,msg,3,buffer,size);

    SX126xWaitOnBusy( );
#endif    
#endif
    
#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    int spi_fd;
    uint8_t msg[3] = {0};
    
    msg[0] = RADIO_READ_BUFFER;
    msg[1] = offset;
    msg[2] = 0;
    
    SX126xCheckDeviceReady( );

    spi_fd = PrivOpen(LORA_SPI_DEV_NAME, O_RDWR);

    PrivWrite(spi_fd, msg, 3);

    PrivRead(spi_fd, buffer, size);

    PrivClose(spi_fd);

    SX126xWaitOnBusy( );
#endif
}
