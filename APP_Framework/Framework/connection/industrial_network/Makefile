SRC_DIR := 

ifeq ($(CONFIG_CONNECTION_ADAPTER_POWERLINK),y)
	SRC_DIR += powerlink
endif

ifeq ($(CONFIG_CONNECTION_ADAPTER_ETHERCAT),y)
	SRC_DIR += ethercat
endif

ifeq ($(CONFIG_CONNECTION_ADAPTER_FREEMODBUSTCP),y)
	SRC_DIR += freemodbus_tcp
endif

include $(KERNEL_ROOT)/compiler.mk
