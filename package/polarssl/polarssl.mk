################################################################################
#
# polarssl
#
################################################################################

POLARSSL_SITE = https://polarssl.org/code/releases
POLARSSL_VERSION = 1.2.12
POLARSSL_SOURCE = polarssl-$(POLARSSL_VERSION)-gpl.tgz
POLARSSL_CONF_OPTS = \
	-DENABLE_PROGRAMS=$(if $(BR2_PACKAGE_POLARSSL_PROGRAMS),ON,OFF)

POLARSSL_INSTALL_STAGING = YES
POLARSSL_LICENSE = GPLv2
POLARSSL_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
