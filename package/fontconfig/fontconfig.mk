################################################################################
#
# fontconfig
#
################################################################################

FONTCONFIG_VERSION = 2.11.1
FONTCONFIG_SITE = http://fontconfig.org/release
FONTCONFIG_INSTALL_STAGING = YES
FONTCONFIG_DEPENDENCIES = freetype expat host-pkgconf
FONTCONFIG_LICENSE = fontconfig license
FONTCONFIG_LICENSE_FILES = COPYING

FONTCONFIG_CONF_OPTS = --with-arch=$(GNU_TARGET_NAME) \
		--with-cache-dir=/var/cache/fontconfig \
		--disable-docs

HOST_FONTCONFIG_CONF_OPTS = \
	--disable-static

$(eval $(autotools-package))
$(eval $(host-autotools-package))
