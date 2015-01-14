ifeq ($(TARGET_HW_KEYMASTER_V03),true)
LOCAL_PATH := $(call my-dir)

ifneq ($(filter msm8960 msm8226 msm8974 msm8610 msm8084 apq8084 msm8916 msm8992 msm8994,$(TARGET_BOARD_PLATFORM)),)

keymaster-def := -fvisibility=hidden -Wall
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
ifneq ($(filter msm8960 msm8226 msm8974 msm8610 msm8084 apq8084,$(TARGET_BOARD_PLATFORM)),)
keymaster-def += -D_ION_HEAP_MASK_COMPATIBILITY_WA
endif
else
ifeq ($(TARGET_BOARD_PLATFORM),msm8084)
keymaster-def += -D_ION_HEAP_MASK_COMPATIBILITY_WA
endif
endif

include $(CLEAR_VARS)

LOCAL_MODULE := keystore.$(TARGET_BOARD_PLATFORM)

LOCAL_MODULE_RELATIVE_PATH := hw

LOCAL_SRC_FILES := keymaster_qcom.cpp

LOCAL_C_INCLUDES := $(TARGET_OUT_HEADERS)/common/inc \
                    $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include \
                    external/openssl/include

LOCAL_CFLAGS := $(keymaster-def)

LOCAL_SHARED_LIBRARIES := \
        libcrypto \
        liblog \
        libc \
        libdl \
        libcutils

LOCAL_ADDITIONAL_DEPENDENCIES := \
    $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr \
    $(LOCAL_PATH)/Android.mk

LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

endif # TARGET_BOARD_PLATFORM
else
LOCAL_MODULE := keystore.qcom
$(info Removing keymaster v0.3 bins)
$(shell rm -rf $(TARGET_OUT_INTERMEDIATES)/SHARED_LIBRARIES/$(LOCAL_MODULE)_intermediates )
$(shell rm -rf $(TARGET_OUT)/lib/hw/$(LOCAL_MODULE).so )
$(shell rm -rf $(TARGET_OUT)/lib64/hw/$(LOCAL_MODULE).so )
$(shell rm -rf $(TARGET_OUT)/../symbols/system/lib/hw/$(LOCAL_MODULE).so )
$(shell rm -rf $(TARGET_OUT_INTERMEDIATES)/lib/$(LOCAL_MODULE).so )
$(shell rm -fr $(TARGET_OUT_INTERMEDIATES)/lib64/$(LOCAL_MODULE).so )

endif # end of TARGET_HW_KEYMASTER_V03
