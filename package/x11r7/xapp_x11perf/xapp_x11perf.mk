################################################################################
#
# xapp_x11perf -- summarize x11perf results
#
################################################################################

XAPP_X11PERF_VERSION = 1.4.1
XAPP_X11PERF_SOURCE = x11perf-$(XAPP_X11PERF_VERSION).tar.bz2
XAPP_X11PERF_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_X11PERF_AUTORECONF = YES
XAPP_X11PERF_DEPENDANCIES = xlib_libX11 xlib_libXmu xlib_libXft

$(eval $(call AUTOTARGETS,xapp_x11perf))
