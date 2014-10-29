################################################################################
#
# tcpdump
#
################################################################################

TCPDUMP_VERSION = 4.6.2
TCPDUMP_SITE = http://www.tcpdump.org/release
TCPDUMP_LICENSE = BSD-3c
TCPDUMP_LICENSE_FILES = LICENSE
TCPDUMP_CONF_ENV = ac_cv_linux_vers=2 td_cv_buggygetaddrinfo=no \
		PCAP_CONFIG=$(STAGING_DIR)/usr/bin/pcap-config
TCPDUMP_CONF_OPTS = --without-crypto --with-system-libpcap \
		$(if $(BR2_PACKAGE_TCPDUMP_SMB),--enable-smb,--disable-smb)
TCPDUMP_DEPENDENCIES = zlib libpcap
# Patching aclocal.m4
TCPDUMP_AUTORECONF = YES

# make install installs an unneeded extra copy of the tcpdump binary
define TCPDUMP_REMOVE_DUPLICATED_BINARY
	rm -f $(TARGET_DIR)/usr/sbin/tcpdump.$(TCPDUMP_VERSION)
endef

TCPDUMP_POST_INSTALL_TARGET_HOOKS += TCPDUMP_REMOVE_DUPLICATED_BINARY

$(eval $(autotools-package))
