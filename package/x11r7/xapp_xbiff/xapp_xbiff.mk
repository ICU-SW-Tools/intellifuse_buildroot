################################################################################
#
# xapp_xbiff -- mailbox flag for X
#
################################################################################

XAPP_XBIFF_VERSION = 1.0.1
XAPP_XBIFF_SOURCE = xbiff-$(XAPP_XBIFF_VERSION).tar.bz2
XAPP_XBIFF_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XBIFF_AUTORECONF = YES
XAPP_XBIFF_DEPENDANCIES = xlib_libXaw xdata_xbitmaps

$(eval $(call AUTOTARGETS,xapp_xbiff))
