ifeq ($(CONFIG_CONTROL_PROTOCOL_MODBUS_TCP), y)
	SRC_DIR := modbus_tcp
endif

ifeq ($(CONFIG_CONTROL_PROTOCOL_MODBUS_UART), y)
	SRC_DIR := modbus_uart
endif

ifeq ($(CONFIG_CONTROL_PROTOCOL_ETHERCAT), y)
	SRC_DIR := ethercat
endif

include $(KERNEL_ROOT)/compiler.mk

