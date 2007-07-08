#############################################################
#
# lighttpd
#
#############################################################
LIGHTTPD_VERSION:=1.4.15
LIGHTTPD_SOURCE:=lighttpd_$(LIGHTTPD_VERSION).orig.tar.gz
LIGHTTPD_PATCH:=lighttpd_$(LIGHTTPD_VERSION)-1.diff.gz
LIGHTTPD_SITE:=http://ftp.debian.org/debian/pool/main/l/lighttpd
LIGHTTPD_DIR:=$(BUILD_DIR)/lighttpd-$(LIGHTTPD_VERSION)
LIGHTTPD_CAT:=$(ZCAT)
LIGHTTPD_BINARY:=src/lighttpd
LIGHTTPD_TARGET_BINARY:=usr/sbin/lighttpd

ifneq ($(BR2_LARGEFILE),y)
LIGHTTPD_LFS:=--disable-lfs
endif

$(DL_DIR)/$(LIGHTTPD_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIGHTTPD_SITE)/$(LIGHTTPD_SOURCE)
ifneq ($(LIGHTTPD_PATCH),)
LIGHTTPD_PATCH_FILE:=$(DL_DIR)/$(LIGHTTPD_PATCH)
$(LIGHTTPD_PATCH_FILE):
	 $(WGET) -P $(DL_DIR) $(LIGHTTPD_SITE)/$(LIGHTTPD_PATCH)
endif
lighttpd-source: $(DL_DIR)/$(LIGHTTPD_SOURCE) $(LIGHTTPD_PATCH_FILE)

$(LIGHTTPD_DIR)/.unpacked: $(DL_DIR)/$(LIGHTTPD_SOURCE)
	$(LIGHTTPD_CAT) $(DL_DIR)/$(LIGHTTPD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIGHTTPD_DIR) package/lighttpd/ lighttpd\*.patch
ifneq ($(LIGHTTPD_PATCH),)
	(cd $(LIGHTTPD_DIR)&&$(LIGHTTPD_CAT) $(LIGHTTPD_PATCH_FILE)|patch -p1)
endif
	if [ -d $(LIGHTTPD_DIR)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(LIGHTTPD_DIR) $(LIGHTTPD_DIR)/debian/patches \*.dpatch ; \
	fi
	$(CONFIG_UPDATE) $(@D)
	$(SED) 's/-lfs/-largefile/g;s/_lfs/_largefile/g' $(LIGHTTPD_DIR)/configure
	touch $@

$(LIGHTTPD_DIR)/.configured: $(LIGHTTPD_DIR)/.unpacked
	(cd $(LIGHTTPD_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-openssl \
		--without-pcre \
		--program-prefix="" \
		$(DISABLE_IPV6) \
		$(DISABLE_LARGEFILE) \
	);
	touch $@

$(LIGHTTPD_DIR)/$(LIGHTTPD_BINARY): $(LIGHTTPD_DIR)/.configured
	$(MAKE) -C $(LIGHTTPD_DIR)
    
$(TARGET_DIR)/$(LIGHTTPD_TARGET_BINARY): $(LIGHTTPD_DIR)/$(LIGHTTPD_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(LIGHTTPD_DIR) install
	$(INSTALL) -m 0755 -D $(LIGHTTPD_DIR)/debian/init.d $(TARGET_DIR)/etc/init.d/S99lighttpd

lighttpd: uclibc openssl $(TARGET_DIR)/$(LIGHTTPD_TARGET_BINARY)

lighttpd-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(LIGHTTPD_DIR) uninstall
	-$(MAKE) -C $(LIGHTTPD_DIR) clean

lighttpd-dirclean:
	rm -rf $(LIGHTTPD_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIGHTTPD)),y)
TARGETS+=lighttpd
endif
