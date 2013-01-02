#############################################################
#
# gnutls
#
#############################################################

GNUTLS_VERSION = 3.1.5
GNUTLS_SOURCE = gnutls-$(GNUTLS_VERSION).tar.xz
GNUTLS_SITE = $(BR2_GNU_MIRROR)/gnutls
GNUTLS_LICENSE = GPLv3+ LGPLv3
GNUTLS_LICENSE_FILES = COPYING COPYING.LESSER
GNUTLS_DEPENDENCIES = host-pkgconf nettle $(if $(BR2_PACKAGE_ZLIB),zlib)
GNUTLS_CONF_OPT = --with-libnettle-prefix=$(STAGING_DIR)/usr --disable-rpath
GNUTLS_CONF_ENV = gl_cv_socket_ipv6=$(if $(BR2_INET_IPV6),yes,no) \
	ac_cv_header_wchar_h=$(if $(BR2_USE_WCHAR),yes,no) \
	gt_cv_c_wchar_t=$(if $(BR2_USE_WCHAR),yes,no) \
	gt_cv_c_wint_t=$(if $(BR2_USE_WCHAR),yes,no)
GNUTLS_INSTALL_STAGING = YES

# libpthread autodetection poisons the linkpath
GNUTLS_CONF_OPT += $(if $(BR2_TOOLCHAIN_HAS_THREADS),--with-libpthread-prefix=$(STAGING_DIR)/usr)

# Some examples in doc/examples use wchar
define GNUTLS_DISABLE_DOCS
	$(SED) 's/ doc / /' $(@D)/Makefile.in
endef

define GNUTLS_DISABLE_TOOLS
	$(SED) 's/\$$(PROGRAMS)//' $(@D)/src/Makefile.in
	$(SED) 's/) install-exec-am/)/' $(@D)/src/Makefile.in
endef

GNUTLS_POST_PATCH_HOOKS += GNUTLS_DISABLE_DOCS
GNUTLS_POST_PATCH_HOOKS += $(if $(BR2_PACKAGE_GNUTLS_TOOLS),,GNUTLS_DISABLE_TOOLS)

$(eval $(autotools-package))
