################################################################################
#
# glib-networking
#
################################################################################

GLIB_NETWORKING_VERSION_MAJOR = 2.36
GLIB_NETWORKING_VERSION = $(GLIB_NETWORKING_VERSION_MAJOR).2
GLIB_NETWORKING_SITE = http://ftp.gnome.org/pub/gnome/sources/glib-networking/$(GLIB_NETWORKING_VERSION_MAJOR)
GLIB_NETWORKING_SOURCE = glib-networking-$(GLIB_NETWORKING_VERSION).tar.xz
GLIB_NETWORKING_INSTALL_STAGING = YES
GLIB_NETWORKING_DEPENDENCIES = \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) \
	host-pkgconf \
	host-intltool \
	libglib2
GLIB_NETWORKING_LICENSE = LGPLv2+
GLIB_NETWORKING_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_GNUTLS),y)
GLIB_NETWORKING_DEPENDENCIES += gnutls
GLIB_NETWORKING_CONF_OPTS += --with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
GLIB_NETWORKING_CONF_OPTS += --without-gnutls
endif

# gnutls 3.x+ doesn't use libgcrypt, it uses nettle/hogweed
define GLIB_NETWORKING_NO_LIBGCRYPT
	$(SED) 's:#include <gcrypt.h>::' $(@D)/tls/gnutls/gtlsbackend-gnutls.c
endef

GLIB_NETWORKING_POST_EXTRACT_HOOKS += GLIB_NETWORKING_NO_LIBGCRYPT

$(eval $(autotools-package))
