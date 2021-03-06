# Copyright 2011 The Android Open Source Project
#
# This file was modified by Dolby Laboratories, Inc. The portions of the
# code that are surrounded by "DOLBY..." are copyrighted and
# licensed separately, as follows:
#
#  (C) 2012-2014 Dolby Laboratories, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#AUDIO_POLICY_TEST := true
#ENABLE_AUDIO_DUMP := true

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    AudioHardwareInterface.cpp \
    audio_hw_hal.cpp

LOCAL_MODULE := libaudiohw_legacy
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libmedia_helper

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    AudioPolicyManagerBase.cpp \
    AudioPolicyCompatClient.cpp \
    audio_policy_hal.cpp

ifeq ($(AUDIO_POLICY_TEST),true)
  LOCAL_CFLAGS += -DAUDIO_POLICY_TEST
endif

ifneq ($(strip $(AUDIO_FEATURE_DISABLED_FM)),true)
LOCAL_CFLAGS += -DAUDIO_EXTN_FM_ENABLED
endif
ifneq ($(strip $(AUDIO_FEATURE_DISABLED_SSR)),true)
LOCAL_CFLAGS += -DAUDIO_EXTN_SSR_ENABLED
endif
ifneq ($(strip $(AUDIO_FEATURE_DISABLED_PROXY_DEVICE)),true)
LOCAL_CFLAGS += -DAUDIO_EXTN_AFE_PROXY_ENABLED
endif
ifneq ($(strip $(AUDIO_FEATURE_DISABLED_INCALL_MUSIC)),true)
LOCAL_CFLAGS += -DAUDIO_EXTN_INCALL_MUSIC_ENABLED
endif
ifneq ($(strip $(AUDIO_FEATURE_DISABLED_FORMATS)),true)
LOCAL_CFLAGS += -DAUDIO_EXTN_FORMATS_ENABLED
endif
ifneq ($(strip $(AUDIO_FEATURE_DISABLED_COMPRESS_VOIP)),true)
LOCAL_CFLAGS += -DAUDIO_EXTN_COMPRESS_VOIP_ENABLED
endif
ifneq ($(strip $(AUDIO_FEATURE_DISABLED_DS1_DOLBY_DDP)),true)
LOCAL_CFLAGS += -DAUDIO_EXTN_DS1_DOLBY_DDP_ENABLED
endif
ifdef DOLBY_UDC
  LOCAL_CFLAGS += -DDOLBY_UDC
endif #DOLBY_UDC
ifdef DOLBY_DAP
    ifdef DOLBY_DAP_OPENSLES
        LOCAL_CFLAGS += -DDOLBY_DAP_OPENSLES
        LOCAL_C_INCLUDES += $(TOP)/vendor/dolby/ds1/libds/include/
    endif
endif #DOLBY_END

LOCAL_STATIC_LIBRARIES := libmedia_helper
LOCAL_MODULE := libaudiopolicy_legacy
LOCAL_MODULE_TAGS := optional

include $(BUILD_STATIC_LIBRARY)

# The default audio policy, for now still implemented on top of legacy
# policy code
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    AudioPolicyManagerDefault.cpp

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libutils \
    liblog

LOCAL_STATIC_LIBRARIES := \
    libmedia_helper

LOCAL_WHOLE_STATIC_LIBRARIES := \
    libaudiopolicy_legacy

LOCAL_MODULE := audio_policy.default
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

#ifeq ($(ENABLE_AUDIO_DUMP),true)
#  LOCAL_SRC_FILES += AudioDumpInterface.cpp
#  LOCAL_CFLAGS += -DENABLE_AUDIO_DUMP
#endif
#
#ifeq ($(strip $(BOARD_USES_GENERIC_AUDIO)),true)
#  LOCAL_CFLAGS += -D GENERIC_AUDIO
#endif

#ifeq ($(BOARD_HAVE_BLUETOOTH),true)
#  LOCAL_SRC_FILES += A2dpAudioInterface.cpp
#  LOCAL_SHARED_LIBRARIES += liba2dp
#  LOCAL_C_INCLUDES += $(call include-path-for, bluez)
#
#  LOCAL_CFLAGS += \
#      -DWITH_BLUETOOTH \
#endif
#
#include $(BUILD_SHARED_LIBRARY)

#    AudioHardwareGeneric.cpp \
#    AudioHardwareStub.cpp \
