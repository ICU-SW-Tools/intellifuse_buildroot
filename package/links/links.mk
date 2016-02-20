################################################################################
#
# links
#
################################################################################

LINKS_VERSION = 2.12
LINKS_SOURCE = links-$(LINKS_VERSION).tar.bz2
LINKS_SITE = http://links.twibright.com/download
LINKS_DEPENDENCIES = host-pkgconf
LINKS_LICENSE = GPLv2+
LINKS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LINKS_GRAPHICS),y)
LINKS_CONF_OPTS += --enable-graphics
LINKS_DEPENDENCIES += libpng
ifeq ($(BR2_PACKAGE_XLIB_LIBXT),y)
LINKS_CONF_OPTS += --with-x
LINKS_DEPENDENCIES += xlib_libXt
else
LINKS_CONF_OPTS += --without-x
endif
ifeq ($(BR2_PACKAGE_DIRECTFB),y)
LINKS_CONF_ENV = ac_cv_path_DIRECTFB_CONFIG=$(STAGING_DIR)/usr/bin/directfb-config
LINKS_CONF_OPTS += --with-directfb
LINKS_DEPENDENCIES += directfb
else
LINKS_CONF_OPTS += --without-directfb
endif
ifeq ($(BR2_PACKAGE_JPEG),y)
LINKS_DEPENDENCIES += jpeg
endif
ifeq ($(BR2_PACKAGE_TIFF),y)
LINKS_DEPENDENCIES += tiff
endif
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
LINKS_DEPENDENCIES += bzip2
endif

ifeq ($(BR2_PACKAGE_LIBEVENT),y)
LINKS_CONF_OPTS += --with-libevent
LINKS_DEPENDENCIES += libevent
else
LINKS_CONF_OPTS += --without-libevent
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LINKS_DEPENDENCIES += openssl
endif

ifeq ($(BR2_PACKAGE_XZ),y)
LINKS_CONF_OPTS += --with-lzma
LINKS_DEPENDENCIES += xz
else
LINKS_CONF_OPTS += --without-lzma
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LINKS_CONF_OPTS += --with-zlib
LINKS_DEPENDENCIES += zlib
else
LINKS_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
