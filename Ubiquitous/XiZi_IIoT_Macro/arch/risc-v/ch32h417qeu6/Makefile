ifeq ($(CONFIG_RISC_V3F),y)
SRC_FILES := boot_v3f.S
endif
ifeq ($(CONFIG_RISC_V5F),y)
SRC_FILES := boot_v5f.S
endif
SRC_FILES += interrupt.c tick.c switch.S prepare_rhwstack.c interrupt_switch.S
SRC_DIR := Core Debug

include $(KERNEL_ROOT)/compiler.mk
