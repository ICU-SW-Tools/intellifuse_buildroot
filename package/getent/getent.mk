################################################################################
#
# getent
#
################################################################################

# source included in Buildroot
GETENT_SOURCE =

GETENT_VERSION = buildroot-$(BR2_VERSION)
GETENT_LICENSE = LGPLv2.1+

# For glibc toolchains, we use the getent program built/installed by
# the C library. For other toolchains, we use the wrapper script
# included in this package.
ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),y)
GETENT_LOCATION = $(STAGING_DIR)/usr/bin/getent
else
GETENT_LOCATION = package/getent/getent
endif

define GETENT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(GETENT_LOCATION) $(TARGET_DIR)/usr/bin/getent
endef

$(eval $(generic-package))
