SRC_FILES := mbcrc.c 

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU_MASTER),y)
	SRC_FILES += mbrtu_m.c
endif

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU_SLAVE),y)
	SRC_FILES += mbrtu.c
endif

include $(KERNEL_ROOT)/compiler.mk
