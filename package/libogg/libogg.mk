#############################################################
#
# libogg
#
#############################################################

LIBOGG_VERSION = 1.3.0
LIBOGG_SITE = http://downloads.xiph.org/releases/ogg
LIBOGG_LICENSE = BSD-3c
LIBOGG_LICENSE_FILES = COPYING

LIBOGG_INSTALL_STAGING = YES
LIBOGG_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
