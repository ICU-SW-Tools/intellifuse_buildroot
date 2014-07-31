################################################################################
#
# libsysfs
#
################################################################################

LIBSYSFS_VERSION = 2.1.0
LIBSYSFS_SITE = http://downloads.sourceforge.net/project/linux-diag/sysfsutils/$(LIBSYSFS_VERSION)
LIBSYSFS_SOURCE = sysfsutils-$(LIBSYSFS_VERSION).tar.gz
LIBSYSFS_INSTALL_STAGING = YES
# libtool 1.5 patch failure
LIBSYSFS_AUTORECONF = YES
LIBSYSFS_AUTORECONF_OPT = -Im4/
LIBSYSFS_LICENSE = GPLv2 (utilities), LGPLv2.1+ (library)
LIBSYSFS_LICENSE_FILES = cmd/GPL lib/LGPL

$(eval $(autotools-package))
