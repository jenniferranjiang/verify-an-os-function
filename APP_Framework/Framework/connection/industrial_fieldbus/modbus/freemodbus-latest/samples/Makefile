ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU_MASTER),y)
	SRC_FILES := sample_mb_master.c
endif

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU_SLAVE),y)
	SRC_FILES := sample_mb_slave.c
endif

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_TCP_SLAVE),y)
	SRC_FILES := sample_mb_slave.c
endif

include $(KERNEL_ROOT)/compiler.mk
