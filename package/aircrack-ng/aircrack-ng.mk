################################################################################
#
# aircrack-ng
#
################################################################################

AIRCRACK_NG_VERSION = 1.2-rc1
AIRCRACK_NG_SITE = http://download.aircrack-ng.org
AIRCRACK_NG_LICENSE = GPLv2+
AIRCRACK_NG_LICENSE_FILES = LICENSE
AIRCRACK_NG_DEPENDENCIES = openssl zlib host-pkgconf
# Enable buddy-ng, easside-ng, tkiptun-ng, wesside-ng
AIRCRACK_NG_MAKE_OPTS = unstable=true

# Account for libpthread in static
AIRCRACK_NG_LDFLAGS = $(TARGET_LDFLAGS) \
	$(if $(BR2_PREFER_STATIC_LIB),-lpthread)

# libnl support has issues when building static
ifeq ($(BR2_PREFER_STATIC_LIB),y)
	AIRCRACK_NG_MAKE_OPTS += libnl=false
else
	AIRCRACK_NG_MAKE_OPTS += libnl=true
	AIRCRACK_NG_DEPENDENCIES += libnl
endif

ifeq ($(BR2_PACKAGE_LIBPCAP),y)
	AIRCRACK_NG_DEPENDENCIES += libpcap
	AIRCRACK_NG_MAKE_OPTS += HAVE_PCAP=yes \
		$(if $(BR2_PREFER_STATIC_LIB),LIBPCAP="-lpcap $(shell $(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs)")
else
	AIRCRACK_NG_MAKE_OPTS += HAVE_PCAP=no
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
	AIRCRACK_NG_DEPENDENCIES += pcre
	AIRCRACK_NG_MAKE_OPTS += pcre=true
else
	AIRCRACK_NG_MAKE_OPTS += pcre=false
endif

ifeq ($(BR2_PACKAGE_SQLITE),y)
	AIRCRACK_NG_DEPENDENCIES += sqlite
	AIRCRACK_NG_MAKE_OPTS += sqlite=true LIBSQL="-lsqlite3"
else
	AIRCRACK_NG_MAKE_OPTS += sqlite=false
endif

define AIRCRACK_NG_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) LDFLAGS="$(AIRCRACK_NG_LDFLAGS)" \
		$(MAKE) -C $(@D) $(AIRCRACK_NG_MAKE_OPTS)
endef

define AIRCRACK_NG_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) \
		prefix=/usr $(AIRCRACK_NG_MAKE_OPTS) install
endef

$(eval $(generic-package))
