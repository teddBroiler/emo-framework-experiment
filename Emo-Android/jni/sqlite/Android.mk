SQLITE_SRC_FILES :=\
	sqlite/shell.c \
	sqlite/sqlite3.c \

SQLITE_C_INCLUDES := $(call include-path-for, system-core)/cutils $(LOCAL_PATH)/sqlite
SQLITE_CFLAGS := -DHAVE_USLEEP=1 -DSQLITE_DEFAULT_JOURNAL_SIZE_LIMIT=1048576 -DSQLITE_THREADSAFE=1 -DNDEBUG=1 -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1 -DSQLITE_DEFAULT_AUTOVACUUM=1 -DSQLITE_TEMP_STORE=3 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_BACKWARDS -DSQLITE_ENABLE_POISON -Dfdatasync=fsync
SQLITE_SHARED_LIBRARIES := liblog libicuuc libicui18n

ifneq ($(TARGET_ARCH),arm)
	SQLITE_LDLIBS := -lpthread -ldl
endif
