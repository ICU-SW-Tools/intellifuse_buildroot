#############################################################
#
# e2fsprogs
#
#############################################################
E2FSPROGS_VER:=1.36
E2FSPROGS_SOURCE=e2fsprogs-$(E2FSPROGS_VER).tar.gz
E2FSPROGS_SITE=http://telia.dl.sourceforge.net/sourceforge/e2fsprogs
E2FSPROGS_DIR=$(BUILD_DIR)/e2fsprogs-$(E2FSPROGS_VER)
E2FSPROGS_CAT:=zcat
E2FSPROGS_BINARY:=misc/mke2fs
E2FSPROGS_TARGET_BINARY:=sbin/mke2fs

$(DL_DIR)/$(E2FSPROGS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(E2FSPROGS_SITE)/$(E2FSPROGS_SOURCE)

e2fsprogs-source: $(DL_DIR)/$(E2FSPROGS_SOURCE)

$(E2FSPROGS_DIR)/.unpacked: $(DL_DIR)/$(E2FSPROGS_SOURCE)
	$(E2FSPROGS_CAT) $(DL_DIR)/$(E2FSPROGS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(E2FSPROGS_DIR)/.unpacked

$(E2FSPROGS_DIR)/.configured: $(E2FSPROGS_DIR)/.unpacked
	(cd $(E2FSPROGS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--with-cc=$(TARGET_CC) \
		--with-linker=$(TARGET_CROSS)ld \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-elf-shlibs --disable-swapfs \
		--disable-debugfs --disable-imager \
		--disable-resizer --without-catgets $(DISABLE_NLS) \
	);
	touch  $(E2FSPROGS_DIR)/.configured

$(E2FSPROGS_DIR)/$(E2FSPROGS_BINARY): $(E2FSPROGS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(E2FSPROGS_DIR)
	-$(STRIP) $(E2FSPROGS_DIR)/misc/*
	touch -c $(E2FSPROGS_DIR)/$(E2FSPROGS_BINARY)

$(TARGET_DIR)/$(E2FSPROGS_TARGET_BINARY): $(E2FSPROGS_DIR)/$(E2FSPROGS_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(E2FSPROGS_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	touch -c $(TARGET_DIR)/$(E2FSPROGS_TARGET_BINARY)

e2fsprogs: uclibc $(TARGET_DIR)/$(E2FSPROGS_TARGET_BINARY)

e2fsprogs-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(E2FSPROGS_DIR) uninstall
	-$(MAKE) -C $(E2FSPROGS_DIR) clean

e2fsprogs-dirclean:
	rm -rf $(E2FSPROGS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_E2FSPROGS)),y)
TARGETS+=e2fsprogs
endif

