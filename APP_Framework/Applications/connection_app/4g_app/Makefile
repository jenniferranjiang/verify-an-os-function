SRC_FILES := 4g_app.c

ifeq ($(CONFIG_DEVICE_ADL400),y)
	SRC_FILES += ch32v208_adl400.c
endif

ifeq ($(CONFIG_DEVICE_DTZ178),y)
	SRC_FILES += ch32v208_dtz178.c
endif

ifeq ($(CONFIG_DEVICE_DTSD342),y)
	SRC_FILES += ch32v208_dtsd342.c
endif

include $(KERNEL_ROOT)/compiler.mk
