#ifndef XS_CONFIG_H__
#define XS_CONFIG_H__

/*  Automatically generated file; DO NOT EDIT. */
/*  XiZi_IIoT Project Configuration */

#define BOARD_STM32F103_NANO
#define ARCH_ARM

/*  stm32f103-nano feature */

#define BSP_USING_UART
#define BSP_USING_UART2
#define SERIAL_BUS_NAME_2 "uart2"
#define SERIAL_DRV_NAME_2 "uart2_drv"
#define SERIAL_2_DEVICE_NAME_0 "uart2_dev2"
#define BSP_USING_CAN
#define CAN_BUS_NAME_1 "can1"
#define CAN_DRIVER_NAME "can1_drv"
#define CAN_1_DEVICE_NAME_1 "can1_dev1"

/*  config default board resources */

/*  config board app name */

#define BOARD_APP_NAME "/XiUOS_stm32f103nano_app.bin"

/*  config board service table */

#define SERVICE_TABLE_ADDRESS 0x20000000

/*  Hardware feature */

#define RESOURCES_SERIAL
#define SERIAL_RB_BUFSZ 128
#define RESOURCES_CAN

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
#define TICK_PER_SECOND 1000
#define KERNEL_STACK_OVERFLOW_CHECK
#define IDLE_KTASK_STACKSIZE 256
#define ZOMBIE_KTASK_STACKSIZE 512

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

#define SHELL_TASK_STACK_SIZE 512
#define SHELL_TASK_PRIORITY 20
#define SHELL_MAX_NUMBER 5
#define SHELL_PARAMETER_MAX_NUMBER 8
#define SHELL_HISTORY_MAX_NUMBER 5
#define SHELL_PRINT_BUFFER 128
#define SHELL_HELP_SHOW_PERMISSION

/*  Kernel data structure Manage */

#define KERNEL_QUEUEMANAGE
#define KERNEL_WORKQUEUE
#define WORKQUEUE_KTASK_STACKSIZE 2048
#define WORKQUEUE_KTASK_PRIORITY 23
#define QUEUE_MAX 16
#define KERNEL_WAITQUEUE
#define KERNEL_DATAQUEUE

/*  Kernel components init */

#define KERNEL_COMPONENTS_INIT
#define ENV_INIT_KTASK_STACK_SIZE 512
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


/*  Tool feature */

/*  OTA function */


/*  APP_Framework */

/*  Framework */

#define TRANSFORM_LAYER_ATTRIUBUTE
#define ADD_XIZI_FEATURES

/*  Security */


/*  Applications */

/*  config stack size and priority of main task */

#define MAIN_KTASK_STACK_SIZE 256
#define MAIN_KTASK_PRIORITY 16

/*  ota app */


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


/*  lib using embedded_database */


/*  lib using LoRaWan */


#endif
