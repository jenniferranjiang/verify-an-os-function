/*!
 * \file      lora-radio-tester.c
 *
 * \brief     lora radio shell for test implementation
 *
 * \copyright SPDX-License-Identifier: Apache-2.0
 *
 * \author    Forest-Rain
 * 
 * \author    AIIT XUOS Lab
 */

/**
* @file lora-radio-tester.c
* @brief support lora-radio-tester for XiUOS
* @version 3.0 
* @author AIIT XUOS Lab
* @date 2023-03-07
*/

/*************************************************
File name: lora-radio-tester.c
Description: support lora-radio-tester for XiUOS
Others: 
History: 
1. Date: 2023-03-07
Author: AIIT XUOS Lab
Modification: 
1?add LORA_RADIO_DRIVER_USING_RTOS_XIUOS to support XiUOS.
*************************************************/

#include <lora-radio-rtos-config.h>
#include <lora-radio.h>
#include <lora-radio-timer.h>
#include "lora-radio-tester.h"

#define LOG_TAG "APP.LoRa.Radio.Shell"
#include <lora-radio-debug.h>

#define TX_LED_TOGGLE
#define TX_LED_ON
#define TX_LED_OFF

#define RX_LED_TOGGLE
#define RX_LED_ON
#define RX_LED_OFF

#ifdef LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD
#define LORA_RADIO_TIMESTAMP_TO_MS(x) ((x) * 1000 / RT_TICK_PER_SECOND)
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
#define LORA_RADIO_TIMESTAMP_TO_MS(x) ((x) * 1000 / TICK_PER_SECOND)
static int radio_event;
#endif

#ifdef LORA_RADIO_RTOS_SUUPORT_RTT
static struct rt_event radio_event;
#endif

const static uint8_t PingMsg[] = "PING";

static uint16_t BufferSize = BUFFER_SIZE;
static uint8_t Buffer[BUFFER_SIZE];

static int16_t rssi_value = -255;
static int16_t rssi_value_min = -255;
static int16_t rssi_value_max = -255;
static int32_t rssi_value_total = 0;

static int8_t snr_value = -128;
static int8_t snr_value_min = -128;
static int8_t snr_value_max = -128;
static int32_t snr_value_total = 0;

static uint32_t master_address = LORA_MASTER_DEVADDR;
static uint32_t slaver_address = LORA_SLAVER_DEVADDR;
static uint8_t payload_len = 32;//1~255

static uint32_t tx_seq_cnt = 0;
static uint32_t max_tx_nbtrials = 10;
static uint32_t rx_correct_cnt = 0;
static uint32_t rx_error_cnt = 0;
static uint32_t rx_timeout_cnt = 0;

static uint32_t tx_timestamp;
static uint32_t rx_timestamp;

static uint32_t rx_timeout = RX_TIMEOUT_VALUE;
static uint32_t tx_timeout = TX_TIMEOUT_VALUE;
static uint8_t lora_chip_initialized;
static bool master_flag = true;
static bool rx_only_flag = false;
static bool tx_only_flag = false;
static int tx_continues = false;

static lora_radio_test_t lora_radio_test_paras = 
{
    .tx_frequency = RF_FREQUENCY,
    .trx_frequency_offset = TX_RX_FREQUENCE_OFFSET,
    .rx_frequency = RF_FREQUENCY + TX_RX_FREQUENCE_OFFSET,
    
    .txpower      = TX_OUTPUT_POWER,
    
    // lora
    .modem     = MODEM_LORA,
    .sf        = LORA_SPREADING_FACTOR,
    .bw        = LORA_BANDWIDTH,
    .cr        = LORA_CODINGRATE,
    .iq_inversion = LORA_IQ_INVERSION_ON_DISABLE,
    .public_network = false,
     // FSK
    .fsk_bandwidth = FSK_BANDWIDTH,
};

char *bandwidth_string[3] = {"125","250","500"};

/*!
 * Radio events function pointer
 */
static RadioEvents_t RadioEvents;

/*!
 * lora radio test thread
 */
#ifdef LORA_RADIO_RTOS_SUUPORT_RTT
static rt_thread_t lora_radio_test_thread = RT_NULL; 
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
static unsigned int status = 0;
static pthread_t lora_radio_test_task;
#endif

/*!
 * \brief Function to be executed on Radio Tx Done event
 */
static void OnTxDone( void );

/*!
 * \brief Function to be executed on Radio Rx Done event
 */
static void OnRxDone( uint8_t *payload, uint16_t size, int16_t rssi, int8_t snr );

/*!
 * \brief Function executed on Radio Tx Timeout event
 */
static void OnTxTimeout( void );

/*!
 * \brief Function executed on Radio Rx Timeout event
 */
static void OnRxTimeout( void );

/*!
 * \brief Function executed on Radio Rx Error event
 */
static void OnRxError( void );

/*!
 * \brief thread for ping ping
 */
#ifdef LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD
static void lora_radio_test_thread_entry(void* parameter);
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
static void *lora_radio_test_thread_entry(void* parameter);
#endif

static void OnTxDone( void )
{
    Radio.Sleep( );
#ifdef LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD
    rt_event_send(&radio_event, EV_RADIO_TX_DONE);
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    PrivEvenTrigger(radio_event, EV_RADIO_TX_DONE);
#endif
}

void LoraRadioParamsUpdate(uint32_t frequency, uint8_t sf, uint8_t bw)
{
    lora_radio_test_paras.tx_frequency = frequency;
    lora_radio_test_paras.rx_frequency = frequency + TX_RX_FREQUENCE_OFFSET;
    lora_radio_test_paras.sf = sf;
    lora_radio_test_paras.bw = bw;
}

static void OnRxDone( uint8_t *payload, uint16_t size, int16_t rssi, int8_t snr )
{
    Radio.Sleep( );
    BufferSize = size;
    memcpy( Buffer, payload, BufferSize );
    rssi_value = rssi;
    snr_value = snr;
 
    // first rxdone
    if( rssi_value_max == -255 )
    {
        rssi_value_min = rssi_value_max = rssi;
    }
    if( snr_value_max == -128 )
    {
        snr_value_min = snr_value_max = snr;
    }
    
    // update link info
    if( rssi_value < rssi_value_min )
    {
        rssi_value_min = rssi_value;
    }        
    else if( rssi_value > rssi_value_max )
    {
        rssi_value_max = rssi_value;
    }        
    
    if( snr_value < snr_value_min )
    {
        snr_value_min = snr_value;
    }        
    else if( snr_value > rssi_value_max )
    {
        snr_value_max = snr_value;
    }   
    
    rssi_value_total += rssi_value;
    snr_value_total += snr_value;
    rx_timestamp = TimerGetCurrentTime();
#ifdef LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD
    rt_event_send(&radio_event, EV_RADIO_RX_DONE);
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    for (int i = 0; i < BufferSize ; i ++) {
        if (0 == i) {
            printf("receive data : 0x%x ", Buffer[i]);
        } else if ((BufferSize - 1) == i) {
            printf("0x%x\n", Buffer[i]);
        } else {
            printf("0x%x ", Buffer[i]);
        }
    }

    PrivEvenTrigger(radio_event, EV_RADIO_RX_DONE);
#endif
}

static void OnTxTimeout( void )
{
    Radio.Sleep( );
#ifdef LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD
    rt_event_send(&radio_event, EV_RADIO_TX_TIMEOUT);
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    PrivEvenTrigger(radio_event, EV_RADIO_TX_TIMEOUT);
#endif
}

static void OnRxTimeout( void )
{
    Radio.Sleep( );
    rx_timestamp = TimerGetCurrentTime();
#ifdef LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD
    rt_event_send(&radio_event, EV_RADIO_RX_TIMEOUT);
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    PrivEvenTrigger(radio_event, EV_RADIO_RX_TIMEOUT);
#endif
}

static void OnRxError( void )
{
    rx_error_cnt++; 
    Radio.Sleep( );
#ifdef LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD
    rt_event_send(&radio_event, EV_RADIO_RX_ERROR);
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    PrivEvenTrigger(radio_event, EV_RADIO_RX_ERROR);
#endif
}

static void send_ping_packet(uint32_t src_addr,uint32_t dst_addr,uint8_t len)
{
    tx_seq_cnt++;
                            
    tx_timestamp = TimerGetCurrentTime();
    
    // Send the next PING frame
    uint8_t index = 0;
    
    // header 
    Buffer[index++] = 0x00; // echo cmd
    
    Buffer[index++] = src_addr & 0xFF;
    Buffer[index++] = src_addr >> 8;
    Buffer[index++] = src_addr >> 16;
    Buffer[index++] = src_addr >> 24;

    Buffer[index++] = dst_addr & 0xFF;
    Buffer[index++] = dst_addr >> 8;
    Buffer[index++] = dst_addr >> 16;
    Buffer[index++] = dst_addr >> 24;
 
    Buffer[index++] = tx_seq_cnt & 0xFF;
    Buffer[index++] = tx_seq_cnt >> 8;
    Buffer[index++] = tx_seq_cnt >> 16;
    Buffer[index++] = tx_seq_cnt >> 24;    
    
    // data
    Buffer[index++] = 'P';
    Buffer[index++] = 'I';
    Buffer[index++] = 'N';
    Buffer[index++] = 'G';
    
    // 00,01,02...
    for( uint8_t i = 0; i < len - index ; i++)
    {
        Buffer[index + i] = i;
    }
    
    Radio.SetChannel( lora_radio_test_paras.tx_frequency );
#ifdef LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD
    rt_thread_mdelay(1);
#endif
#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS
    PrivTaskDelay(100);
#endif
    Radio.Send( Buffer, len );
}

void init_tx_rx_timeout(void)
{
    /* unit ms */
    uint32_t packet_toa = Radio.TimeOnAir(lora_radio_test_paras.modem,lora_radio_test_paras.bw,lora_radio_test_paras.sf,lora_radio_test_paras.cr,LORA_PREAMBLE_LENGTH, LORA_FIX_LENGTH_PAYLOAD_ON_DISABLE,payload_len,true);
    tx_timeout = packet_toa + TX_TIMEOUT_VALUE; 
    rx_timeout = packet_toa + RX_TIMEOUT_VALUE;  
}

#ifdef LORA_RADIO_DRIVER_USING_ON_RTOS_RT_THREAD
static bool lora_radio_tester_init(void)
{
    if( lora_chip_initialized == false )
    {
        // Target board initialization

        if( lora_radio_test_thread == RT_NULL )
        {
            rt_event_init(&radio_event, "ev_lora_test", RT_IPC_FLAG_FIFO);

            lora_radio_test_thread = rt_thread_create("lora-radio-test",
                                                        lora_radio_test_thread_entry, 
                                                        RT_NULL,
                                                        8096, 
                                                        2, 
                                                        10);
            if (lora_radio_test_thread != RT_NULL)
            {
                rt_thread_startup(lora_radio_test_thread);
            }
            else
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "lora radio test thread create failed!\n");
        }
        
        /* Radio initialization */
        RadioEvents.TxDone = OnTxDone;
        RadioEvents.RxDone = OnRxDone;
        RadioEvents.TxTimeout = OnTxTimeout;
        RadioEvents.RxTimeout = OnRxTimeout;
        RadioEvents.RxError = OnRxError;

        if(Radio.Init(&RadioEvents))
        {
            lora_chip_initialized = true;
        }
        else
        {
            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "lora radio init failed!\n");
            
            return false;
        }
  
        Radio.Standby( );
        Radio.Sleep( );
    }
    return true;
}
//INIT_APP_EXPORT(lora_radio_tester_init);

static void radio_rx(void)
{
    rt_uint32_t timeout = 0; 
    if( master_flag == true )
    {
        timeout = rx_timeout;
    }
    Radio.SetChannel( lora_radio_test_paras.rx_frequency );
    Radio.Rx( timeout );
}

static void lora_radio_test_thread_entry(void* parameter)  
{
    rt_uint32_t ev = 0;

    while( 1 )                          
    {
        if (rt_event_recv(&radio_event, EV_RADIO_ALL,
                                        RT_EVENT_FLAG_OR | RT_EVENT_FLAG_CLEAR,
                                        RT_WAITING_FOREVER, &ev) == RT_EOK)
        {
            switch( ev )
            {
                case EV_RADIO_INIT:
           
                    init_tx_rx_timeout();
                
                    Radio.SetChannel( lora_radio_test_paras.tx_frequency );
                    lora_radio_test_paras.rx_frequency = lora_radio_test_paras.tx_frequency + lora_radio_test_paras.trx_frequency_offset;
                
                    if( lora_radio_test_paras.modem == MODEM_LORA )
                    {
                        /* default private syncword for p2p test */
                        Radio.SetPublicNetwork( lora_radio_test_paras.public_network );

                        Radio.SetTxConfig( MODEM_LORA, lora_radio_test_paras.txpower, 0, lora_radio_test_paras.bw,
                                                       lora_radio_test_paras.sf, lora_radio_test_paras.cr,
                                                       LORA_PREAMBLE_LENGTH, LORA_FIX_LENGTH_PAYLOAD_ON_DISABLE,
                                                       true, 0, 0, lora_radio_test_paras.iq_inversion, tx_timeout );

                        Radio.SetRxConfig( MODEM_LORA, lora_radio_test_paras.bw, lora_radio_test_paras.sf,
                                                       lora_radio_test_paras.cr, 0, LORA_PREAMBLE_LENGTH,
                                                       LORA_SYMBOL_TIMEOUT, LORA_FIX_LENGTH_PAYLOAD_ON_DISABLE,
                                                       0, true, 0, 0, lora_radio_test_paras.iq_inversion, true );                                                                              
                    }
                    else
                    {
                        Radio.SetTxConfig( MODEM_FSK, lora_radio_test_paras.txpower, FSK_FDEV, 0,
                                                      FSK_DATARATE, 0,
                                                      FSK_PREAMBLE_LENGTH, FSK_FIX_LENGTH_PAYLOAD_ON,
                                                      true, 0, 0, 0, 3000 );

                        Radio.SetRxConfig( MODEM_FSK, FSK_BANDWIDTH, FSK_DATARATE,
                                                      0, FSK_AFC_BANDWIDTH, FSK_PREAMBLE_LENGTH,
                                                      0, FSK_FIX_LENGTH_PAYLOAD_ON, 0, true,
                                                      0, 0,false, true );
                    }

                    /* initlize the statistics parameters */
                    rssi_value = -255;
                    rssi_value_min = -255;
                    rssi_value_max = -255;
                    rssi_value_total = 0;
                    snr_value = -128;
                    snr_value_min = -128;
                    snr_value_max = -128;
                    snr_value_total = 0;
                
                    tx_seq_cnt = 0;
                    rx_timeout_cnt = 0;
                    rx_error_cnt = 0;
                    rx_correct_cnt = 0;

                    if( master_flag == 0 )
                    {
                        if( rx_only_flag == false )
                        {
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Slaver Address(SA):[0x%X]\n",slaver_address);
                        }
                        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Stay to Rx Continuous with freq=%d, SF=%d, BW=%s, CR=%d, Public_Network:%d, IQ_Inversion:%d", lora_radio_test_paras.rx_frequency,lora_radio_test_paras.sf, 
                                                                                                                                                                       bandwidth_string[lora_radio_test_paras.bw], lora_radio_test_paras.cr, 
                                                                                                                                                                       lora_radio_test_paras.public_network,lora_radio_test_paras.iq_inversion);
                        Radio.SetChannel( lora_radio_test_paras.rx_frequency );
                        Radio.Rx( 0 );
                    }
                    else
                    {
                        rt_event_send(&radio_event, EV_RADIO_TX_START);
                    }
                    break;
                  
                case EV_RADIO_RX_DONE:
                    if( master_flag == true )
                    {
                        if( BufferSize > 0 )
                        {
                            if( rt_strncmp( ( const char* )Buffer + MAC_HEADER_OVERHEAD, ( const char* )PingMsg, 4 ) == 0 )
                            {
                                /* Indicates on a LED that the received frame is a PING ACK packet */
                                RX_LED_TOGGLE;
                                rx_correct_cnt++;

                                uint32_t slaver_addr = 0;
                                slaver_addr = Buffer[5];
                                slaver_addr |= Buffer[6] << 8;
                                slaver_addr |= Buffer[7] << 16;
                                slaver_addr |= Buffer[8] << 24;

                                uint32_t received_seqno = 0;
                                received_seqno = Buffer[9];
                                received_seqno |= Buffer[10] << 8;
                                received_seqno |= Buffer[11] << 16;
                                received_seqno |= Buffer[12] << 24;
                                
                               LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Reply from [0x%X]:seqno=%d, bytes=%d,total time=%d ms,rssi=%d,snr=%d",slaver_addr, received_seqno, BufferSize, LORA_RADIO_TIMESTAMP_TO_MS( rx_timestamp - tx_timestamp ),rssi_value,snr_value );
                             
                               /* Send the next PING frame */
                               rt_event_send(&radio_event, EV_RADIO_TX_START);
                               break;
                            }
                            else /* valid reception but neither a PING ACK */
                            {   
                                Radio.SetChannel( lora_radio_test_paras.rx_frequency );
                                Radio.Rx( RX_TIMEOUT_VALUE );
                            }
                        }
                        else
                        {
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "RX ERR:BufferSize = 0");
                        }
                    }
                    else
                    {
                        if( BufferSize > 0 )
                        {
                            #define DST_ADDRESS_OFFSET 5
                            uint32_t dst_address = Buffer[DST_ADDRESS_OFFSET] | \
                                                 ( Buffer[DST_ADDRESS_OFFSET+1] << 8 ) |\
                                                 ( Buffer[DST_ADDRESS_OFFSET+2] << 16 )|\
                                                 ( Buffer[DST_ADDRESS_OFFSET+3] << 24); 

                            if( rx_only_flag == true )
                            {
                                /* Indicates on a LED that the received frame */
                                RX_LED_TOGGLE;
                            
                                uint32_t src_addr,dst_addr = 0;
                                src_addr = Buffer[1];
                                src_addr |= Buffer[2] << 8;
                                src_addr |= Buffer[3] << 16;
                                src_addr |= Buffer[4] << 24;

                                dst_addr = Buffer[5];
                                dst_addr |= Buffer[6] << 8;
                                dst_addr |= Buffer[7] << 16;
                                dst_addr |= Buffer[8] << 24;
                                
                                rx_correct_cnt++;
                                
                                /* RX continuous */
                                Radio.SetChannel( lora_radio_test_paras.rx_frequency );
                                Radio.Rx( 0 ); 
              
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Received: Totals=%d,bytes=%d,timestamp=%d,rssi=%d,snr=%d\n",rx_correct_cnt, BufferSize, rx_timestamp, rssi_value, snr_value );

#ifdef RT_USING_ULOG
                                ulog_hexdump(LOG_TAG,16,Buffer,BufferSize);
#endif
                            }   
                            else if( ( dst_address == slaver_address || dst_address == 0xFFFFFFFF ) && \
                                ( rt_strncmp( ( const char* )Buffer + MAC_HEADER_OVERHEAD, ( const char* )PingMsg, 4 ) == 0 ))
                            {
                                /* Indicates on a LED that the received frame is a PING */
                                RX_LED_TOGGLE;
                                /* echo the receive packet to master */
                                {
                                    /* wait for master going to be ready to rx */
                                    rt_thread_mdelay(5);
                                    Radio.SetChannel( lora_radio_test_paras.tx_frequency );
                                    Radio.Send( Buffer, BufferSize );
                                }
#ifdef RT_USING_ULOG
                                ulog_hexdump(LOG_TAG,16,Buffer,BufferSize);
#endif
                            }                            
                            else /* valid reception but not a PING as expected */
                            {    
                                Radio.SetChannel( lora_radio_test_paras.rx_frequency );
                                Radio.Rx( 0 ); 
                            }
                        }
                    }
                    break;
            case EV_RADIO_TX_DONE:
                /* Indicates on a LED that we have sent a PING [Master] */
                /* Indicates on a LED that we have sent a PING ACK [Slave] */
                TX_LED_TOGGLE;
                radio_rx();
                break;
            case EV_RADIO_RX_TIMEOUT:
                rx_timeout_cnt++;
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Request [SA=0x%X] timed out: seqno=%d, time=%d ms", slaver_address, tx_seq_cnt, LORA_RADIO_TIMESTAMP_TO_MS( rx_timestamp - tx_timestamp ));
            case EV_RADIO_RX_ERROR:
            case EV_RADIO_TX_START:
                    if( master_flag == true && ev != EV_RADIO_RX_ERROR )
                    {
                        /* tx_seq_cnt start from 0 */
                        if( tx_seq_cnt < max_tx_nbtrials ) 
                        {
                            /* for first time to printf some info */
                            if( !tx_seq_cnt ) 
                            {
                                uint32_t packet_toa = Radio.TimeOnAir(lora_radio_test_paras.modem,lora_radio_test_paras.bw,lora_radio_test_paras.sf,lora_radio_test_paras.cr,LORA_PREAMBLE_LENGTH, LORA_FIX_LENGTH_PAYLOAD_ON_DISABLE,payload_len,true);
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Master Address(MA):[0x%X]",master_address);
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Pinging [SA=0x%X] with %u bytes(ToA=%d ms) of data for %d counters:", slaver_address, payload_len, packet_toa, max_tx_nbtrials);
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "With radio parameters: tx freq=%d, rx freq=%d, TxPower=%d, SF=%d, BW=%s, CR=%d, Public_Network:%d, IQ_Inversion:%d", lora_radio_test_paras.tx_frequency,lora_radio_test_paras.rx_frequency, lora_radio_test_paras.txpower, 
                                                                                                                                                                                        lora_radio_test_paras.sf, bandwidth_string[lora_radio_test_paras.bw], lora_radio_test_paras.cr,
                                                                                                                                                                                        lora_radio_test_paras.public_network,lora_radio_test_paras.iq_inversion);
                            }
    
                            send_ping_packet(master_address,slaver_address,payload_len);
                        }
                        else
                        {
                            uint16_t per = 100 - ( (float) rx_correct_cnt / tx_seq_cnt ) * 100;
                            uint32_t tx_total_byte = tx_seq_cnt * ( payload_len + MAC_HEADER_OVERHEAD );
                            uint32_t tx_total_kbyte_integer = tx_total_byte >> 10;   // / 1024
                            uint32_t tx_total_kbyte_decimal = tx_total_byte & 0x3FF; // % 1024
                            
                            uint32_t rx_total_byte = rx_correct_cnt * ( payload_len + MAC_HEADER_OVERHEAD );
                            uint32_t rx_total_kbyte_integer = rx_total_byte >> 10;   // / 1024
                            uint32_t rx_total_kbyte_decimal = rx_total_byte & 0x3FF; // % 1024
                            int32_t avg_rssi = -255;
                            int32_t avg_snr = -128;
                            if( rx_correct_cnt )
                            {
                                avg_rssi = rssi_value_total / (int32_t)rx_correct_cnt;
                                avg_snr = snr_value_total / (int32_t)rx_correct_cnt;
                            }
                            /* wait for PHY log output done */
                            rt_thread_mdelay(10);
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "\r\n====== LoRa Ping statistics for [MA=0x%X <-> SA=0x%X] with [TxPower=%d,SF=%d] ======",master_address, slaver_address, lora_radio_test_paras.txpower, lora_radio_test_paras.sf);
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "-> Tx pakcets: sent = %d, tx_total = %d.%d KByte",tx_seq_cnt, tx_total_kbyte_integer, tx_total_kbyte_decimal);       
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "-> Rx pakcets: received = %d, lost = %d, per = %d%, rx_total = %d.%d KByte",rx_correct_cnt, rx_timeout_cnt + rx_error_cnt, per,rx_total_kbyte_integer,rx_total_kbyte_decimal);   
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "--> Rx rssi: max_rssi = %d, min_rssi = %d, avg_rssi = %d",rssi_value_max,rssi_value_min,avg_rssi);       
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "--> Rx snr: max_snr  = %d, min_snr  = %d, avg_snr  = %d",snr_value_max,snr_value_min,avg_snr);
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "====== LoRa Ping Test Finished ======\r\n");
                        }
                    }
                    else
                    {
                        Radio.SetChannel( lora_radio_test_paras.rx_frequency );
                        Radio.Rx( 0 );
                    }
                    break;
                case EV_RADIO_TX_TIMEOUT:
                    radio_rx();
                    break;  
            }
        }
    } 
}

/* for finish\msh */
#define CMD_LORA_CHIP_PROBE_INDEX        0 // LoRa Chip probe
#define CMD_LORA_CHIP_CONFIG_INDEX       1 // tx config
#define CMD_LORA_TX_CW_INDEX             2 // tx cw
#define CMD_LORA_PING_INDEX              3 // ping-pong
#define CMD_LORA_RX_PACKET_INDEX         4 // rx packet only

const char* lora_help_info[] = 
{
    [CMD_LORA_CHIP_PROBE_INDEX]       = "lora probe                 - lora radio probe",
    [CMD_LORA_CHIP_CONFIG_INDEX]      = "lora config<para><val>     - config parameters<freq><freq_offset><power><sf><bw><public><iq>", 
    [CMD_LORA_TX_CW_INDEX]            = "lora cw <freq>,<power>     - tx carrier wave",
    [CMD_LORA_PING_INDEX]             = "lora ping <para1><..>      - ping <-m: master,-s: slaver>",   
    [CMD_LORA_RX_PACKET_INDEX]        = "lora rx <rx_only><timeout> - rx data (or sniffer)",  
};

/* LoRa Radio Test Shell */
static int lora(int argc, char *argv[])
{
    size_t i = 0;
    
    if (argc < 2)
    {   
        /* parameter error */
        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Radio(%s) Usage:\n",LORA_RADIO_SW_VERSION);
        for (i = 0; i < sizeof(lora_help_info) / sizeof(char*); i++) 
        {
            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "%s", lora_help_info[i]);
        }
        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "\n");
    } 
    else 
    {
        const char *cmd0 = argv[1];
				
        if( lora_radio_tester_init() == false )
        {
            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Chip Init Failed");
            return 0;
        }
			
        if (!rt_strcmp(cmd0, "probe")) 
        {   
            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Chip start to test");

            if( Radio.Check() )
            {
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Chip Probe ok!");
            }
            else
            {
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Chip Probe failed!\n!");
            }
        }
        else if (!rt_strcmp(cmd0, "cw")) 
        {
            uint8_t timeout = 0;
            if (argc >= 3) 
            {
                lora_radio_test_paras.tx_frequency = atol(argv[2]);
            }
            if (argc >= 4) 
            {
                lora_radio_test_paras.txpower = atol(argv[3]);
            }
            if (argc >= 5) 
            {
                timeout = atol(argv[4]);
            }
            Radio.SetTxContinuousWave( lora_radio_test_paras.tx_frequency, lora_radio_test_paras.txpower, timeout);
        }
        else if (!rt_strcmp(cmd0, "ping")) 
        {       
            /* default for slaver */
            master_flag  = false;  
            rx_only_flag = false;
            
            if (argc >= 3) 
            {   
                 const char *cmd1 = argv[2];
                 if (!rt_strcmp(cmd1, "-m")) 
                 {
                     master_flag = true;
                 }
                 else // -s
                 {
                     master_flag = false;
                 }
                 
                 if( argc >= 4 )
                 {
                    /* max_tx_nbtrials for setup tx counter */
                    max_tx_nbtrials = atol(argv[3]);
                 }
                 
                 if( argc >= 5 )
                 {
                    /* payload_len for setup tx payload length */
                    payload_len = atoi(argv[4]);
                     
                    if( payload_len < MIN_TETS_APP_DATA_SIZE )
                    {
                        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Waring: This size will not supported [lora ping]");
                    }
                 }
                 
                 if( argc >= 6 )
                 {
                    /* rxtimeout  */
                    rx_timeout = atoi(argv[5]);
                 }
                 
                 if( argc >= 7 )
                 {
                    /* txtimeout*/
                    tx_timeout = atoi(argv[6]);
                 }
            } 

            
            rt_event_send(&radio_event, EV_RADIO_INIT);
        }
        else if( !rt_strcmp(cmd0, "rx"))
        {   
            /* eg: lora rx 1 0 */
            master_flag = false;
            rx_only_flag = true;
            
            if (argc >= 3) 
            {
                rx_only_flag = atol(argv[2]);
            }
            if (argc >= 4) 
            {
                rx_timeout = atol(argv[3]);
            }
            
            rt_event_send(&radio_event, EV_RADIO_INIT);
        }
		else if (!rt_strcmp(cmd0, "config")) 
        {
            const char *cmd1 = argv[2];
       
            /* config radio paramters, such as frequency,txPower,sf,bw...*/
            if (!rt_strcmp(cmd1, "freq"))  
            {
                if (argc >= 4)
                {                    
                    lora_radio_test_paras.tx_frequency = atol(argv[3]);
                }
                // RX = TX + offset
                lora_radio_test_paras.rx_frequency = lora_radio_test_paras.tx_frequency + lora_radio_test_paras.trx_frequency_offset;
                
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Tx Frequency: %d",lora_radio_test_paras.tx_frequency);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Rx Frequency: %d",lora_radio_test_paras.rx_frequency);
            }
            else if (!rt_strcmp(cmd1, "foffset"))  
            {
                if (argc >= 4)
                {                    
                    lora_radio_test_paras.trx_frequency_offset = atol(argv[3]);
                }
                
                lora_radio_test_paras.rx_frequency = lora_radio_test_paras.tx_frequency + lora_radio_test_paras.trx_frequency_offset;
             
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Tx and Rx Frequency Offset: %d",lora_radio_test_paras.trx_frequency_offset);
            }
            else if (!rt_strcmp(cmd1, "power")) 
            {
                if (argc >= 4)
                {
                    lora_radio_test_paras.txpower = atoi(argv[3]);
                }
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "TxPower  : %d",lora_radio_test_paras.txpower);
            }
            else if (!rt_strcmp(cmd1, "sf")) 
            {
                if (argc >= 4)
                {
                    if (!rt_strcmp(argv[3], "?")) 
                    {
                        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "SF:7|8|9|10|11|12");
                    }
                    else
                    {                        
                        lora_radio_test_paras.sf = atoi(argv[3]);
                    }
                }
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "SF: %d",lora_radio_test_paras.sf);
            }
            else if (!rt_strcmp(cmd1, "bw")) 
            {
                uint16_t bw;
                if (argc >= 4)
                {
                    if (!rt_strcmp(argv[3], "?")) 
                    {
                        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "BW:0(125kHz)|1(250kHz)|2(500kHz)");
                    }
                    else
                    {
                        bw = atoi(argv[3]);
                    }
                    
                    if(bw == 125)
                    {
                        lora_radio_test_paras.bw = 0;
                    }
                    else if(bw == 250)
                    {
                        lora_radio_test_paras.bw = 1;
                    }
                    else if(bw == 500)
                    {
                        lora_radio_test_paras.bw = 2;
                    }
                }
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "BW: %d(%s)",lora_radio_test_paras.bw, bandwidth_string[lora_radio_test_paras.bw]);
            }
            else if (!rt_strcmp(cmd1, "public"))
            {
                if (argc >= 4)
                {
                    lora_radio_test_paras.public_network = atoi(argv[3]);
                }
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Public Network: %d",lora_radio_test_paras.public_network);
            }
            else if (!rt_strcmp(cmd1, "iq"))
            {
                if (argc >= 4)
                {
                    lora_radio_test_paras.iq_inversion = atoi(argv[3]);
                }
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "IQ Inversion: %d",lora_radio_test_paras.iq_inversion);
            }
            if (argc < 3) 
            {
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "-items-        -{cmd}-   -Value-");
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " Tx Freq        {freq}:   %d",lora_radio_test_paras.tx_frequency);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " Rx Freq        {N.A.}:   %d",lora_radio_test_paras.rx_frequency);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " RX Freq Offset {foffset}:%d",lora_radio_test_paras.trx_frequency_offset);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " TxPower        {power}:  %d",lora_radio_test_paras.txpower);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " SF             {sf}:     %d",lora_radio_test_paras.sf);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " BW             {bw}:     %d(%s kHz)",lora_radio_test_paras.bw,bandwidth_string[lora_radio_test_paras.bw]);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " Public Network {public}: %d",lora_radio_test_paras.public_network);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " IQ Inversion   {iq}:     %d",lora_radio_test_paras.iq_inversion);
            }
        }            
    }
    return 1;
}
MSH_CMD_EXPORT(lora, lora radio tester);
#endif

#ifdef LORA_RADIO_DRIVER_USING_RTOS_XIUOS

static bool lora_radio_tester_init(void)
{
    if( lora_chip_initialized == false ) {

        radio_event = PrivEventCreate(LINKLIST_FLAG_FIFO);

        // Target board initialization
        pthread_attr_t lora_radio_test;
        lora_radio_test.schedparam.sched_priority = 21;
        lora_radio_test.stacksize = 8096;

        char task_name[] = "lora_radio_test_task";
        pthread_args_t args;
        args.pthread_name = task_name;

        PrivTaskCreate(&lora_radio_test_task, &lora_radio_test, &lora_radio_test_thread_entry, (void *)&args);
        PrivTaskStartup(&lora_radio_test_task);

        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "lora radio test thread create done!\n");
        
        /* Radio initialization */
        RadioEvents.TxDone = OnTxDone;
        RadioEvents.RxDone = OnRxDone;
        RadioEvents.TxTimeout = OnTxTimeout;
        RadioEvents.RxTimeout = OnRxTimeout;
        RadioEvents.RxError = OnRxError;

        if(Radio.Init(&RadioEvents)) {
            lora_chip_initialized = true;
        } else {
            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "lora radio init failed!\n");
            
            return false;
        }
  
        Radio.Standby( );
        Radio.Sleep( );
    }
    return true;
}

static void radio_rx(void)
{
    uint32_t timeout = 0; 
    if( master_flag == true ) {
        timeout = rx_timeout;
    }
    Radio.SetChannel( lora_radio_test_paras.rx_frequency );
    Radio.Rx( timeout );
}

static void *lora_radio_test_thread_entry(void *parameter)  
{
    while(1) {
        if (0 == PrivEventProcess(radio_event, EV_RADIO_ALL, EVENT_OR | EVENT_AUTOCLEAN, 0, &status)) {
            switch( status ) {
                case EV_RADIO_INIT:
            
                    init_tx_rx_timeout();
                
                    Radio.SetChannel( lora_radio_test_paras.tx_frequency );
                    lora_radio_test_paras.rx_frequency = lora_radio_test_paras.tx_frequency + lora_radio_test_paras.trx_frequency_offset;
                
                    if( lora_radio_test_paras.modem == MODEM_LORA ) {
                        /* default private syncword for p2p test */
                        Radio.SetPublicNetwork( lora_radio_test_paras.public_network );

                        Radio.SetTxConfig( MODEM_LORA, lora_radio_test_paras.txpower, 0, lora_radio_test_paras.bw,
                                                        lora_radio_test_paras.sf, lora_radio_test_paras.cr,
                                                        LORA_PREAMBLE_LENGTH, LORA_FIX_LENGTH_PAYLOAD_ON_DISABLE,
                                                        true, 0, 0, lora_radio_test_paras.iq_inversion, tx_timeout );

                        Radio.SetRxConfig( MODEM_LORA, lora_radio_test_paras.bw, lora_radio_test_paras.sf,
                                                        lora_radio_test_paras.cr, 0, LORA_PREAMBLE_LENGTH,
                                                        LORA_SYMBOL_TIMEOUT, LORA_FIX_LENGTH_PAYLOAD_ON_DISABLE,
                                                        0, true, 0, 0, lora_radio_test_paras.iq_inversion, true );                                                                              
                    } else {
                        Radio.SetTxConfig( MODEM_FSK, lora_radio_test_paras.txpower, FSK_FDEV, 0,
                                                        FSK_DATARATE, 0,
                                                        FSK_PREAMBLE_LENGTH, FSK_FIX_LENGTH_PAYLOAD_ON,
                                                        true, 0, 0, 0, 3000 );

                        Radio.SetRxConfig( MODEM_FSK, FSK_BANDWIDTH, FSK_DATARATE,
                                                        0, FSK_AFC_BANDWIDTH, FSK_PREAMBLE_LENGTH,
                                                        0, FSK_FIX_LENGTH_PAYLOAD_ON, 0, true,
                                                        0, 0,false, true );
                    }

                    /* initlize the statistics parameters */
                    rssi_value = -255;
                    rssi_value_min = -255;
                    rssi_value_max = -255;
                    rssi_value_total = 0;
                    snr_value = -128;
                    snr_value_min = -128;
                    snr_value_max = -128;
                    snr_value_total = 0;
                
                    tx_seq_cnt = 0;
                    rx_timeout_cnt = 0;
                    rx_error_cnt = 0;
                    rx_correct_cnt = 0;

                    if( master_flag == 0 ) {
                        if( rx_only_flag == false ) {
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Slaver Address(SA):[0x%X]\n",slaver_address);
                        }
                        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Stay to Rx Continuous with freq=%d, SF=%d, BW=%s, CR=%d, Public_Network:%d, IQ_Inversion:%d", lora_radio_test_paras.rx_frequency,lora_radio_test_paras.sf, 
                                                                                                                                                                        bandwidth_string[lora_radio_test_paras.bw], lora_radio_test_paras.cr, 
                                                                                                                                                                        lora_radio_test_paras.public_network,lora_radio_test_paras.iq_inversion);
                        Radio.SetChannel( lora_radio_test_paras.rx_frequency );
                        Radio.Rx( 0 );
                    } else {
                        if (tx_only_flag == true) {
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Master Address(SA):[0x%X]\n",master_address);
                        }
                        PrivEvenTrigger(radio_event, EV_RADIO_TX_START);
                    }
                    break;
                    
                case EV_RADIO_RX_DONE:
                    if( master_flag == true ) {
                        if( BufferSize > 0 ) {
                            if( strncmp( ( const char* )Buffer + MAC_HEADER_OVERHEAD, ( const char* )PingMsg, 4 ) == 0 ) {
                                /* Indicates on a LED that the received frame is a PING ACK packet */
                                RX_LED_TOGGLE;
                                rx_correct_cnt++;

                                uint32_t slaver_addr = 0;
                                slaver_addr = Buffer[5];
                                slaver_addr |= Buffer[6] << 8;
                                slaver_addr |= Buffer[7] << 16;
                                slaver_addr |= Buffer[8] << 24;

                                uint32_t received_seqno = 0;
                                received_seqno = Buffer[9];
                                received_seqno |= Buffer[10] << 8;
                                received_seqno |= Buffer[11] << 16;
                                received_seqno |= Buffer[12] << 24;
                                
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Reply from [0x%X]:seqno=%d, bytes=%d,total time=%d ms,rssi=%d,snr=%d",slaver_addr, received_seqno, BufferSize, LORA_RADIO_TIMESTAMP_TO_MS( rx_timestamp - tx_timestamp ),rssi_value,snr_value );
                                
                                /* Send the next PING frame */
                                PrivEvenTrigger(radio_event, EV_RADIO_TX_START);
                                break;
                            } else /* valid reception but neither a PING ACK */ {   
                                Radio.SetChannel( lora_radio_test_paras.rx_frequency );
                                Radio.Rx( RX_TIMEOUT_VALUE );
                            }
                        } else {
                            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "RX ERR:BufferSize = 0");
                        }
                    } else {
                        if( BufferSize > 0 ) {
                            #define DST_ADDRESS_OFFSET 5
                            uint32_t dst_address = Buffer[DST_ADDRESS_OFFSET] | \
                                                    ( Buffer[DST_ADDRESS_OFFSET+1] << 8 ) |\
                                                    ( Buffer[DST_ADDRESS_OFFSET+2] << 16 )|\
                                                    ( Buffer[DST_ADDRESS_OFFSET+3] << 24); 

                            if( rx_only_flag == true ) {
                                /* Indicates on a LED that the received frame */
                                RX_LED_TOGGLE;
                            
                                uint32_t src_addr,dst_addr = 0;
                                src_addr = Buffer[1];
                                src_addr |= Buffer[2] << 8;
                                src_addr |= Buffer[3] << 16;
                                src_addr |= Buffer[4] << 24;

                                dst_addr = Buffer[5];
                                dst_addr |= Buffer[6] << 8;
                                dst_addr |= Buffer[7] << 16;
                                dst_addr |= Buffer[8] << 24;
                                
                                rx_correct_cnt++;
                                
                                /* RX continuous */
                                Radio.SetChannel( lora_radio_test_paras.rx_frequency );
                                Radio.Rx( 0 ); 
                
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Received: Totals=%d,bytes=%d,timestamp=%d,rssi=%d,snr=%d\n",rx_correct_cnt, BufferSize, rx_timestamp, rssi_value, snr_value );

                            } else if( ( dst_address == slaver_address || dst_address == 0xFFFFFFFF ) && \
                                ( strncmp( ( const char* )Buffer + MAC_HEADER_OVERHEAD, ( const char* )PingMsg, 4 ) == 0 )) {
                                /* Indicates on a LED that the received frame is a PING */
                                RX_LED_TOGGLE;
                                /* echo the receive packet to master */
                                {
                                    /* wait for master going to be ready to rx */
                                    LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Slave send data size %d back\n", BufferSize);
                                    PrivTaskDelay(100);
                                    Radio.SetChannel( lora_radio_test_paras.tx_frequency );
                                    Radio.Send( Buffer, BufferSize );
                                }
                            } else /* valid reception but not a PING as expected */ {    
                                Radio.SetChannel( lora_radio_test_paras.rx_frequency );
                                Radio.Rx( 0 ); 
                            }
                        }
                    }
                    break;
            case EV_RADIO_TX_DONE:
                /* Indicates on a LED that we have sent a PING [Master] */
                /* Indicates on a LED that we have sent a PING ACK [Slave] */
                TX_LED_TOGGLE;
                if (tx_only_flag == false) {
                    radio_rx();
                } else if (tx_seq_cnt < tx_continues) {
                    PrivTaskDelay(1000);
                    PrivEvenTrigger(radio_event, EV_RADIO_TX_START);
                } else {
                    printf("############LoRa Tx Done#############\n");
                }
                break;
            case EV_RADIO_RX_TIMEOUT:
                rx_timeout_cnt++;
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Request [SA=0x%X] timed out: seqno=%d, time=%d ms", slaver_address, tx_seq_cnt, LORA_RADIO_TIMESTAMP_TO_MS( rx_timestamp - tx_timestamp ));
            case EV_RADIO_RX_ERROR:
            case EV_RADIO_TX_START:
                    if( master_flag == true && status != EV_RADIO_RX_ERROR ) {
                        if (tx_only_flag == true) {
                            uint32_t packet_toa = Radio.TimeOnAir(lora_radio_test_paras.modem,lora_radio_test_paras.bw,lora_radio_test_paras.sf,lora_radio_test_paras.cr,LORA_PREAMBLE_LENGTH, LORA_FIX_LENGTH_PAYLOAD_ON_DISABLE,payload_len,true);

                            Radio.SetPublicNetwork( lora_radio_test_paras.public_network );

                            Radio.SetTxConfig( MODEM_LORA, lora_radio_test_paras.txpower, 0, lora_radio_test_paras.bw,
                                                            lora_radio_test_paras.sf, lora_radio_test_paras.cr,
                                                            LORA_PREAMBLE_LENGTH, LORA_FIX_LENGTH_PAYLOAD_ON_DISABLE,
                                                            true, 0, 0, lora_radio_test_paras.iq_inversion, tx_timeout );

                            
                            if (tx_seq_cnt < tx_continues) {
                                send_ping_packet(master_address,slaver_address,payload_len);
                            }
                        } else {
                            /* tx_seq_cnt start from 0 */
                            if( tx_seq_cnt < max_tx_nbtrials ) {
                                /* for first time to printf some info */
                                if( !tx_seq_cnt ) {
                                    uint32_t packet_toa = Radio.TimeOnAir(lora_radio_test_paras.modem,lora_radio_test_paras.bw,lora_radio_test_paras.sf,lora_radio_test_paras.cr,LORA_PREAMBLE_LENGTH, LORA_FIX_LENGTH_PAYLOAD_ON_DISABLE,payload_len,true);
                                    LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Master Address(MA):[0x%X]",master_address);
                                    LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Pinging [SA=0x%X] with %u bytes(ToA=%d ms) of data for %d counters:", slaver_address, payload_len, packet_toa, max_tx_nbtrials);
                                    LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "With radio parameters: tx freq=%d, rx freq=%d, TxPower=%d, SF=%d, BW=%s, CR=%d, Public_Network:%d, IQ_Inversion:%d", lora_radio_test_paras.tx_frequency,lora_radio_test_paras.rx_frequency, lora_radio_test_paras.txpower, 
                                                                                                                                                                                            lora_radio_test_paras.sf, bandwidth_string[lora_radio_test_paras.bw], lora_radio_test_paras.cr,
                                                                                                                                                                                            lora_radio_test_paras.public_network,lora_radio_test_paras.iq_inversion);
                                }

                                send_ping_packet(master_address,slaver_address,payload_len);
                            } else {
                                uint16_t per = 100 - ( (float) rx_correct_cnt / tx_seq_cnt ) * 100;
                                uint32_t tx_total_byte = tx_seq_cnt * ( payload_len + MAC_HEADER_OVERHEAD );
                                uint32_t tx_total_kbyte_integer = tx_total_byte >> 10;   // / 1024
                                uint32_t tx_total_kbyte_decimal = tx_total_byte & 0x3FF; // % 1024
                                
                                uint32_t rx_total_byte = rx_correct_cnt * ( payload_len + MAC_HEADER_OVERHEAD );
                                uint32_t rx_total_kbyte_integer = rx_total_byte >> 10;   // / 1024
                                uint32_t rx_total_kbyte_decimal = rx_total_byte & 0x3FF; // % 1024
                                int32_t avg_rssi = -255;
                                int32_t avg_snr = -128;
                                if( rx_correct_cnt ) {
                                    avg_rssi = rssi_value_total / (int32_t)rx_correct_cnt;
                                    avg_snr = snr_value_total / (int32_t)rx_correct_cnt;
                                }
                                /* wait for PHY log output done */
                                PrivTaskDelay(10);
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "\r\n====== LoRa Ping statistics for [MA=0x%X <-> SA=0x%X] with [TxPower=%d,SF=%d] ======",master_address, slaver_address, lora_radio_test_paras.txpower, lora_radio_test_paras.sf);
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "-> Tx pakcets: sent = %d, tx_total = %d.%d KByte",tx_seq_cnt, tx_total_kbyte_integer, tx_total_kbyte_decimal);       
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "-> Rx pakcets: received = %d, lost = %d, per = %d%, rx_total = %d.%d KByte",rx_correct_cnt, rx_timeout_cnt + rx_error_cnt, per,rx_total_kbyte_integer,rx_total_kbyte_decimal);   
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "--> Rx rssi: max_rssi = %d, min_rssi = %d, avg_rssi = %d",rssi_value_max,rssi_value_min,avg_rssi);       
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "--> Rx snr: max_snr  = %d, min_snr  = %d, avg_snr  = %d",snr_value_max,snr_value_min,avg_snr);
                                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "====== LoRa Ping Test Finished ======\r\n");
                            }
                        }
                    } else {
                        Radio.SetChannel( lora_radio_test_paras.rx_frequency );
                        Radio.Rx( 0 );
                    }
                    break;
                case EV_RADIO_TX_TIMEOUT:
                    radio_rx();
                    break;  
            }
        }
    }
}

/* for shell */
#define CMD_LORA_CHIP_PROBE_INDEX        0 // LoRa Chip probe
#define CMD_LORA_CHIP_CONFIG_INDEX       1 // tx config
#define CMD_LORA_TX_CW_INDEX             2 // tx cw
#define CMD_LORA_PING_INDEX              3 // ping-pong
#define CMD_LORA_RX_PACKET_INDEX         4 // rx packet only

const char* lora_help_info[] = 
{
    [CMD_LORA_CHIP_PROBE_INDEX]       = "lora probe                 - lora radio probe",
    [CMD_LORA_CHIP_CONFIG_INDEX]      = "lora config<para><val>     - config parameters<freq><freq_offset><power><sf><bw><public><iq>", 
    [CMD_LORA_TX_CW_INDEX]            = "lora cw <freq>,<power>     - tx carrier wave",
    [CMD_LORA_PING_INDEX]             = "lora ping <para1><..>      - ping <-m: master,-s: slaver>",   
    [CMD_LORA_RX_PACKET_INDEX]        = "lora rx <rx_only><timeout> - rx data (or sniffer)",  
};

/* LoRa Radio Test Shell */
int TestLoraRadio(int argc, char *argv[])
{
    size_t i = 0;
    
    if (argc < 2) {   
        /* parameter error */
        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Radio(%s) Usage:\n",LORA_RADIO_SW_VERSION);
        for (i = 0; i < sizeof(lora_help_info) / sizeof(char*); i++) 
        {
            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "%s", lora_help_info[i]);
        }
        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "\n");
    } else {
        const char *cmd0 = argv[1];

        if (!strcmp(cmd0, "check")) {   
            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Modules start to check using SPI");

            if( Radio.Check() ) {
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Modules check ok!");
                return 1;
            } else {
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Modules check failed!\n!");
                return -1;
            }
        }
				
        if( lora_radio_tester_init() == false ) {
            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Chip Init Failed");
            return 0;
        }
			
        if (!strcmp(cmd0, "probe")) {   
            LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Chip start to test");

            if( Radio.Check() ) {
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Chip Probe ok!");
            } else {
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "LoRa Chip Probe failed!\n!");
            }
        } else if (!strcmp(cmd0, "cw")) {
            uint8_t timeout = 0;
            if (argc >= 3) {
                lora_radio_test_paras.tx_frequency = atol(argv[2]);
            }
            if (argc >= 4) {
                lora_radio_test_paras.txpower = atol(argv[3]);
            }
            if (argc >= 5) {
                timeout = atol(argv[4]);
            }
            Radio.SetTxContinuousWave( lora_radio_test_paras.tx_frequency, lora_radio_test_paras.txpower, timeout);
        } else if (!strcmp(cmd0, "ping")) {       
            /* default for slaver */
            master_flag  = false;  
            rx_only_flag = false;
            
            if (argc >= 3) {   
                const char *cmd1 = argv[2];
                if (!strcmp(cmd1, "-m")) {
                    master_flag = true;
                } else {// -s 
                    master_flag = false;
                }
                
                if( argc >= 4 ) {
                    /* max_tx_nbtrials for setup tx counter */
                    max_tx_nbtrials = atol(argv[3]);
                }
                
                if( argc >= 5 ) {
                    /* payload_len for setup tx payload length */
                    payload_len = atoi(argv[4]);
                    
                    if( payload_len < MIN_TETS_APP_DATA_SIZE )
                    {
                        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Waring: This size will not supported [lora ping]");
                    }
                }
                
                if( argc >= 6 ) {
                    /* rxtimeout  */
                    rx_timeout = atoi(argv[5]);
                }
                
                if( argc >= 7 ) {
                    /* txtimeout*/
                    tx_timeout = atoi(argv[6]);
                }
            } 
            PrivEvenTrigger(radio_event, EV_RADIO_INIT);
        } else if(!strcmp(cmd0, "rx")) {   
            /* eg: lora rx 1 0 */
            master_flag = false;
            rx_only_flag = true;
            
            if (argc >= 3) {
                rx_only_flag = atol(argv[2]);
            }
            if (argc >= 4) {
                rx_timeout = atol(argv[3]);
            }
            PrivEvenTrigger(radio_event, EV_RADIO_INIT);
        } else if(!strcmp(cmd0, "tx")) {   
            /* eg: lora tx 1 0 1 */
            master_flag = true;
            tx_only_flag = true;
            tx_continues = 4;
            
            if (argc >= 3) {
                tx_only_flag = atol(argv[2]);
            }
            if (argc >= 4) {
                tx_timeout = atol(argv[3]);
            }
            if (argc >= 5) {
                tx_continues = atol(argv[4]);
            }
            PrivEvenTrigger(radio_event, EV_RADIO_INIT);
        } else if(!strcmp(cmd0, "txdone")) {  
            tx_continues = false; 
        } else if (!strcmp(cmd0, "config")) {
            const char *cmd1 = argv[2];
       
            /* config radio paramters, such as frequency,txPower,sf,bw...*/
            if (!strcmp(cmd1, "freq"))  
            {
                if (argc >= 4) {                    
                    lora_radio_test_paras.tx_frequency = atol(argv[3]);
                }
                // RX = TX + offset
                lora_radio_test_paras.rx_frequency = lora_radio_test_paras.tx_frequency + lora_radio_test_paras.trx_frequency_offset;
                
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Tx Frequency: %d",lora_radio_test_paras.tx_frequency);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Rx Frequency: %d",lora_radio_test_paras.rx_frequency);
            } else if (!strcmp(cmd1, "foffset")) {
                if (argc >= 4) {                    
                    lora_radio_test_paras.trx_frequency_offset = atol(argv[3]);
                }
                
                lora_radio_test_paras.rx_frequency = lora_radio_test_paras.tx_frequency + lora_radio_test_paras.trx_frequency_offset;
             
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Tx and Rx Frequency Offset: %d",lora_radio_test_paras.trx_frequency_offset);
            } else if (!strcmp(cmd1, "power")) {
                if (argc >= 4) {
                    lora_radio_test_paras.txpower = atoi(argv[3]);
                }
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "TxPower  : %d",lora_radio_test_paras.txpower);
            } else if (!strcmp(cmd1, "sf")) {
                if (argc >= 4) {
                    if (!strcmp(argv[3], "?")) {
                        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "SF:7|8|9|10|11|12");
                    } else {                        
                        lora_radio_test_paras.sf = atoi(argv[3]);
                    }
                }
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "SF: %d",lora_radio_test_paras.sf);
            } else if (!strcmp(cmd1, "bw")) {
                uint16_t bw;
                if (argc >= 4) {
                    if (!strcmp(argv[3], "?")) {
                        LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "BW:0(125kHz)|1(250kHz)|2(500kHz)");
                    } else {
                        bw = atoi(argv[3]);
                    }
                    
                    if(bw == 125) {
                        lora_radio_test_paras.bw = 0;
                    } else if(bw == 250) {
                        lora_radio_test_paras.bw = 1;
                    } else if(bw == 500) {
                        lora_radio_test_paras.bw = 2;
                    }
                }
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "BW: %d(%s)",lora_radio_test_paras.bw, bandwidth_string[lora_radio_test_paras.bw]);
            } else if (!strcmp(cmd1, "public")) {
                if (argc >= 4) {
                    lora_radio_test_paras.public_network = atoi(argv[3]);
                }
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "Public Network: %d",lora_radio_test_paras.public_network);
            } else if (!strcmp(cmd1, "iq")) {
                if (argc >= 4) {
                    lora_radio_test_paras.iq_inversion = atoi(argv[3]);
                }
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "IQ Inversion: %d",lora_radio_test_paras.iq_inversion);
            }
            if (argc < 3) {
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, "-items-        -{cmd}-   -Value-");
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " Tx Freq        {freq}:   %d",lora_radio_test_paras.tx_frequency);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " Rx Freq        {N.A.}:   %d",lora_radio_test_paras.rx_frequency);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " RX Freq Offset {foffset}:%d",lora_radio_test_paras.trx_frequency_offset);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " TxPower        {power}:  %d",lora_radio_test_paras.txpower);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " SF             {sf}:     %d",lora_radio_test_paras.sf);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " BW             {bw}:     %d(%s kHz)",lora_radio_test_paras.bw,bandwidth_string[lora_radio_test_paras.bw]);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " Public Network {public}: %d",lora_radio_test_paras.public_network);
                LORA_RADIO_DEBUG_LOG(LR_DBG_SHELL, LOG_LVL_INFO, " IQ Inversion   {iq}:     %d",lora_radio_test_paras.iq_inversion);
            }
        }            
    }
    return 1;
}
PRIV_SHELL_CMD_FUNCTION(TestLoraRadio, lora radio driver test, PRIV_SHELL_CMD_MAIN_ATTR);
#endif
