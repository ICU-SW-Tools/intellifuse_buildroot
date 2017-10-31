################################################################################
#
# libssh2
#
################################################################################

LIBSSH2_VERSION = 616fd4d1b3e4a55de67c48819fefca83132126b5
LIBSSH2_SITE = $(call github,libssh2,libssh2,$(LIBSSH2_VERSION))
LIBSSH2_LICENSE = BSD
LIBSSH2_LICENSE_FILES = COPYING
LIBSSH2_INSTALL_STAGING = YES
LIBSSH2_CONF_OPTS = --disable-examples-build

# building from a git clone
LIBSSH2_AUTORECONF = YES

# Dependency is one of mbedtls, libgcrypt or openssl, guaranteed in
# Config.in. Favour mbedtls.
ifeq ($(BR2_PACKAGE_MBEDTLS),y)
LIBSSH2_DEPENDENCIES += mbedtls
LIBSSH2_CONF_OPTS += --with-libmbedcrypto-prefix=$(STAGING_DIR)/usr \
	--with-crypto=mbedtls
else ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBSSH2_DEPENDENCIES += libgcrypt
LIBSSH2_CONF_OPTS += --with-libgcrypt-prefix=$(STAGING_DIR)/usr \
	--with-crypto=libgcrypt
# configure.ac forgets to link to dependent libraries of gcrypt breaking static
# linking
LIBSSH2_CONF_ENV += LIBS="`$(STAGING_DIR)/usr/bin/libgcrypt-config --libs`"
else
LIBSSH2_DEPENDENCIES += openssl
LIBSSH2_CONF_OPTS += --with-libssl-prefix=$(STAGING_DIR)/usr \
	--with-crypto=openssl
endif

# Add zlib support if enabled
ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBSSH2_DEPENDENCIES += zlib
LIBSSH2_CONF_OPTS += --with-libz \
	--with-libz-prefix=$(STAGING_DIR)/usr
else
LIBSSH2_CONF_OPTS += --without-libz
endif

$(eval $(autotools-package))
