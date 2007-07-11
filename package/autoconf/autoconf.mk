#############################################################
#
# autoconf
#
#############################################################
AUTOCONF_VERSION:=2.61
AUTOCONF_SOURCE:=autoconf-$(AUTOCONF_VERSION).tar.bz2
AUTOCONF_SITE:=http://ftp.gnu.org/pub/gnu/autoconf
AUTOCONF_CAT:=$(BZCAT)
AUTOCONF_SRC_DIR:=$(TOOL_BUILD_DIR)/autoconf-$(AUTOCONF_VERSION)
AUTOCONF_DIR:=$(BUILD_DIR)/autoconf-$(AUTOCONF_VERSION)
AUTOCONF_HOST_DIR:=$(TOOL_BUILD_DIR)/autoconf-$(AUTOCONF_VERSION)-host
AUTOCONF_BINARY:=autoconf
AUTOCONF_TARGET_BINARY:=usr/bin/autoconf
AUTOCONF:=$(STAGING_DIR)/usr/bin/autoconf

# variables used by other packages
AUTORECONF = $(HOST_CONFIGURE_OPTS) ACLOCAL="$(ACLOCAL)" autoreconf -v -f -i -I "$(ACLOCAL_DIR)"

$(DL_DIR)/$(AUTOCONF_SOURCE):
	 $(WGET) -P $(DL_DIR) $(AUTOCONF_SITE)/$(AUTOCONF_SOURCE)

autoconf-source: $(DL_DIR)/$(AUTOCONF_SOURCE)

$(AUTOCONF_SRC_DIR)/.unpacked: $(DL_DIR)/$(AUTOCONF_SOURCE)
	$(AUTOCONF_CAT) $(DL_DIR)/$(AUTOCONF_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

#############################################################
#
# autoconf for the host
#
#############################################################

$(AUTOCONF_DIR)/.configured: $(AUTOCONF_SRC_DIR)/.unpacked
	mkdir -p $(AUTOCONF_DIR)
	(cd $(AUTOCONF_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		EMACS="no" \
		$(AUTOCONF_SRC_DIR)/configure \
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
		--mandir=/usr/man \
		--infodir=/usr/info \
	);
	touch $@

$(AUTOCONF_DIR)/bin/$(AUTOCONF_BINARY): $(AUTOCONF_DIR)/.configured
	$(MAKE1) -C $(AUTOCONF_DIR)

$(TARGET_DIR)/$(AUTOCONF_TARGET_BINARY): $(AUTOCONF_DIR)/bin/$(AUTOCONF_BINARY)
	$(MAKE) \
	    prefix=$(TARGET_DIR)/usr \
	    exec_prefix=$(TARGET_DIR)/usr \
	    bindir=$(TARGET_DIR)/usr/bin \
	    sbindir=$(TARGET_DIR)/usr/sbin \
	    libexecdir=$(TARGET_DIR)/usr/lib \
	    datadir=$(TARGET_DIR)/usr/share \
	    sysconfdir=$(TARGET_DIR)/etc \
	    localstatedir=$(TARGET_DIR)/var \
	    libdir=$(TARGET_DIR)/usr/lib \
	    infodir=$(TARGET_DIR)/usr/info \
	    mandir=$(TARGET_DIR)/usr/man \
	    includedir=$(TARGET_DIR)/usr/include \
	    -C $(AUTOCONF_DIR) install;
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	touch -c $@

autoconf: uclibc $(TARGET_DIR)/$(AUTOCONF_TARGET_BINARY)

autoconf-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(AUTOCONF_DIR) uninstall
	-$(MAKE) -C $(AUTOCONF_DIR) clean

autoconf-dirclean:
	rm -rf $(AUTOCONF_DIR)

#############################################################
#
# autoconf for the host
#
#############################################################

$(AUTOCONF_HOST_DIR)/.configured: $(AUTOCONF_SRC_DIR)/.unpacked
	mkdir -p $(AUTOCONF_HOST_DIR)
	(cd $(AUTOCONF_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		EMACS="no" \
		$(AUTOCONF_SRC_DIR)/configure \
		--prefix=$(STAGING_DIR)/usr \
	);
	touch $@

$(AUTOCONF_HOST_DIR)/bin/$(AUTOCONF_BINARY): $(AUTOCONF_HOST_DIR)/.configured
	$(MAKE1) -C $(AUTOCONF_HOST_DIR)

$(AUTOCONF): $(AUTOCONF_HOST_DIR)/bin/$(AUTOCONF_BINARY)
	$(MAKE) -C $(AUTOCONF_HOST_DIR) install;

host-autoconf: host-m4 host-libtool $(AUTOCONF)

host-autoconf-clean:
	$(MAKE) CC=$(HOST_CC) -C $(AUTOCONF_HOST_DIR) uninstall
	-$(MAKE) -C $(AUTOCONF_HOST_DIR) clean

host-autoconf-dirclean:
	rm -rf $(AUTOCONF_HOST_DIR)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_AUTOCONF)),y)
TARGETS+=autoconf
endif
