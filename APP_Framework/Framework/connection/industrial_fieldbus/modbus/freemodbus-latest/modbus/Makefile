SRC_DIR := functions

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU),y)
	SRC_DIR += rtu

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU_MASTER),y)
	SRC_FILES += mb_m.c
endif

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU_SLAVE),y)
	SRC_FILES += mb.c
endif

endif

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_TCP),y)
	SRC_DIR += tcp

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_TCP_SLAVE),y)
	SRC_FILES += mb.c
endif

endif

include $(KERNEL_ROOT)/compiler.mk
