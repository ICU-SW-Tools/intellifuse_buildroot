################################################################################
#
# xlib_libfontenc -- X.Org fontenc library
#
################################################################################

XLIB_LIBFONTENC_VERSION = 1.0.5
XLIB_LIBFONTENC_SOURCE = libfontenc-$(XLIB_LIBFONTENC_VERSION).tar.bz2
XLIB_LIBFONTENC_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBFONTENC_AUTORECONF = NO
XLIB_LIBFONTENC_LIBTOOL_PATCH = NO
XLIB_LIBFONTENC_INSTALL_STAGING = YES
XLIB_LIBFONTENC_DEPENDENCIES = zlib xproto_xproto
XLIB_LIBFONTENC_CONF_OPT = --enable-shared --disable-static

HOST_XLIB_LIBFONTENC_LIBTOOL_PATCH = NO
HOST_XLIB_LIBFONTENC_DEPENDENCIES = host-zlib host-xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libfontenc))
$(eval $(call AUTOTARGETS,package/x11r7,xlib_libfontenc,host))
