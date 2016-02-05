################################################################################
#
# pound
#
################################################################################

POUND_VERSION = 2.7
POUND_SITE = http://www.apsis.ch/pound
POUND_SOURCE = Pound-$(POUND_VERSION).tgz
POUND_LICENSE = GPLv3+
POUND_LICENSE_FILES = GPL.txt
POUND_DEPENDENCIES = openssl

# Force owner/group to us, otherwise it will try proxy:proxy by
# default.
POUND_CONF_OPTS = \
	--with-owner=$(shell id -un) \
	--with-group=$(shell id -gn)

ifeq ($(BR2_PACKAGE_PCRE),y)
POUND_DEPENDENCIES += pcre
endif

$(eval $(autotools-package))
