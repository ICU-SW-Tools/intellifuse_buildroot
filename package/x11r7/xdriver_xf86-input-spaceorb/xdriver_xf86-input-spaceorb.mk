################################################################################
#
# xdriver_xf86-input-spaceorb -- X.Org driver for spaceorb input devices
#
################################################################################

XDRIVER_XF86_INPUT_SPACEORB_VERSION = 1.1.0
XDRIVER_XF86_INPUT_SPACEORB_SOURCE = xf86-input-spaceorb-$(XDRIVER_XF86_INPUT_SPACEORB_VERSION).tar.bz2
XDRIVER_XF86_INPUT_SPACEORB_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_SPACEORB_AUTORECONF = YES
XDRIVER_XF86_INPUT_SPACEORB_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-input-spaceorb))
