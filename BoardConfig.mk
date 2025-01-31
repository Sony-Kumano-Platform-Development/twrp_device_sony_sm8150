#
# Copyright 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This contains the module build definitions for the hardware-specific
# components for this device.
#
# As much as possible, those components should be built unconditionally,
# with device-specific names to avoid collisions, to avoid device-specific
# bitrot and build breakages. Building a component unconditionally does
# *not* include it on all devices, so it is safe even with hardware-specific
# components.

DEVICE_PATH := device/sony/griffin

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Assert
TARGET_OTA_ASSERT_DEVICE := J9110,J8110,J8170,J9150,J9180,SO-03L,SOV40,802SO

# A/B updater updatable partitions list. Keep in sync with the partition list
# with "_a" and "_b" variants in the device. Note that the vendor can add more
# more partitions to this list for the bootloader and radio.
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    system \
    system_ext \
    vbmeta \
    odm \
    product \
    vendor

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a76

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a76

TARGET_BOARD_SUFFIX := _64
TARGET_USES_64_BIT_BINDER := true
TARGET_SUPPORTS_64_BIT_APPS := true
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := $(PRODUCT_PLATFORM)
TARGET_USES_UEFI := true

# Kernel
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/$(PRODUCT_RELEASE_NAME)/dtb.img
TARGET_RECOVERY_WIPE := $(DEVICE_PATH)/recovery.wipe
BOARD_BOOTIMG_HEADER_VERSION := 2
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom androidboot.memcg=1 lpm_levels.sleep_disabled=1 service_locator.enable=1 swiotlb=2048 loop.max_part=16 androidboot.usbcontroller=a600000.dwc3 buildid=KUMANO-1.2.0-211005-1847 panic_on_err=1 androidboot.boot_devices=soc/1d84000.ufshc
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_DTB_OFFSET           := 0x01f00000
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_KERNEL_IMAGE_NAME := Image.gz
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/sony/sm8150
TARGET_KERNEL_CONFIG := griffin_defconfig

# Platform
TARGET_BOARD_PLATFORM := $(TARGET_BOOTLOADER_BOARD_NAME)
TARGET_BOARD_PLATFORM_GPU := qcom-adreno640
TARGET_USES_HARDWARE_QCOM_BOOTCTRL := true
QCOM_BOARD_PLATFORMS += $(TARGET_BOARD_PLATFORM)

# Partitions
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x04000000
BOARD_DTBOIMG_PARTITION_SIZE := 8388608

# Reserve space for data encryption (114994110464-16384)
BOARD_USERDATAIMAGE_PARTITION_SIZE := 114994094080

BOARD_SUPER_PARTITION_BLOCK_DEVICES := system vendor
BOARD_SUPER_PARTITION_METADATA_DEVICE := system
# Sum of every existing partition
BOARD_SUPER_PARTITION_SIZE := 5855248384
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 4362076160
BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 1073741824
BOARD_SUPER_PARTITION_OEM_DEVICE_SIZE := 419430400

BOARD_SUPER_PARTITION_GROUPS := somc_dynamic_partitions
BOARD_SOMC_DYNAMIC_PARTITIONS_PARTITION_LIST := odm product system system_ext vendor
# Dynamic partition size (for retrofit A/B) = BOARD_SUPER_PARTITION_SIZE - 4MB (4194304, for overhead)
BOARD_SOMC_DYNAMIC_PARTITIONS_SIZE := 5851054080


BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM := system
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor

# Filesystem
PRODUCT_ENFORCE_VINTF_MANIFEST := true


# Root
BOARD_ROOT_EXTRA_SYMLINKS += /vendor/dsp:/dsp
BOARD_ROOT_EXTRA_SYMLINKS += /vendor/bt_firmware:/bluetooth
BOARD_ROOT_EXTRA_SYMLINKS += /vendor/firmware_mnt:/firmware
BOARD_ROOT_EXTRA_SYMLINKS += /mnt/vendor/persist:/persist

# AVB
BOARD_AVB_ENABLE := true
BOARD_AVB_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 2
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA2048
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Encryption
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
BOARD_USES_QCOM_HARDWARE := true
BOARD_USES_METADATA_PARTITION := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
PLATFORM_SECURITY_PATCH := 2127-12-31
VENDOR_SECURITY_PATCH := 2127-12-31

# Config
BOARD_SUPPRESS_SECURE_ERASE := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_PREBUILT_ELF_FILES := true
BUILD_BROKEN_USES_NETWORK := true
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_KEYMASTER_WAIT_FOR_QSEE := true
TW_PREPARE_DATA_MEDIA_EARLY := true

# Qualcomm support
TARGET_USES_QCOM_BSP := true
HAVE_SYNAPTICS_I2C_RMI4_FW_UPGRADE   := true
USE_DEVICE_SPECIFIC_QCOM_PROPRIETARY := true
TW_NEW_ION_HEAP := true
TARGET_USES_NEW_ION_API := true

# Recovery
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_RECOVERY := true
TARGET_RECOVERY_DEVICE_MODULES += \
    libion \
    libxml2 \
    libandroidicu

RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libxml2.so

TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/compatibility_matrix.xml

# Use mke2fs to create ext4 images
TARGET_USES_MKE2FS := true

# TWRP specific build flags
TW_THEME := portrait_hdpi
TW_INPUT_BLACKLIST := "hbtp_vm"
RECOVERY_SDCARD_ON_DATA := true
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXTRA_LANGUAGES := true
TW_EXCLUDE_APEX := true
TW_INCLUDE_NTFS_3G := false
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_DEFAULT_BRIGHTNESS := 300
TW_MAX_BRIGHTNESS := 4095
TW_NO_SCREEN_BLANK := true
#TW_SCREEN_BLANK_ON_BOOT := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_FUSE_NTFS := false
LC_ALL="C"
TW_ROUND_SCREEN := true
TWRP_NEW_THEME := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.0/lun.%d/file
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TW_OVERRIDE_SYSTEM_PROPS := \
    "ro.build.product;ro.build.fingerprint=ro.system.build.fingerprint;ro.build.version.incremental;ro.product.device=ro.product.system.device;ro.product.model=ro.product.system.model;ro.product.name=ro.product.system.name"
TW_USE_FSCRYPT_POLICY := 1
TW_NO_FASTBOOT_BOOT := true

# TWRP Debug Flags
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace
#TWRP_EVENT_LOGGING := true

# Extras
BOARD_HAS_NO_REAL_SDCARD := true
TW_EXCLUDE_TWRPAPP := true
TW_USE_TOOLBOX := true
TW_USE_QCOM_HAPTICS_VIBRATOR := true
TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_EXCLUDE_PYTHON := true
TW_EXCLUDE_NANO := true
