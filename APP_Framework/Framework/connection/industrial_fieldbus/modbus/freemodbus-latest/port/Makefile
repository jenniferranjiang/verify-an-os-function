SRC_FILES := port.c
 
ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU_MASTER),y)
	SRC_FILES += portevent_m.c portserial_m.c porttimer_m.c user_mb_app_m.c
endif

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU_SLAVE),y)
	SRC_FILES += portevent.c portserial.c porttimer.c user_mb_app.c
endif

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_TCP_SLAVE),y)
	SRC_FILES += porttcp.c portevent.c porttimer.c user_mb_app.c
endif

include $(KERNEL_ROOT)/compiler.mk
