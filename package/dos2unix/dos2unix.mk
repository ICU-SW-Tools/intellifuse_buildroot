################################################################################
#
# dos2unix
#
################################################################################

DOS2UNIX_VERSION = 7.3
DOS2UNIX_SITE = http://waterlan.home.xs4all.nl/dos2unix
DOS2UNIX_LICENSE = BSD-2c
DOS2UNIX_LICENSE_FILES = COPYING.txt
DOS2UNIX_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)
HOST_DOS2UNIX_DEPENDENCIES = host-gettext

ifeq ($(BR2_ENABLE_LOCALE),)
DOS2UNIX_MAKE_OPTS += ENABLE_NLS=
endif

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
DOS2UNIX_DEPENDENCIES += gettext
DOS2UNIX_MAKE_OPTS += LIBS_EXTRA=-lintl
endif

define DOS2UNIX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(DOS2UNIX_MAKE_OPTS)
endef

define DOS2UNIX_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) \
		$(DOS2UNIX_MAKE_OPTS) install
endef

define HOST_DOS2UNIX_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HOST_DOS2UNIX_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(HOST_DIR) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
