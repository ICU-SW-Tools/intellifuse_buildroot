################################################################################
#
# xdriver_xf86-input-evdev -- Generic Linux input driver
#
################################################################################

XDRIVER_XF86_INPUT_EVDEV_VERSION = 2.3.0
XDRIVER_XF86_INPUT_EVDEV_SOURCE = xf86-input-evdev-$(XDRIVER_XF86_INPUT_EVDEV_VERSION).tar.bz2
XDRIVER_XF86_INPUT_EVDEV_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_EVDEV_AUTORECONF = NO
XDRIVER_XF86_INPUT_EVDEV_DEPENDENCIES = xproto_inputproto xserver_xorg-server xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-evdev))
