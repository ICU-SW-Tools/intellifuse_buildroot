#############################################################
#
# libesmtp
#
#############################################################
LIBESMTP_VERSION = 1.0.6
LIBESMTP_SOURCE = libesmtp-$(LIBESMTP_VERSION).tar.bz2
LIBESMTP_SITE = http://www.stafford.uklinux.net/libesmtp
LIBESMTP_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS))
