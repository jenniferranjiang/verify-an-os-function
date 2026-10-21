/*!
 * \file      sx1268-board.c
 *
 * \brief     Target board SX126x shield driver implementation
 *
 * \copyright Revised BSD License, see section \ref LICENSE.
 *
 * \code
 *                ______                              _
 *               / _____)             _              | |
 *              ( (____  _____ ____ _| |_ _____  ____| |__
 *               \____ \| ___ |    (_   _) ___ |/ ___)  _ \
 *               _____) ) ____| | | || |_| ____( (___| | | |
 *              (______/|_____)_|_|_| \__)_____)\____)_| |_|
 *              (C)2013-2017 Semtech
 *
 * \endcode
 *
 * \author    Miguel Luis ( Semtech )
 *
 * \author    Gregory Cristian ( Semtech )
 *
 * \author    Forest-Rain
 */

/**
* @file sx126x-board.c
* @brief support lora-radio-driver for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-06-06
*/

/*************************************************
File name: sx126x-board.c
Description: support lora-radio-driver for XiUOS
Others: 
History: 
1. Date: 2023-06-06
Author: AIIT XUOS Lab
Modification: 
1、add LORA_RADIO_DRIVER_USING_RTOS_XIUOS to support XiUOS.
*************************************************/

#include <lora-radio-rtos-config.h>
#include <lora-radio.h>
#include <sx126x-board.h>

#define LOG_TAG "LoRa.Board.E22-400M30S(SX1268)" // E22-400M30S
#define LOG_LEVEL  LOG_LVL_DBG 
#include <lora-radio-debug.h>

/*!
 * Debug GPIO pins objects
 */
#if defined( USE_RADIO_DEBUG )
Gpio_t DbgPinTx;
Gpio_t DbgPinRx;
#endif

#ifdef LORA_RADIO_GPIO_SETUP_BY_PIN_NAME
#if ( RT_VER_NUM <= 0x40004 )
int stm32_pin_get(char *pin_name)
{
    /* eg: pin_name : "PA.4"  ( GPIOA, GPIO_PIN_4 )--> drv_gpio.c pin */
    char pin_index = strtol(&pin_name[3],0,10);
    
    if(pin_name[1] < 'A' || pin_name[1] > 'Z')
    {
        return -1;
    }

    return (16 * (pin_name[1]-'A') + pin_index);
}
#endif 
#endif /* LORA_RADIO_GPIO_SETUP_BY_PIN_NAME */

#ifdef LORA_RADIO_DRIVER_USING_RTOS_RT_THREAD
void SX126xIoInit( void )
{
    rt_pin_mode(LORA_RADIO_NSS_PIN, PIN_MODE_OUTPUT);
    rt_pin_mode(LORA_RADIO_BUSY_PIN, PIN_MODE_INPUT);
    rt_pin_mode(LORA_RADIO_DIO1_PIN, PIN_MODE_INPUT_PULLDOWN);
#if defined( LORA_RADIO_DIO2_PIN ) 
    rt_pin_mode(LORA_RADIO_DIO2_PIN, PIN_MODE_INPUT_PULLDOWN);
#endif
#if defined( LORA_RADIO_RFSW1_PIN ) && defined ( LORA_RADIO_RFSW2_PIN )   
    rt_pin_mode(LORA_RADIO_RFSW1_PIN, PIN_MODE_OUTPUT);
    rt_pin_mode(LORA_RADIO_RFSW2_PIN, PIN_MODE_OUTPUT);
#endif

}

void SX126xIoIrqInit( DioIrqHandler dioIrq )
{ 
    rt_pin_mode(LORA_RADIO_DIO1_PIN, PIN_MODE_INPUT_PULLDOWN);
    rt_pin_attach_irq(LORA_RADIO_DIO1_PIN, PIN_IRQ_MODE_RISING, dioIrq,(void*)"rf-dio1");
    rt_pin_irq_enable(LORA_RADIO_DIO1_PIN, PIN_IRQ_ENABLE);  
}

void SX126xIoDeInit( void )
{
////    GpioInit( &SX126x.Spi.Nss, RADIO_NSS, PIN_ANALOGIC, PIN_PUSH_PULL, PIN_PULL_UP, 1 );
////    GpioInit( &SX126x.BUSY, RADIO_BUSY, PIN_ANALOGIC, PIN_PUSH_PULL, PIN_NO_PULL, 0 );
////    GpioInit( &SX126x.DIO1, RADIO_DIO_1, PIN_ANALOGIC, PIN_PUSH_PULL, PIN_NO_PULL, 0 );
    SX126xAntSwOff();
}

void SX126xIoDbgInit( void )
{
#if defined( USE_RADIO_DEBUG )
    GpioInit( &DbgPinTx, RADIO_DBG_PIN_TX, PIN_OUTPUT, PIN_PUSH_PULL, PIN_NO_PULL, 0 );
    GpioInit( &DbgPinRx, RADIO_DBG_PIN_RX, PIN_OUTPUT, PIN_PUSH_PULL, PIN_NO_PULL, 0 );
#endif
}

void SX126xIoTcxoInit( void )
{
    // Initialize TCXO control
    CalibrationParams_t calibParam;
    
    // +clear OSC_START_ERR for reboot or cold-start from sleep
    SX126xClearDeviceErrors();
    
    // TCXO_CTRL_1_7V -> TCXO_CTRL_2_7V 64*15.0625US
    SX126xSetDio3AsTcxoCtrl( TCXO_CTRL_2_7V, 320);//SX126xGetBoardTcxoWakeupTime( ) << 6 ); // convert from ms to SX126x time base
    
    calibParam.Value = 0x7F;
    SX126xCalibrate( calibParam );
}

uint32_t SX126xGetBoardTcxoWakeupTime( void )
{
    return BOARD_TCXO_WAKEUP_TIME;
}

void SX126xReset( void )
{   
    SX126X_DELAY_MS( 10 );
    rt_pin_mode(LORA_RADIO_RESET_PIN, PIN_MODE_OUTPUT); 
    rt_pin_write(LORA_RADIO_RESET_PIN, PIN_LOW);
    SX126X_DELAY_MS( 20 );
     // internal pull-up
    rt_pin_mode(LORA_RADIO_RESET_PIN, PIN_MODE_INPUT); 
    SX126X_DELAY_MS( 10 ); 
}

void SX126xWaitOnBusy( void )
{
    while( rt_pin_read( LORA_RADIO_BUSY_PIN ) == PIN_HIGH );
}

void SX126xAntSwOn( void )
{
   // No need
}

void SX126xAntSwOff( void )
{
    ////GpioInit( &AntPow, RADIO_ANT_SWITCH_POWER, PIN_ANALOGIC, PIN_PUSH_PULL, PIN_NO_PULL, 0 );
    
#if defined( LORA_RADIO_RFSW1_PIN ) && defined ( LORA_RADIO_RFSW2_PIN )   
    rt_pin_write(LORA_RADIO_RFSW1_PIN, PIN_LOW);
    rt_pin_write(LORA_RADIO_RFSW2_PIN, PIN_LOW);
#endif
}

void SX126xSetAntSw( RadioOperatingModes_t mode )
{
    if( mode == MODE_TX )
    { // Transmit
        rt_pin_write(LORA_RADIO_RFSW1_PIN, PIN_HIGH);
        rt_pin_write(LORA_RADIO_RFSW2_PIN, PIN_LOW);
    }
    else 
    {
        rt_pin_write(LORA_RADIO_RFSW1_PIN, PIN_LOW);
        rt_pin_write(LORA_RADIO_RFSW2_PIN, PIN_HIGH);
    }
}
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
static int pin_fd = -1;
void SX126xIoInit( void )
{ 
    if (pin_fd < 0) {
        pin_fd = PrivOpen("/dev/pin_dev", O_RDWR);
        if (pin_fd < 0) {
            printf("open %s error\n", "/dev/pin_dev");
            return;
        }
    }

    struct PinParam pin_param;
    struct PinStat pin_stat;
    struct PrivIoctlCfg ioctl_cfg;

#ifdef LORA_RADIO_DRIVER_USING_EDU_ARM32
    pin_param.cmd = GPIO_CONFIG_MODE;
    pin_param.mode = GPIO_CFG_OUTPUT;
    pin_param.pin = LORA_RADIO_RFSW1_PIN;

    ioctl_cfg.ioctl_driver_type = PIN_TYPE;
    ioctl_cfg.args = &pin_param;
    PrivIoctl(pin_fd, OPE_CFG, &ioctl_cfg);

    pin_stat.pin = LORA_RADIO_RFSW1_PIN;
    pin_stat.val = GPIO_LOW;
    PrivWrite(pin_fd, &pin_stat, 1);

    pin_param.cmd = GPIO_CONFIG_MODE;
    pin_param.mode = GPIO_CFG_OUTPUT;
    pin_param.pin = LORA_RADIO_RFSW2_PIN;

    ioctl_cfg.ioctl_driver_type = PIN_TYPE;
    ioctl_cfg.args = &pin_param;
    PrivIoctl(pin_fd, OPE_CFG, &ioctl_cfg);

    pin_stat.pin = LORA_RADIO_RFSW2_PIN;
    pin_stat.val = GPIO_LOW;
    PrivWrite(pin_fd, &pin_stat, 1);

    pin_param.cmd = GPIO_CONFIG_MODE;
    pin_param.mode = GPIO_CFG_INPUT;
    pin_param.pin = LORA_RADIO_BUSY_PIN;

    ioctl_cfg.ioctl_driver_type = PIN_TYPE;
    ioctl_cfg.args = &pin_param;
    PrivIoctl(pin_fd, OPE_CFG, &ioctl_cfg);

    pin_stat.pin = LORA_RADIO_BUSY_PIN;
    pin_stat.val = GPIO_LOW;
    PrivWrite(pin_fd, &pin_stat, 1);
#endif
}

void SX126xIoIrqInit( DioIrqHandler dioIrq )
{ 

}

void SX126xIoDeInit( void )
{
    SX126xAntSwOff();
}

void SX126xIoDbgInit( void )
{

}

void SX126xIoTcxoInit( void )
{
    // Initialize TCXO control
    CalibrationParams_t calibParam;
    
    // +clear OSC_START_ERR for reboot or cold-start from sleep
    SX126xClearDeviceErrors();
    
    // TCXO_CTRL_1_7V -> TCXO_CTRL_2_7V 64*15.0625US
    SX126xSetDio3AsTcxoCtrl( TCXO_CTRL_2_7V, 320);//SX126xGetBoardTcxoWakeupTime( ) << 6 ); // convert from ms to SX126x time base
    
    calibParam.Value = 0x7F;
    SX126xCalibrate( calibParam );
}

uint32_t SX126xGetBoardTcxoWakeupTime( void )
{
    return BOARD_TCXO_WAKEUP_TIME;
}

void SX126xReset( void )
{   
    SX126X_DELAY_MS( 10 );
    
    if (pin_fd < 0) {
        pin_fd = PrivOpen("/dev/pin_dev", O_RDWR);
        if (pin_fd < 0) {
            printf("open %s error\n", "/dev/pin_dev");
            return;
        }
    }

    struct PinParam pin_param;
    pin_param.cmd = GPIO_CONFIG_MODE;
    pin_param.mode = GPIO_CFG_OUTPUT;
    pin_param.pin = LORA_RADIO_RESET_PIN;

    struct PrivIoctlCfg ioctl_cfg;
    ioctl_cfg.ioctl_driver_type = PIN_TYPE;
    ioctl_cfg.args = &pin_param;
    PrivIoctl(pin_fd, OPE_CFG, &ioctl_cfg);

    struct PinStat pin_stat;
    pin_stat.pin = LORA_RADIO_RESET_PIN;
    pin_stat.val = GPIO_LOW;
    PrivWrite(pin_fd, &pin_stat, 1);

    // Wait 20 ms
    SX126X_DELAY_MS( 20 );

    // Configure RESET as input
    pin_param.cmd = GPIO_CONFIG_MODE;
    pin_param.mode = GPIO_CFG_INPUT;
    pin_param.pin = LORA_RADIO_RESET_PIN;

    ioctl_cfg.ioctl_driver_type = PIN_TYPE;
    ioctl_cfg.args = &pin_param;
    PrivIoctl(pin_fd, OPE_CFG, &ioctl_cfg);

    // Wait 10 ms
    SX126X_DELAY_MS( 10 );
}

void SX126xWaitOnBusy( void )
{
    if (pin_fd < 0) {
        pin_fd = PrivOpen("/dev/pin_dev", O_RDWR);
        if (pin_fd < 0) {
            printf("open %s error\n", "/dev/pin_dev");
            return;
        }
    }
#ifdef LORA_RADIO_DRIVER_USING_EDU_ARM32
    struct PinStat pin_stat;
    pin_stat.pin = LORA_RADIO_BUSY_PIN;
    PrivRead(pin_fd, &pin_stat, 1);

    while (GPIO_HIGH == pin_stat.val) {
        PrivRead(pin_fd, &pin_stat, 1);
    }
#endif
}

void SX126xAntSwOn( void )
{
   // No need
}

void SX126xAntSwOff( void )
{
#ifdef LORA_RADIO_DRIVER_USING_EDU_ARM32
    struct PinStat pin_stat;
    pin_stat.pin = LORA_RADIO_RFSW1_PIN;
    pin_stat.val = GPIO_LOW;
    PrivWrite(pin_fd, &pin_stat, 1);

    pin_stat.pin = LORA_RADIO_RFSW2_PIN;
    pin_stat.val = GPIO_LOW;
    PrivWrite(pin_fd, &pin_stat, 1);
#endif
}

void SX126xSetAntSw( RadioOperatingModes_t mode )
{
#ifdef LORA_RADIO_DRIVER_USING_EDU_ARM32
    struct PinStat pin_stat;
    if( mode == MODE_TX ) { // Transmit
        pin_stat.pin = LORA_RADIO_RFSW1_PIN;
        pin_stat.val = GPIO_HIGH;
        PrivWrite(pin_fd, &pin_stat, 1);

        pin_stat.pin = LORA_RADIO_RFSW2_PIN;
        pin_stat.val = GPIO_LOW;
        PrivWrite(pin_fd, &pin_stat, 1);
    } else {
        pin_stat.pin = LORA_RADIO_RFSW1_PIN;
        pin_stat.val = GPIO_LOW;
        PrivWrite(pin_fd, &pin_stat, 1);

        pin_stat.pin = LORA_RADIO_RFSW2_PIN;
        pin_stat.val = GPIO_HIGH;
        PrivWrite(pin_fd, &pin_stat, 1);
    }
#endif
}
#endif

bool SX126xCheckRfFrequency( uint32_t frequency )
{
    // Implement check. Currently all frequencies are supported
    return true;
}

#if defined( USE_RADIO_DEBUG )
void SX126xDbgPinTxWrite( uint8_t state )
{
    GpioWrite( &DbgPinTx, state );
}

void SX126xDbgPinRxWrite( uint8_t state )
{
    GpioWrite( &DbgPinRx, state );
}
#endif
