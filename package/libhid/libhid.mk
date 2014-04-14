################################################################################
#
# libhid
#
################################################################################

LIBHID_VERSION = 0.2.16
LIBHID_SITE = http://sources.buildroot.net/
LIBHID_DEPENDENCIES = libusb-compat libusb
LIBHID_INSTALL_STAGING = YES
LIBHID_AUTORECONF = YES
# configure runs libusb-config for cflags/ldflags. Ensure it picks up
# the target version
LIBHID_CONF_ENV = PATH=$(STAGING_DIR)/usr/bin:$(BR_PATH)
LIBHID_CONF_OPT = \
	--disable-swig \
	--disable-werror \
	--without-doxygen \
	--disable-package-config

$(eval $(autotools-package))
