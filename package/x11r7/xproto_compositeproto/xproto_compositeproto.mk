################################################################################
#
# xproto_compositeproto -- X.Org Composite protocol headers
#
################################################################################

XPROTO_COMPOSITEPROTO_VERSION = 0.3.1
XPROTO_COMPOSITEPROTO_SOURCE = compositeproto-$(XPROTO_COMPOSITEPROTO_VERSION).tar.bz2
XPROTO_COMPOSITEPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_COMPOSITEPROTO_AUTORECONF = YES
XPROTO_COMPOSITEPROTO_INSTALL_STAGING = YES
XPROTO_COMPOSITEPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,xproto_compositeproto))
