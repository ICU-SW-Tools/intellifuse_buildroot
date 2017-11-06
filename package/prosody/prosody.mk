################################################################################
#
# prosody
#
################################################################################

PROSODY_VERSION = 0.9.12
PROSODY_SITE = https://prosody.im/downloads/source
PROSODY_LICENSE = MIT
PROSODY_LICENSE_FILES = COPYING
PROSODY_DEPENDENCIES = openssl libidn

ifeq ($(BR2_PACKAGE_LUA_5_1),y)
PROSODY_DEPENDENCIES += lua
endif

ifeq ($(BR2_PACKAGE_LUAJIT),y)
PROSODY_DEPENDENCIES += luajit
endif

PROSODY_CONF_OPTS = \
	--with-lua=$(STAGING_DIR)/usr \
	--c-compiler=$(TARGET_CC) \
	--cflags="$(TARGET_CFLAGS) -fPIC" \
	--linker=$(TARGET_CC) \
	--ldflags="$(TARGET_LDFLAGS) -shared" \
	--sysconfdir=/etc/prosody \
	--prefix=/usr

define PROSODY_CONFIGURE_CMDS
	cd $(@D) && \
		$(TARGET_CONFIGURE_OPTS) \
		./configure $(PROSODY_CONF_OPTS)
endef

define PROSODY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define PROSODY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR="$(TARGET_DIR)" -C $(@D) install
endef

define PROSODY_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/prosody/S50prosody \
		$(TARGET_DIR)/etc/init.d/S50prosody
endef

define PROSODY_USERS
	prosody -1 prosody -1 * - - - Prosody user
endef

# make install installs a Makefile and meta data to generate certs
define PROSODY_REMOVE_CERT_GENERATOR
	rm -f $(TARGET_DIR)/etc/prosody/certs/Makefile
	rm -f $(TARGET_DIR)/etc/prosody/certs/*.cnf
endef

PROSODY_POST_INSTALL_TARGET_HOOKS += PROSODY_REMOVE_CERT_GENERATOR

# 1. Enable posix functionality
# 2. Log to syslog
# 3. Specify pid file write location
# 4. Enable virtual host example.com
define PROSODY_TWEAK_DEFAULT_CONF
	$(INSTALL) -D package/prosody/prosody.cfg.lua \
		$(TARGET_DIR)/etc/prosody/prosody.cfg.lua
endef

PROSODY_POST_INSTALL_TARGET_HOOKS += PROSODY_TWEAK_DEFAULT_CONF

$(eval $(generic-package))
