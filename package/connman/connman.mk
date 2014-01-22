################################################################################
#
# connman
#
################################################################################

CONNMAN_VERSION = 1.19
CONNMAN_SOURCE = connman-$(CONNMAN_VERSION).tar.xz
CONNMAN_SITE = $(BR2_KERNEL_MIRROR)/linux/network/connman/
CONNMAN_DEPENDENCIES = libglib2 dbus iptables gnutls
CONNMAN_INSTALL_STAGING = YES
CONNMAN_LICENSE = GPLv2
CONNMAN_LICENSE_FILES = COPYING
CONNMAN_CONF_OPT += --localstatedir=/var \
	$(if $(BR2_PACKAGE_CONNMAN_DEBUG),--enable-debug,--disable-debug)		\
	$(if $(BR2_PACKAGE_CONNMAN_ETHERNET),--enable-ethernet,--disable-ethernet)	\
	$(if $(BR2_PACKAGE_CONNMAN_WIFI),--enable-wifi,--disable-wifi)			\
	$(if $(BR2_PACKAGE_CONNMAN_BLUETOOTH),--enable-bluetooth,--disable-bluetooth)	\
	$(if $(BR2_PACKAGE_CONNMAN_LOOPBACK),--enable-loopback,--disable-loopback)	\
	$(if $(BR2_PACKAGE_CONNMAN_NEARD),--enable-neard,--disable-neard) \
	$(if $(BR2_PACKAGE_CONNMAN_OFONO),--enable-ofono,--disable-ofono)

CONNMAN_DEPENDENCIES += \
	$(if $(BR2_PACKAGE_CONNMAN_NEARD),neard) \
	$(if $(BR2_PACKAGE_CONNMAN_OFONO),ofono)

define CONNMAN_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/connman/S45connman $(TARGET_DIR)/etc/init.d/S45connman
endef


ifeq ($(BR2_PACKAGE_CONNMAN_CLIENT),y)
CONNMAN_CONF_OPT += --enable-client
CONNMAN_DEPENDENCIES += readline

define CONNMAN_INSTALL_CM
	$(INSTALL) -m 0755 -D $(@D)/client/connmanctl $(TARGET_DIR)/usr/bin/connmanctl
endef

CONNMAN_POST_INSTALL_TARGET_HOOKS += CONNMAN_INSTALL_CM
else
CONNMAN_CONF_OPT += --disable-client
endif

$(eval $(autotools-package))
