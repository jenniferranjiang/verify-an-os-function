ifeq ($(BOARD), jh7110)
SRC_DIR := fs shell lib boards tools app
else ifeq ($(BOARD), zynq7000-zc702)
SRC_DIR := fs shell lib boards semaphore tools app
else 
SRC_DIR := fs shell lib boards drivers semaphore tools app 
endif

include $(KERNEL_ROOT)/compiler.mk
