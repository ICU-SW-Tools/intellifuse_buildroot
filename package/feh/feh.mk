################################################################################
#
# feh
#
################################################################################

FEH_VERSION = 2.13.1
FEH_SOURCE = feh-$(FEH_VERSION).tar.bz2
FEH_SITE = http://feh.finalrewind.org
FEH_DEPENDENCIES = libcurl imlib2 libpng xlib_libXinerama xlib_libXt
FEH_LICENSE = MIT
FEH_LICENSE_FILES = COPYING

define FEH_BUILD_CMDS
	$(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) all
endef

define FEH_INSTALL_TARGET_CMDS
	$(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) " \
		DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
