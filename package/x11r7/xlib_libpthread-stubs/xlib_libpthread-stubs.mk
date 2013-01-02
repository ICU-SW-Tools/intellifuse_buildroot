#############################################################
#
# xlib_libpthread-stubs
#
#############################################################
XLIB_LIBPTHREAD_STUBS_VERSION = 0.3
XLIB_LIBPTHREAD_STUBS_SOURCE = libpthread-stubs-$(XLIB_LIBPTHREAD_STUBS_VERSION).tar.bz2
XLIB_LIBPTHREAD_STUBS_SITE = http://xcb.freedesktop.org/dist/

XLIB_LIBPTHREAD_STUBS_INSTALL_STAGING = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))

