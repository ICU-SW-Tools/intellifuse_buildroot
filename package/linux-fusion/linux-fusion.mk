#############################################################
#
# linux-fusion
#
#############################################################
LINUX_FUSION_VERSION = 8.1.1
LINUX_FUSION_SOURCE = linux-fusion-$(LINUX_FUSION_VERSION).tar.gz
LINUX_FUSION_SITE = http://directfb.org/downloads/Core/linux-fusion
LINUX_FUSION_INSTALL_STAGING = YES

# BR2_LINUX26_VERSION is not really dependable
# LINUX26_VERSION is not yet set.
# Retrieve REAL kernel version from file.
LINUX_FOR_FUSION=$(LINUX_VERSION)
# `cat $(BUILD_DIR)/.linux-version`
LINUX_FUSION_ETC_DIR=$(TARGET_DIR)/etc/udev/rules.d

LINUX_FUSION_CAT=$(ZCAT)

LINUX_FUSION_MAKE_OPTS =  KERNEL_VERSION=$(LINUX_FOR_FUSION)
LINUX_FUSION_MAKE_OPTS += KERNEL_BUILD=$(BUILD_DIR)/linux-$(LINUX_FOR_FUSION)
LINUX_FUSION_MAKE_OPTS += KERNEL_SOURCE=$(BUILD_DIR)/linux-$(LINUX_FOR_FUSION)

LINUX_FUSION_MAKE_OPTS += SYSROOT=$(STAGING_DIR)
LINUX_FUSION_MAKE_OPTS += ARCH=$(KERNEL_ARCH)
LINUX_FUSION_MAKE_OPTS += CROSS_COMPILE=$(TARGET_CROSS)
LINUX_FUSION_MAKE_OPTS += KERNEL_MODLIB=/lib/modules/$(LINUX_FOR_FUSION)
LINUX_FUSION_MAKE_OPTS += DESTDIR=$(BUILD_DIR)/root
LINUX_FUSION_MAKE_OPTS += HEADERDIR=$(STAGING_DIR)
#LINUX_FUSION_MAKE_OPTS +=

#LINUX_FUSION_MAKE_OPTS += __KERNEL__=$(LINUX26_VERSION)


define LINUX_FUSION_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/lib/modules/$(LINUX_FOR_FUSION)/source/include/linux
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LINUX_FUSION_MAKE_OPTS) \
		INSTALL_MOD_PATH=$(STAGING_DIR) \
		-C $(@D) install
endef

define LINUX_FUSION_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LINUX_FUSION_MAKE_OPTS) \
		INSTALL_MOD_PATH=$(TARGET_DIR) \
		-C $(@D) install
	mkdir -p $(LINUX_FUSION_ETC_DIR)
	cp -dpf package/linux-fusion/40-fusion.rules $(LINUX_FUSION_ETC_DIR)
endef

define LINUX_FUSION_UNINSTALL_STAGING
	rm -f $(STAGING_DIR)/usr/include/linux/fusion.h
endef

LINUX_FUSION_UNINSTALL_STAGING_CMDS += LINUX_FUSION_UNINSTALL_STAGING

define LINUX_FUSION_UNINSTALL_TARGET
	rm -f $(TARGET_DIR)/usr/include/linux/fusion.h
	rm -rf $(TARGET_DIR)/lib/modules/$(LINUX_FOR_FUSION)/drivers/char/fusion
	rm -f $(LINUX_FUSION_ETC_DIR)/40-fusion.rules
endef

LINUX_FUSION_UNINSTALL_TARGET_CMDS += LINUX_FUSION_UNINSTALL_TARGET

$(eval $(call GENTARGETS,package,linux-fusion))
