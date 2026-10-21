ifeq ($(CONFIG_ADD_XIZI_FEATURES),y)
SRC_FILES := modbus_tcp.c test_modbus_tcp.c
include $(KERNEL_ROOT)/compiler.mk
endif

include $(KERNEL_ROOT)/.config
ifeq ($(CONFIG_ADD_NUTTX_FEATURES),y)
    include $(APPDIR)/Make.defs
    CSRCS += modbus_tcp.c test_modbus_tcp.c
    include $(APPDIR)/Application.mk
endif
