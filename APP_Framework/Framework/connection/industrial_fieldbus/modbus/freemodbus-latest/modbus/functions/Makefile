SRC_FILES := mbfuncother.c mbutils.c mbfuncdiag.c
 
ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU_MASTER),y)
	SRC_FILES += mbfunccoils_m.c mbfuncdisc_m.c mbfuncholding_m.c mbfuncinput_m.c
endif

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_RTU_SLAVE),y)
	SRC_FILES += mbfunccoils.c mbfuncdisc.c mbfuncholding.c mbfuncinput.c
endif

ifeq ($(CONFIG_CONNECTION_MODBUS_USING_TCP_SLAVE),y)
	SRC_FILES += mbfunccoils.c mbfuncdisc.c mbfuncholding.c mbfuncinput.c
endif

include $(KERNEL_ROOT)/compiler.mk
