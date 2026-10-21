SRC_DIR := freemodbus-latest

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU),y)
	SRC_FILES :=
endif

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_TCP),y)
	SRC_FILES :=
endif

include $(KERNEL_ROOT)/compiler.mk
