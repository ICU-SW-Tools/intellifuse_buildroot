#############################################################
#
# fakeroot
#
#############################################################
FAKEROOT_VERSION = 1.18.2
FAKEROOT_SOURCE = fakeroot_$(FAKEROOT_VERSION).orig.tar.bz2
FAKEROOT_SITE = http://snapshot.debian.org/archive/debian/20111201T093630Z/pool/main/f/fakeroot/

$(eval $(call AUTOTARGETS,host))
