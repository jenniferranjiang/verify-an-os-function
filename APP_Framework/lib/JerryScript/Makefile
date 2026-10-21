SRC_FILES :=
SRC_FILES += jerryscript/build/lib/libjerry-core.a \
             jerryscript/build/lib/libjerry-ext.a  \
             jerryscript/build/lib/libjerry-math.a

ifeq ($(CONFIG_BOARD_STM32F407_EVB),y)
SRC_FILES += mcu/stm32f4/setjmp.S
endif

ifeq ($(CONFIG_BOARD_CORTEX_M4_EVB),y)
SRC_FILES += mcu/cortex-m4-emulator/setjmp.S
endif

ifeq ($(CONFIG_BOARD_EDU_ARM32_EVB),y)
SRC_FILES += mcu/hc32f4a0/setjmp.S
endif

SRC_FILES += jerry_port.c jerry_main.c

include $(KERNEL_ROOT)/compiler.mk
