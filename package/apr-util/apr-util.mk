################################################################################
#
# apr-util
#
################################################################################

APR_UTIL_VERSION = 1.5.2
APR_UTIL_SITE = http://archive.apache.org/dist/apr
APR_UTIL_LICENSE = Apache-2.0
APR_UTIL_LICENSE_FILES = LICENSE
APR_UTIL_INSTALL_STAGING = YES
APR_UTIL_DEPENDENCIES = apr expat
APR_UTIL_CONF_OPTS = \
	--with-apr=$(STAGING_DIR)/usr/bin/apr-1-config
APR_UTIL_CONFIG_SCRIPTS = apu-1-config

# When iconv is available, then use it to provide charset conversion
# features.
APR_UTIL_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
APR_UTIL_CONF_OPTS += --with-dbm=db53 --with-berkeley-db="$(STAGING_DIR)/usr"
APR_UTIL_DEPENDENCIES += berkeleydb
else
APR_UTIL_CONF_OPTS += --without-berkeley-db
endif

ifeq ($(BR2_PACKAGE_SQLITE),y)
APR_UTIL_CONF_OPTS += --with-sqlite3="$(STAGING_DIR)/usr"
APR_UTIL_DEPENDENCIES += sqlite
else
APR_UTIL_CONF_OPTS += --without-sqlite3
endif

$(eval $(autotools-package))
