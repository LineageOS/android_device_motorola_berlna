#
# SPDX-FileCopyrightText: 2022-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/motorola/berlna

# Inherit from motorola sm7325-common
include device/motorola/sm7325-common/BoardConfigCommon.mk

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := berlna

# HIDL
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

# Kernel
BOARD_KERNEL_CMDLINE += androidboot.hab.product=berlna
TARGET_KERNEL_CONFIG += vendor/lineage_berlna.config

# Kernel Modules
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/modules.load))
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE := $(DEVICE_PATH)/modules.blocklist
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/modules.load.recovery))
BOOT_KERNEL_MODULES := $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD)

# Kernel modules - WLAN
TARGET_MODULE_ALIASES += \
    wlan.ko:qca_cld3_qca6750.ko

# Partitions
BOARD_MOT_DP_GROUP_SIZE := 7916748800
BOARD_SUPER_PARTITION_SIZE := 15854469120

# Properties
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/product.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 90

# Security
BOOT_SECURITY_PATCH := 2024-08-01
VENDOR_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)

# Verified Boot
BOARD_AVB_ROLLBACK_INDEX := 37
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := 37

# inherit from the proprietary version
include vendor/motorola/berlna/BoardConfigVendor.mk
