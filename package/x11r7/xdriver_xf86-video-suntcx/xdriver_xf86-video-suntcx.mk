################################################################################
#
# xdriver_xf86-video-suntcx -- TCX video driver
#
################################################################################

XDRIVER_XF86_VIDEO_SUNTCX_VERSION = 1.1.0
XDRIVER_XF86_VIDEO_SUNTCX_SOURCE = xf86-video-suntcx-$(XDRIVER_XF86_VIDEO_SUNTCX_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SUNTCX_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SUNTCX_AUTORECONF = NO
XDRIVER_XF86_VIDEO_SUNTCX_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xproto
XDRIVER_XF86_VIDEO_SUNTCX_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-suntcx))
