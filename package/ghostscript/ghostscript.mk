################################################################################
#
# ghostscript
#
################################################################################

GHOSTSCRIPT_VERSION = 9.21
GHOSTSCRIPT_SITE = https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs921
GHOSTSCRIPT_SOURCE = ghostscript-$(GHOSTSCRIPT_VERSION).tar.xz
GHOSTSCRIPT_LICENSE = AGPLv3
GHOSTSCRIPT_LICENSE_FILES = LICENSE
# 0001-Fix-cross-compilation-issue.patch
GHOSTSCRIPT_AUTORECONF = YES
GHOSTSCRIPT_DEPENDENCIES = \
	host-lcms2 \
	host-libjpeg \
	host-pkgconf \
	host-zlib \
	fontconfig \
	ghostscript-fonts \
	jpeg \
	lcms2 \
	libpng \
	tiff

# Ghostscript includes (old) copies of several libraries, delete them.
# Inspired by linuxfromscratch:
# http://www.linuxfromscratch.org/blfs/view/svn/pst/gs.html
define GHOSTSCRIPT_REMOVE_LIBS
	rm -rf $(@D)/freetype $(@D)/ijs $(@D)/jpeg $(@D)/lcms2 $(@D)/libpng $(@D)/tiff $(@D)/zlib
endef
GHOSTSCRIPT_POST_PATCH_HOOKS += GHOSTSCRIPT_REMOVE_LIBS

GHOSTSCRIPT_CONF_ENV = \
	CCAUX="$(HOSTCC)" \
	CFLAGSAUX="$(HOST_CFLAGS) $(HOST_LDFLAGS)"

GHOSTSCRIPT_CONF_OPTS = \
	--disable-compile-inits \
	--disable-cups \
	--enable-fontconfig \
	--with-fontpath=$(GHOSTSCRIPT_FONTS_TARGET_DIR) \
	--enable-freetype \
	--disable-gtk \
	--without-jbig2dec \
	--without-libpaper \
	--with-system-libtiff

ifeq ($(BR2_PACKAGE_LIBIDN),y)
GHOSTSCRIPT_DEPENDENCIES += libidn
GHOSTSCRIPT_CONF_OPTS += --with-libidn
else
GHOSTSCRIPT_CONF_OPTS += --without-libidn
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
GHOSTSCRIPT_DEPENDENCIES += xlib_libX11
GHOSTSCRIPT_CONF_OPTS += --with-x
else
GHOSTSCRIPT_CONF_OPTS += --without-x
endif

$(eval $(autotools-package))
