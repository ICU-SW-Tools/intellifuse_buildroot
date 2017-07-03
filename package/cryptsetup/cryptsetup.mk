################################################################################
#
# cryptsetup
#
################################################################################

CRYPTSETUP_VERSION_MAJOR = 1.7
CRYPTSETUP_VERSION = $(CRYPTSETUP_VERSION_MAJOR).5
CRYPTSETUP_SOURCE = cryptsetup-$(CRYPTSETUP_VERSION).tar.xz
CRYPTSETUP_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/cryptsetup/v$(CRYPTSETUP_VERSION_MAJOR)
CRYPTSETUP_DEPENDENCIES = lvm2 popt util-linux host-pkgconf \
	$(TARGET_NLS_DEPENDENCIES)
CRYPTSETUP_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (library)
CRYPTSETUP_LICENSE_FILES = COPYING COPYING.LGPL
CRYPTSETUP_INSTALL_STAGING = YES
CRYPTSETUP_CONF_ENV += LDFLAGS="$(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)"

# cryptsetup uses libgcrypt by default, but can be configured to use OpenSSL
# or kernel crypto modules instead
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
CRYPTSETUP_DEPENDENCIES += libgcrypt
CRYPTSETUP_CONF_ENV += LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config
CRYPTSETUP_CONF_OPTS += --with-crypto_backend=gcrypt
else ifeq ($(BR2_PACKAGE_OPENSSL),y)
CRYPTSETUP_DEPENDENCIES += openssl
CRYPTSETUP_CONF_OPTS += --with-crypto_backend=openssl
else
CRYPTSETUP_CONF_OPTS += --with-crypto_backend=kernel
endif

$(eval $(autotools-package))
