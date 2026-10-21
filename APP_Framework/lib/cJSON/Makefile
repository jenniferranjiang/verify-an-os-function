SRC_FILES :=  cJSON.c
ifeq ($(CONFIG_USER_TEST_MQTTCLIENT),y)
	SRC_FILES +=  cJSON_Process.c
endif

include $(KERNEL_ROOT)/compiler.mk
