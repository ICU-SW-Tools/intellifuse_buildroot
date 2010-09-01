#############################################################
#
# kexec
#
#############################################################
KEXEC_VERSION = 2.0.1
KEXEC_SOURCE = kexec-tools-$(KEXEC_VERSION).tar.bz2
KEXEC_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/people/horms/kexec-tools/
# no install-strip/install-exec
KEXEC_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

ifeq ($(BR2_PACKAGE_KEXEC_ZLIB),y)
KEXEC_CONF_OPT += --with-zlib
KEXEC_DEPENDENCIES = zlib
else
KEXEC_CONF_OPT += --without-zlib
endif

define KEXEC_REMOVE_LIB_TOOLS
	rm -rf $(TARGET_DIR)/usr/lib/kexec-tools
endef

KEXEC_POST_INSTALL_TARGET_HOOKS += KEXEC_REMOVE_LIB_TOOLS

$(eval $(call AUTOTARGETS,package,kexec))
