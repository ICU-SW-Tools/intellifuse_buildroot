################################################################################
#
# libtommath
#
################################################################################

LIBTOMMATH_VERSION = 1.0
LIBTOMMATH_SITE = https://github.com/libtom/libtommath/releases/download/v$(LIBTOMMATH_VERSION)
LIBTOMMATH_SOURCE = ltm-$(LIBTOMMATH_VERSION).tar.xz
LIBTOMMATH_LICENSE = WTFPL
LIBTOMMATH_LICENSE_FILES = LICENSE
LIBTOMMATH_INSTALL_STAGING = YES
LIBTOMMATH_INSTALL_TARGET = NO  # only static library

define LIBTOMMATH_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) CFLAGS="-I./ -fPIC $(TARGET_CFLAGS)"
endef

define LIBTOMMATH_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) DESTDIR="$(STAGING_DIR)" install
endef

$(eval $(generic-package))
