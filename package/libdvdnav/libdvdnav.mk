################################################################################
#
# libdvdnav
#
################################################################################

LIBDVDNAV_VERSION = 5.0.3
LIBDVDNAV_SOURCE = libdvdnav-$(LIBDVDNAV_VERSION).tar.bz2
LIBDVDNAV_SITE = http://www.videolan.org/pub/videolan/libdvdnav/$(LIBDVDNAV_VERSION)
LIBDVDNAV_INSTALL_STAGING = YES
LIBDVDNAV_DEPENDENCIES = libdvdread host-pkgconf
LIBDVDNAV_LICENSE = GPLv2+
LIBDVDNAV_LICENSE_FILES = COPYING

$(eval $(autotools-package))
