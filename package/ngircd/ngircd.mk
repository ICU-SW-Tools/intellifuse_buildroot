################################################################################
#
# ngircd
#
################################################################################

NGIRCD_VERSION = 24
NGIRCD_SOURCE = ngircd-$(NGIRCD_VERSION).tar.xz
NGIRCD_SITE = https://arthur.barton.de/pub/ngircd
NGIRCD_DEPENDENCIES = zlib
NGIRCD_LICENSE = GPL-2.0+
NGIRCD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
