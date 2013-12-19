################################################################################
#
# zyre
#
################################################################################

ZYRE_VERSION = d5b8cb1f66fb5059d9eeb0702a7c2055a63cd8a7
ZYRE_SITE = $(call github,zeromq,zyre,$(ZYRE_VERSION))
ZYRE_LICENSE = LGPLv3+
ZYRE_LICENSE_FILES = COPYING COPYING.LESSER
ZYRE_INSTALL_STAGING = YES
ZYRE_DEPENDENCIES = filemq
ZYRE_AUTORECONF = YES
ZYRE_AUTORECONF_OPT = --install --force --verbose

define ZYRE_CREATE_CONFIG_DIR
	mkdir -p $(@D)/config
endef

ZYRE_POST_PATCH_HOOKS += ZYRE_CREATE_CONFIG_DIR

$(eval $(autotools-package))
