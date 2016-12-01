################################################################################
#
# ustream-ssl
#
################################################################################

USTREAM_SSL_VERSION = ec80adaa1b47f28d426fa19c692011ce60b992d6
USTREAM_SSL_SITE = git://git.openwrt.org/project/ustream-ssl.git
USTREAM_SSL_LICENSE = ISC
USTREAM_SSL_LICENSE_FILES = ustream-ssl.h
USTREAM_SSL_INSTALL_STAGING = YES
USTREAM_SSL_DEPENDENCIES = libubox

ifeq ($(BR2_PACKAGE_MBEDTLS),y)
USTREAM_SSL_DEPENDENCIES += mbedtls
USTREAM_SSL_CONF_OPTS += -DMBEDTLS=ON
else
USTREAM_SSL_DEPENDENCIES += openssl
endif

$(eval $(cmake-package))
