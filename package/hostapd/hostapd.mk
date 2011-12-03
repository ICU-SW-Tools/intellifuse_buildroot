##############################################################
#
# hostapd
#
#############################################################

HOSTAPD_VERSION = 0.7.3
HOSTAPD_SITE = http://hostap.epitest.fi/releases
HOSTAPD_SUBDIR = hostapd
HOSTAPD_CONFIG = $(HOSTAPD_DIR)/$(HOSTAPD_SUBDIR)/.config
HOSTAPD_DEPENDENCIES = libnl
HOSTAPD_LDFLAGS = $(TARGET_LDFLAGS)

# libnl needs -lm (for rint) if linking statically
ifeq ($(BR2_PREFER_STATIC_LIB),y)
HOSTAPD_LDFLAGS += -lm
endif

define HOSTAPD_LIBNL_CONFIG
	echo "CONFIG_LIBNL20=y" >>$(HOSTAPD_CONFIG)
	echo "CFLAGS += -I$(STAGING_DIR)/usr/include/libnl3/" >>$(HOSTAPD_CONFIG)
endef

define HOSTAPD_CRYPTO_CONFIG
	echo "CONFIG_CRYPTO=internal" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_INTERNAL_LIBTOMMATH=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_INTERNAL_LIBTOMMATH_FAST=y" >>$(HOSTAPD_CONFIG)
endef

# Try to use openssl for TLS if it's already available
# gnutls is also supported for TLS
ifeq ($(BR2_PACKAGE_OPENSSL),y)
	HOSTAPD_DEPENDENCIES += openssl
define HOSTAPD_TLS_CONFIG
	echo "CONFIG_TLS=openssl" >>$(HOSTAPD_CONFIG)
endef
else
define HOSTAPD_TLS_CONFIG
	echo "CONFIG_TLS=internal" >>$(HOSTAPD_CONFIG)
endef
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_EAP),y)
define HOSTAPD_EAP_CONFIG
	$(SED) "s/CONFIG_EAP_MSCHAPV2=y//" $(HOSTAPD_CONFIG)
	$(SED) "s/CONFIG_EAP_PEAP=y//" $(HOSTAPD_CONFIG)
	$(SED) "s/CONFIG_EAP_TLS=y//" $(HOSTAPD_CONFIG)
	$(SED) "s/CONFIG_EAP_TTLS=y//" $(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_AKA=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_AKA_PRIME=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_GPSK=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_GPSK_SHA256=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_PAX=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_PSK=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_SAKE=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_EAP_SIM=y" >>$(HOSTAPD_CONFIG)
	echo "CONFIG_RADIUS_SERVER=y" >>$(HOSTAPD_CONFIG)
endef
ifeq ($(BR2_INET_IPV6),y)
define HOSTAPD_RADIUS_IPV6_CONFIG
	$(SED) "s/^#CONFIG_IPV6/CONFIG_IPV6/" $(HOSTAPD_CONFIG)
endef
endif
else
define HOSTAPD_EAP_CONFIG
	$(SED) "s/^CONFIG_EAP/#CONFIG_EAP/g" $(HOSTAPD_CONFIG)
	$(SED) "s/^#CONFIG_NO_ACCOUNTING/CONFIG_NO_ACCOUNTING/" $(HOSTAPD_CONFIG)
	$(SED) "s/^#CONFIG_NO_RADIUS/CONFIG_NO_RADIUS/" $(HOSTAPD_CONFIG)
endef
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_WPS),y)
define HOSTAPD_WPS_CONFIG
	$(SED) "s/^#CONFIG_WPS/CONFIG_WPS/g" $(HOSTAPD_CONFIG)
endef
endif

define HOSTAPD_CONFIGURE_CMDS
	cp $(@D)/$(HOSTAPD_SUBDIR)/defconfig $(HOSTAPD_CONFIG)
	$(SED) "s/\/local//" $(@D)/$(HOSTAPD_SUBDIR)/Makefile
	echo "CFLAGS += $(TARGET_CFLAGS)" >>$(HOSTAPD_CONFIG)
	echo "LDFLAGS += $(HOSTAPD_LDFLAGS)" >>$(HOSTAPD_CONFIG)
	echo "CC = $(TARGET_CC)" >>$(HOSTAPD_CONFIG)
# Drivers
	$(SED) "s/^#CONFIG_DRIVER_WIRED/CONFIG_DRIVER_WIRED/" $(HOSTAPD_CONFIG)
	$(SED) "s/^#CONFIG_DRIVER_NL80211/CONFIG_DRIVER_NL80211/" $(HOSTAPD_CONFIG)
# Misc
	$(SED) "s/^CONFIG_IPV6/#CONFIG_IPV6/" $(HOSTAPD_CONFIG)
	$(SED) "s/^#CONFIG_IEEE80211N/CONFIG_IEEE80211N/" $(HOSTAPD_CONFIG)
	$(SED) "s/^#CONFIG_IEEE80211R/CONFIG_IEEE80211R/" $(HOSTAPD_CONFIG)
	$(HOSTAPD_CRYPTO_CONFIG)
	$(HOSTAPD_TLS_CONFIG)
	$(HOSTAPD_RADIUS_IPV6_CONFIG)
	$(HOSTAPD_EAP_CONFIG)
	$(HOSTAPD_WPS_CONFIG)
	$(HOSTAPD_LIBNL_CONFIG)
endef

define HOSTAPD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(HOSTAPD_SUBDIR)/hostapd \
		$(TARGET_DIR)/usr/sbin/hostapd
	$(INSTALL) -m 0755 -D $(@D)/$(HOSTAPD_SUBDIR)/hostapd_cli \
		$(TARGET_DIR)/usr/bin/hostapd_cli
endef

define HOSTAPD_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/hostapd
	rm -f $(TARGET_DIR)/usr/bin/hostapd
endef

$(eval $(call AUTOTARGETS))
