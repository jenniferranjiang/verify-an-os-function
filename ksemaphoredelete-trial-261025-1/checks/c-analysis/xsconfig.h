#ifndef XS_CONFIG_H__
#define XS_CONFIG_H__

/*  Automatically generated file; DO NOT EDIT. */
/*  XiZi_IIoT Project Configuration */

#define BOARD_K210_EVB
#define LED0 24
#define LED1 25
// #define ARCH_CPU_64BIT
#define ARCH_RISCV
// #define ARCH_RISCV64

/*  kd233 feature */

#define BSP_USING_DMA
#define BSP_USING_GPIO
#define PIN_BUS_NAME "pin"
#define PIN_DRIVER_NAME "pin_drv"
#define PIN_DEVICE_NAME "pin_dev"
#define BSP_USING_PLIC
#define BSP_USING_SYSCLOCK
#define BSP_USING_UART
#define BSP_USING_UART_HS
#define SERIAL_BUS_NAME_0 "uart0"
#define SERIAL_DRV_NAME_0 "uart0_drv"
#define SERIAL_0_DEVICE_NAME_0 "uart0_dev0"
#define BSP_USING_UART1
#define BSP_UART1_TXD_PIN 20
#define BSP_UART1_RXD_PIN 21
#define SERIAL_BUS_NAME_1 "uart1"
#define SERIAL_DRV_NAME_1 "uart1_drv"
#define SERIAL_1_DEVICE_NAME_0 "uart1_dev1"
#define BSP_USING_UART2
#define BSP_UART2_TXD_PIN 28
#define BSP_UART2_RXD_PIN 27
#define SERIAL_BUS_NAME_2 "uart2"
#define SERIAL_DRV_NAME_2 "uart2_drv"
#define SERIAL_2_DEVICE_NAME_0 "uart2_dev2"
#define BSP_USING_UART3
#define BSP_UART3_TXD_PIN 22
#define BSP_UART3_RXD_PIN 23
#define SERIAL_BUS_NAME_3 "uart3"
#define SERIAL_DRV_NAME_3 "uart3_drv"
#define SERIAL_3_DEVICE_NAME_0 "uart3_dev3"

/*  config default board resources */

/*  config board app name */

#define BOARD_APP_NAME "/XiUOS_kd233_app.bin"

/*  config board service table */

#define SERVICE_TABLE_ADDRESS 0x80100000

/*  config board peripheral */

#define __STACKSIZE__ 4096

/*  Hardware feature */

#define RESOURCES_SERIAL
#define SERIAL_RB_BUFSZ 128
#define RESOURCES_PIN

/*  Kernel feature */

/*  separate compile(choose none for compile once) */

#define APP_STARTUP_FROM_FLASH

/*  Memory Management */

#define MEM_ALIGN_SIZE 8
#define MM_PAGE_SIZE 4096

/*  Using small memory allocator */

#define KERNEL_SMALL_MEM_ALLOC
#define SMALL_NUMBER_32B 64
#define SMALL_NUMBER_64B 32

/*  Task feature */

#define USER_APPLICATION

/*  Inter-Task communication */

#define KERNEL_SEMAPHORE
#define KERNEL_MUTEX
#define KERNEL_EVENT
#define KERNEL_MESSAGEQUEUE
#define KERNEL_SOFTTIMER
#define SCHED_POLICY_RR_REMAINSLICE
#define KTASK_PRIORITY_32
#define KTASK_PRIORITY_MAX 32
#define TICK_PER_SECOND 100
#define KERNEL_STACK_OVERFLOW_CHECK
#define IDLE_KTASK_STACKSIZE 1024
#define ZOMBIE_KTASK_STACKSIZE 2048

/*  Kernel Console */

#define KERNEL_CONSOLE
#define KERNEL_BANNER
#define KERNEL_CONSOLEBUF_SIZE 128

/*  Kernel Hook */


/*  Command shell */

#define TOOL_SHELL
#define SHELL_ENTER_CR
#define SHELL_ENTER_LF
#define SHELL_ENTER_CR_AND_LF

/*  Set shell user control */

#define SHELL_DEFAULT_USER "letter"
#define SHELL_DEFAULT_USER_PASSWORD ""
#define SHELL_LOCK_TIMEOUT 10000

/*  Set shell config param */

#define SHELL_TASK_STACK_SIZE 4096
#define SHELL_TASK_PRIORITY 20
#define SHELL_MAX_NUMBER 5
#define SHELL_PARAMETER_MAX_NUMBER 8
#define SHELL_HISTORY_MAX_NUMBER 5
#define SHELL_PRINT_BUFFER 128
#define SHELL_HELP_SHOW_PERMISSION

/*  Kernel data structure Manage */

#define KERNEL_QUEUEMANAGE
#define KERNEL_WORKQUEUE
#define WORKQUEUE_KTASK_STACKSIZE 512
#define WORKQUEUE_KTASK_PRIORITY 23
#define QUEUE_MAX 16
#define KERNEL_WAITQUEUE
#define KERNEL_DATAQUEUE

/*  Kernel components init */

#define KERNEL_COMPONENTS_INIT
#define ENV_INIT_KTASK_STACK_SIZE 8192
#define KERNEL_USER_MAIN
#define NAME_NUM_MAX 32

/*  hash table config */

#define ID_HTABLE_SIZE 16
#define ID_NUM_MAX 128

/*  Kernel Lib */

#define LIB
#define LIB_POSIX
#define LIB_NEWLIB

/*  C++ features */


/*  File system */

#define FS_VFS
#define VFS_USING_WORKDIR
#define FS_VFS_DEVFS
#define FS_VFS_FATFS

/*  Tool feature */

/*  OTA function */


/*  APP_Framework */

/*  Framework */

#define TRANSFORM_LAYER_ATTRIUBUTE
#define ADD_XIZI_FEATURES

/*  Security */


/*  Applications */

/*  config stack size and priority of main task */

#define MAIN_KTASK_STACK_SIZE 2048
#define MAIN_KTASK_PRIORITY 16

/*  test app */


/*  connection app */


/*  control app */

/*  knowing app */


/*  sensor app */


/*  app lib */

#define APP_SELECT_NEWLIB

/*  lib using cJSON */


/*  lib using queue */


/*  lib using LVGL */


/*  lvgl image display parameter settings */

#define LVGL_WIDTH 320
#define LVGL_HEIGHT 320

/*  lib using embedded_database */


/*  lib using LoRaWan */


/*  lib using MQTT */


/*  lib using JerryScript */


/*  lib using SQLite */


/*  lib using PikaPython */


#endif
