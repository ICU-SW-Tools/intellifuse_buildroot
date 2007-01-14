#############################################################
#
# freetype
#
#############################################################
FREETYPE_VERSION:=2.2.1
FREETYPE_SOURCE:=freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/freetype
FREETYPE_CAT:=$(BZCAT)
FREETYPE_DIR:=$(BUILD_DIR)/freetype-$(FREETYPE_VERSION)

$(DL_DIR)/$(FREETYPE_SOURCE):
	$(WGET) -P $(DL_DIR) $(FREETYPE_SITE)/$(FREETYPE_SOURCE)

freetype-source: $(DL_DIR)/$(FREETYPE_SOURCE)

$(FREETYPE_DIR)/.unpacked: $(DL_DIR)/$(FREETYPE_SOURCE)
	$(FREETYPE_CAT) $(DL_DIR)/$(FREETYPE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(FREETYPE_DIR)/.unpacked

$(FREETYPE_DIR)/.configured: $(FREETYPE_DIR)/.unpacked
	(cd $(FREETYPE_DIR); \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS) " \
	CCexe="$(HOSTCC)" \
	./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
	);
	touch $(FREETYPE_DIR)/.configured

$(FREETYPE_DIR)/.compiled: $(FREETYPE_DIR)/.configured
	$(MAKE) CCexe="$(HOSTCC)" -C $(FREETYPE_DIR)
	touch $(FREETYPE_DIR)/.compiled

$(STAGING_DIR)/lib/libfreetype.so: $(FREETYPE_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(FREETYPE_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libfreetype.la
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/include\',g" \
		-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" \
		$(STAGING_DIR)/usr/bin/freetype-config
	touch -c $(STAGING_DIR)/lib/libfreetype.so

$(TARGET_DIR)/lib/libfreetype.so: $(STAGING_DIR)/lib/libfreetype.so
	cp -dpf $(STAGING_DIR)/lib/libfreetype.so* $(TARGET_DIR)/lib/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libfreetype.so

freetype: uclibc pkgconfig $(TARGET_DIR)/lib/libfreetype.so

freetype-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(FREETYPE_DIR) uninstall
	-$(MAKE) -C $(FREETYPE_DIR) clean

freetype-dirclean:
	rm -rf $(FREETYPE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_FREETYPE)),y)
TARGETS+=freetype
endif
