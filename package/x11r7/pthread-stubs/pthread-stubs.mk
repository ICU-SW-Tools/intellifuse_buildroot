#############################################################
#
# pthread-stubs
#
#############################################################
PTHREAD_STUBS_VERSION = 0.3
PTHREAD_STUBS_SOURCE = libpthread-stubs-$(PTHREAD_STUBS_VERSION).tar.bz2
PTHREAD_STUBS_SITE = http://xcb.freedesktop.org/dist/

PTHREAD_STUBS_LIBTOOL_PATCH = NO
PTHREAD_STUBS_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package/x11r7,pthread-stubs))
$(eval $(call AUTOTARGETS,package/x11r7,pthread-stubs,host))

