#############################################################
#
# ipkg
#
#############################################################

IPKG_VERSION = 0.99.163
IPKG_SOURCE = ipkg-$(IPKG_VERSION).tar.gz
IPKG_SITE = http://www.handhelds.org/download/packages/ipkg
IPKG_AUTORECONF = NO
IPKG_INSTALL_STAGING = YES
IPKG_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS))
