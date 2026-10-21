ifeq ($(CONFIG_ADD_XIZI_FEATURES),y)
	SRC_FILES := sqlite3.c dbhelper.c
	SRC_DIR := xizi_port

	ifeq ($(CONFIG_LIB_SQLITE_EXAMPLE),y)
		SRC_FILES += student_dao.c
	endif

	include $(KERNEL_ROOT)/compiler.mk
endif
