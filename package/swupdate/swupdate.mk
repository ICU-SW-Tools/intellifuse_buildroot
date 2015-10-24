################################################################################
#
# swupdate
#
################################################################################

SWUPDATE_VERSION = 2015.07
SWUPDATE_SITE = $(call github,sbabic,swupdate,$(SWUPDATE_VERSION))
SWUPDATE_LICENSE = GPLv2+, MIT, Public Domain
SWUPDATE_LICENSE_FILES = COPYING
SWUPDATE_PATCH = \
	https://github.com/sbabic/swupdate/commit/5a5ef5909f5da5b2070d58ffaee924bb8e6a51e1.patch

# swupdate bundles its own version of mongoose (version 3.8) and
# lsqlite3 (version 0.8)

ifeq ($(BR2_PACKAGE_JSON_C),y)
SWUPDATE_DEPENDENCIES += json-c
SWUPDATE_MAKE_ENV += HAVE_JSON_C=y
else
SWUPDATE_MAKE_ENV += HAVE_JSON_C=n
endif

ifeq ($(BR2_PACKAGE_LIBCONFIG),y)
SWUPDATE_DEPENDENCIES += libconfig
SWUPDATE_MAKE_ENV += HAVE_LIBCONFIG=y
else
SWUPDATE_MAKE_ENV += HAVE_LIBCONFIG=n
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
SWUPDATE_DEPENDENCIES += libcurl
SWUPDATE_MAKE_ENV += HAVE_LIBCURL=y
else
SWUPDATE_MAKE_ENV += HAVE_LIBCURL=n
endif

ifeq ($(BR2_PACKAGE_LUA_5_2),y)
SWUPDATE_DEPENDENCIES += lua
SWUPDATE_MAKE_ENV += HAVE_LUA=y
else
SWUPDATE_MAKE_ENV += HAVE_LUA=n
endif

ifeq ($(BR2_PACKAGE_MTD),y)
SWUPDATE_DEPENDENCIES += mtd
SWUPDATE_MAKE_ENV += HAVE_LIBMTD=y
SWUPDATE_MAKE_ENV += HAVE_LIBUBI=y
else
SWUPDATE_MAKE_ENV += HAVE_LIBMTD=n
SWUPDATE_MAKE_ENV += HAVE_LIBUBI=n
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
SWUPDATE_DEPENDENCIES += openssl
SWUPDATE_MAKE_ENV += HAVE_LIBSSL=y
SWUPDATE_MAKE_ENV += HAVE_LIBCRYPTO=y
else
SWUPDATE_MAKE_ENV += HAVE_LIBSSL=n
SWUPDATE_MAKE_ENV += HAVE_LIBCRYPTO=n
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
SWUPDATE_DEPENDENCIES += zlib
SWUPDATE_MAKE_ENV += HAVE_ZLIB=y
else
SWUPDATE_MAKE_ENV += HAVE_ZLIB=n
endif

SWUPDATE_BUILD_CONFIG = $(@D)/.config

SWUPDATE_KCONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_SWUPDATE_CONFIG))
SWUPDATE_KCONFIG_EDITORS = menuconfig xconfig gconfig nconfig

ifeq ($(BR2_PREFER_STATIC_LIB),y)
define SWUPDATE_PREFER_STATIC
	$(call KCONFIG_ENABLE_OPT,CONFIG_STATIC,$(SWUPDATE_BUILD_CONFIG))
endef
endif

define SWUPDATE_SET_BUILD_OPTIONS
	$(call KCONFIG_SET_OPT,CONFIG_CROSS_COMPILE,"$(TARGET_CROSS)", \
		$(SWUPDATE_BUILD_CONFIG))
	$(call KCONFIG_SET_OPT,CONFIG_SYSROOT,"$(STAGING_DIR)", \
		$(SWUPDATE_BUILD_CONFIG))
	$(call KCONFIG_SET_OPT,CONFIG_EXTRA_CFLAGS,"$(TARGET_CFLAGS)", \
		$(SWUPDATE_BUILD_CONFIG))
	$(call KCONFIG_SET_OPT,CONFIG_EXTRA_LDFLAGS,"$(TARGET_LDFLAGS)", \
		$(SWUPDATE_BUILD_CONFIG))
endef

define SWUPDATE_KCONFIG_FIXUP_CMDS
	$(SWUPDATE_PREFER_STATIC)
	$(SWUPDATE_SET_BUILD_OPTIONS)
endef

define SWUPDATE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(SWUPDATE_MAKE_ENV) $(MAKE) -C $(@D)
endef

define SWUPDATE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/swupdate $(TARGET_DIR)/usr/bin/swupdate
	$(if $(BR2_PACKAGE_SWUPDATE_INSTALL_WEBSITE), \
		mkdir -p $(TARGET_DIR)/var/www/swupdate; \
		cp -dpf $(@D)/www/* $(TARGET_DIR)/var/www/swupdate)
endef

# Checks to give errors that the user can understand
# Must be before we call to kconfig-package
ifeq ($(BR2_PACKAGE_SWUPDATE)$(BR_BUILDING),yy)
ifeq ($(call qstrip,$(BR2_PACKAGE_SWUPDATE_CONFIG)),)
$(error No Swupdate configuration file specified, check your BR2_PACKAGE_SWUPDATE_CONFIG setting)
endif
endif

$(eval $(kconfig-package))
