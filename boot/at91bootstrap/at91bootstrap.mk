################################################################################
#
# at91bootstrap
#
################################################################################

AT91BOOTSTRAP_VERSION = 1.16
AT91BOOTSTRAP_SITE = ftp://www.at91.com/pub/at91bootstrap
AT91BOOTSTRAP_SOURCE = AT91Bootstrap$(AT91BOOTSTRAP_VERSION).zip

AT91BOOTSTRAP_BOARD = $(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP_BOARD))
AT91BOOTSTRAP_MEMORY = $(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP_MEMORY))
AT91BOOTSTRAP_MAKE_SUBDIR = board/$(AT91BOOTSTRAP_BOARD)/$(AT91BOOTSTRAP_MEMORY)
AT91BOOTSTRAP_BINARY = $(AT91BOOTSTRAP_MAKE_SUBDIR)/$(AT91BOOTSTRAP_MEMORY)_$(AT91BOOTSTRAP_BOARD).bin

AT91BOOTSTRAP_INSTALL_IMAGES = YES
AT91BOOTSTRAP_INSTALL_TARGET = NO

define AT91BOOTSTRAP_EXTRACT_CMDS
	$(UNZIP) -d $(BUILD_DIR) $(DL_DIR)/$(AT91BOOTSTRAP_SOURCE)
	mv $(BUILD_DIR)/Bootstrap-v$(AT91BOOTSTRAP_VERSION)/* $(@D)
	rmdir $(BUILD_DIR)/Bootstrap-v$(AT91BOOTSTRAP_VERSION)
endef

ifneq ($(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP_CUSTOM_PATCH_DIR)),)
define AT91BOOTSTRAP_APPLY_CUSTOM_PATCHES
	$(APPLY_PATCHES) $(@D) $(BR2_TARGET_AT91BOOTSTRAP_CUSTOM_PATCH_DIR) \*.patch
endef

AT91BOOTSTRAP_POST_PATCH_HOOKS += AT91BOOTSTRAP_APPLY_CUSTOM_PATCHES
endif

define AT91BOOTSTRAP_BUILD_CMDS
	$(MAKE1) CROSS_COMPILE=$(TARGET_CROSS) -C $(@D)/$(AT91BOOTSTRAP_MAKE_SUBDIR)
endef

define AT91BOOTSTRAP_INSTALL_IMAGES_CMDS
	cp $(@D)/$(AT91BOOTSTRAP_BINARY) $(BINARIES_DIR)
endef

$(eval $(generic-package))

ifeq ($(BR2_TARGET_AT91BOOTSTRAP)$(BR_BUILDING),yy)
ifeq ($(AT91BOOTSTRAP_BOARD),)
$(error No AT91Bootstrap board name set. Check your BR2_TARGET_AT91BOOTSTRAP_BOARD setting)
endif
endif
