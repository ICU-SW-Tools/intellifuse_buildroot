################################################################################
#
# linux-fusion
#
################################################################################

LINUX_FUSION_VERSION = 9.0.2
LINUX_FUSION_SITE = http://directfb.org/downloads/Core/linux-fusion
LINUX_FUSION_INSTALL_STAGING = YES
LINUX_FUSION_DEPENDENCIES = linux
LINUX_FUSION_LICENSE = GPLv2+
LINUX_FUSION_LICENSE_FILES = debian/copyright

# We're building a kernel module without using the kernel-module infra,
# so we need to tell we want module support in the kernel
ifeq ($(BR2_PACKAGE_LINUX_FUSION),y)
LINUX_NEEDS_MODULES = y
endif

LINUX_FOR_FUSION = $(LINUX_VERSION_PROBED)
LINUX_FUSION_ETC_DIR = $(TARGET_DIR)/etc/udev/rules.d

LINUX_FUSION_MAKE_OPTS = KERNEL_VERSION=$(LINUX_FOR_FUSION)
LINUX_FUSION_MAKE_OPTS += KERNEL_BUILD=$(LINUX_DIR)
LINUX_FUSION_MAKE_OPTS += KERNEL_SOURCE=$(LINUX_DIR)

LINUX_FUSION_MAKE_OPTS += SYSROOT=$(TARGET_DIR)
LINUX_FUSION_MAKE_OPTS += ARCH=$(KERNEL_ARCH)
LINUX_FUSION_MAKE_OPTS += CROSS_COMPILE=$(TARGET_CROSS)
LINUX_FUSION_MAKE_OPTS += KERNEL_MODLIB=/lib/modules/$(LINUX_FOR_FUSION)/kernel

define LINUX_FUSION_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(LINUX_FUSION_MAKE_OPTS) -C $(@D)
endef

define LINUX_FUSION_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(LINUX_FUSION_MAKE_OPTS) INSTALL_MOD_PATH=$(STAGING_DIR) -C $(@D) headers_install
endef

define LINUX_FUSION_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) \
		$(LINUX_FUSION_MAKE_OPTS) \
		INSTALL_MOD_PATH=$(TARGET_DIR) \
		-C $(@D) install
	$(INSTALL) -D -m 644 package/linux-fusion/40-fusion.rules \
		$(LINUX_FUSION_ETC_DIR)/40-fusion.rules
endef

$(eval $(generic-package))
