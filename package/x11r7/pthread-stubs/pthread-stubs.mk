#############################################################
#
# pthread-stubs
#
#############################################################
PTHREAD_STUBS_VERSION = 0.1
PTHREAD_STUBS_SOURCE = libpthread-stubs-$(PTHREAD_STUBS_VERSION).tar.bz2
PTHREAD_STUBS_SITE = http://xcb.freedesktop.org/dist/

PTHREAD_STUBS_DEPENDANCIES = uclibc
PTHREAD_STUBS_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,pthread-stubs))

