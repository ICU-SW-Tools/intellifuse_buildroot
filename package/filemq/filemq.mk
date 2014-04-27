################################################################################
#
# filemq
#
################################################################################

FILEMQ_VERSION = 9a24134d4c0a84abc5eebf1dfb2eb184adee72df
FILEMQ_SITE = $(call github,zeromq,filemq,$(FILEMQ_VERSION))

FILEMQ_AUTORECONF = YES
FILEMQ_CONF_ENV = fmq_have_asciidoc=no
FILEMQ_INSTALL_STAGING = YES
FILEMQ_DEPENDENCIES = czmq openssl zeromq
FILEMQ_LICENSE = LGPLv3+ with exceptions
FILEMQ_LICENSE_FILES = COPYING COPYING.LESSER

define FILEMQ_CREATE_CONFIG_DIR
	mkdir -p $(@D)/config
endef

FILEMQ_POST_PATCH_HOOKS += FILEMQ_CREATE_CONFIG_DIR

$(eval $(autotools-package))
