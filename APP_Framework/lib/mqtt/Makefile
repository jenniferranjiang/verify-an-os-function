ifeq ($(CONFIG_XIUOS_PLATFORM),y)
  SRC_FILES := platform_mqtt.c
endif

ifeq ($(CONFIG_ALIBABA_PLATFORM),y)
  SRC_FILES := platform_mqtt.c  utils_hmacsha1.c
endif

include $(KERNEL_ROOT)/compiler.mk