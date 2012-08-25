#############################################################
#
# libdmtx
#
#############################################################

LIBDMTX_VERSION = 0.7.4
LIBDMTX_SOURCE = libdmtx-$(LIBDMTX_VERSION).tar.gz
LIBDMTX_SITE = http://downloads.sourceforge.net/project/libdmtx/libdmtx/$(LIBDMTX_VERSION)
LIBDMTX_INSTALL_STAGING = YES

$(eval $(autotools-package))
