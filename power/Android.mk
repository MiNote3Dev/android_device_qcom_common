LOCAL_PATH := $(call my-dir)

# Hey Mr. Make Author, DIAF PLX
ifeq ($(TARGET_POWERHAL_VARIANT),qcom)
USE_ME := true
endif

ifneq (,$(filter true,$(USE_ME) $(WITH_QC_PERF)))

# HAL module implemenation stored in
# hw/<POWERS_HARDWARE_MODULE_ID>.<ro.hardware>.so
include $(CLEAR_VARS)

LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_PROPRIETARY_MODULE := true
LOCAL_SHARED_LIBRARIES := liblog libcutils libdl libxml2
LOCAL_SRC_FILES := power.c metadata-parser.c utils.c list.c hint-data.c powerhintparser.c
LOCAL_C_INCLUDES := external/libxml2/include \
                    external/icu/icu4c/source/common

ifneq ($(BOARD_POWER_CUSTOM_BOARD_LIB),)
  LOCAL_WHOLE_STATIC_LIBRARIES += $(BOARD_POWER_CUSTOM_BOARD_LIB)
else

# Include target-specific files.
ifeq ($(call is-board-platform-in-list, msm8974), true)
LOCAL_SRC_FILES += power-8974.c
endif

ifeq ($(call is-board-platform-in-list, msm8960), true)
LOCAL_SRC_FILES += power-8960.c
endif

ifeq ($(call is-board-platform-in-list, msm8226), true)
LOCAL_SRC_FILES += power-8226.c
endif

ifeq ($(call is-board-platform-in-list, msm8610), true)
LOCAL_SRC_FILES += power-8610.c
endif

ifeq ($(call is-board-platform-in-list, msm8909), true)
LOCAL_SRC_FILES += power-8909.c
endif

ifeq ($(call is-board-platform-in-list, msm8916), true)
LOCAL_SRC_FILES += power-8916.c
endif

ifeq ($(call is-board-platform-in-list, msm8952), true)
LOCAL_SRC_FILES += power-8952.c
endif

ifeq ($(call is-board-platform-in-list, msm8937 msm8953), true)
LOCAL_SRC_FILES += power-8937.c
LOCAL_CFLAGS += -DMPCTLV3
endif

ifeq ($(call is-board-platform-in-list, apq8084), true)
LOCAL_SRC_FILES += power-8084.c
endif

ifeq ($(call is-board-platform-in-list, msm8992), true)
LOCAL_SRC_FILES += power-8992.c
endif

ifeq ($(call is-board-platform-in-list, msm8994), true)
LOCAL_SRC_FILES += power-8994.c
endif

ifeq ($(call is-board-platform-in-list, msm8996), true)
LOCAL_SRC_FILES += power-8996.c
LOCAL_CFLAGS += -DMPCTLV3
endif

ifeq ($(call is-board-platform-in-list,msm8998), true)
LOCAL_SRC_FILES += power-8998.c
LOCAL_CFLAGS += -DMPCTLV3
endif

ifeq ($(call is-board-platform-in-list,sdm660), true)
LOCAL_SRC_FILES += power-660.c
LOCAL_CFLAGS += -DMPCTLV3
endif

endif  #  End of board specific list

ifneq ($(TARGET_POWERHAL_SET_INTERACTIVE_EXT),)
LOCAL_CFLAGS += -DSET_INTERACTIVE_EXT
LOCAL_SRC_FILES += ../../../../$(TARGET_POWERHAL_SET_INTERACTIVE_EXT)
endif

ifneq ($(TARGET_TAP_TO_WAKE_NODE),)
  LOCAL_CFLAGS += -DTAP_TO_WAKE_NODE=\"$(TARGET_TAP_TO_WAKE_NODE)\"
endif

ifeq ($(TARGET_POWER_SET_FEATURE_LIB),)
  LOCAL_SRC_FILES += power-feature-default.c
else
  LOCAL_STATIC_LIBRARIES += $(TARGET_POWER_SET_FEATURE_LIB)
endif

ifneq ($(CM_POWERHAL_EXTENSION),)
LOCAL_MODULE := power.$(CM_POWERHAL_EXTENSION)
else
LOCAL_MODULE := power.$(TARGET_BOARD_PLATFORM)
endif
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS += -Wno-unused-parameter -Wno-unused-variable
include $(BUILD_SHARED_LIBRARY)

endif # TARGET_POWERHAL_VARIANT == qcom || WITH_QC_PERF
