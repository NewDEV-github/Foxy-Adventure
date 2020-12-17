LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := "website_dl"
LOCAL_SRC_FILES := ../../../src/website_dl.c
LOCAL_C_INCLUDES := ../godot_headers godot_headers
LOCAL_EXPORT_C_INCLUDE_DIRS := ../godot_headers godot_headers
include $(BUILD_SHARED_LIBRARY)