#############################################################
#
# PCRE
#
#############################################################
PCRE_VERSION = 7.7
PCRE_SOURCE = pcre-$(PCRE_VERSION).tar.bz2
PCRE_SITE = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre
PCRE_INSTALL_STAGING = YES
PCRE_INSTALL_TARGET = YES
PCRE_INSTALL_TARGET_OPT:=DESTDIR=$(TARGET_DIR) install-strip

ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
# pcre will use the host g++ if a cross version isn't available
PCRE_CONF_OPT = --disable-cpp
endif

PCRE_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,pcre))

$(PCRE_HOOK_POST_INSTALL): $(PCRE_TARGET_INSTALL_TARGET)
	rm -rf $(TARGET_DIR)/usr/share/doc/pcre
	touch $@
