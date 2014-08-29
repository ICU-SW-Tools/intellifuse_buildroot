################################################################################
#
# libarchive
#
################################################################################

LIBARCHIVE_VERSION = 3.1.2
LIBARCHIVE_SITE = http://www.libarchive.org/downloads
LIBARCHIVE_INSTALL_STAGING = YES
LIBARCHIVE_LICENSE = BSD-2c, BSD-3c
LIBARCHIVE_LICENSE_FILES = COPYING
LIBARCHIVE_CONF_OPT = --without-lzma

ifeq ($(BR2_PACKAGE_LIBARCHIVE_BSDTAR),y)
ifeq ($(BR2_PREFER_STATIC_LIB),y)
LIBARCHIVE_CONF_OPT += --enable-bsdtar=static
else
LIBARCHIVE_CONF_OPT += --enable-bsdtar=shared
endif
else
LIBARCHIVE_CONF_OPT += --disable-bsdtar
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE_BSDCPIO),y)
ifeq ($(BR2_PREFER_STATIC_LIB),y)
LIBARCHIVE_CONF_OPT += --enable-bsdcpio=static
else
LIBARCHIVE_CONF_OPT += --enable-bsdcpio=shared
endif
else
LIBARCHIVE_CONF_OPT += --disable-bsdcpio
endif

ifeq ($(BR2_PACKAGE_ACL),y)
LIBARCHIVE_DEPENDENCIES += acl
else
LIBARCHIVE_CONF_OPT += --disable-acl
endif

ifeq ($(BR2_PACKAGE_ATTR),y)
LIBARCHIVE_DEPENDENCIES += attr
else
LIBARCHIVE_CONF_OPT += --disable-xattr
endif

ifeq ($(BR2_PACKAGE_EXPAT),y)
LIBARCHIVE_DEPENDENCIES += expat
else
LIBARCHIVE_CONF_OPT += --without-expat
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
LIBARCHIVE_DEPENDENCIES += libiconv
else
LIBARCHIVE_CONF_OPT += --without-libiconv-prefix
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
LIBARCHIVE_DEPENDENCIES += libxml2
LIBARCHIVE_CONF_ENV += XML2_CONFIG=$(STAGING_DIR)/usr/bin/xml2-config
else
LIBARCHIVE_CONF_OPT += --without-xml2
endif

ifeq ($(BR2_PACKAGE_LZO),y)
LIBARCHIVE_DEPENDENCIES += lzo
else
LIBARCHIVE_CONF_OPT += --without-lzo2
endif

ifeq ($(BR2_PACKAGE_NETTLE),y)
LIBARCHIVE_DEPENDENCIES += nettle
else
LIBARCHIVE_CONF_OPT += --without-nettle
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBARCHIVE_DEPENDENCIES += openssl
else
LIBARCHIVE_CONF_OPT += --without-openssl
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBARCHIVE_DEPENDENCIES += zlib
else
LIBARCHIVE_CONF_OPT += --without-zlib
endif

$(eval $(autotools-package))
