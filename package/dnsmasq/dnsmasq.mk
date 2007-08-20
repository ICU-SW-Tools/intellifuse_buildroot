#############################################################
#
# dnsmasq
#
#############################################################

DNSMASQ_SITE=http://thekelleys.org.uk/dnsmasq
ifeq ($(filter $(TARGETS),dnsmasq1),)
DNSMASQ_UPVER=2.39
DNSMASQ_VERSION=dnsmasq2
else
DNSMASQ_UPVER=1.18
DNSMASQ_VERSION=dnsmasq1
endif
DNSMASQ_SOURCE=dnsmasq-$(DNSMASQ_UPVER).tar.gz
DNSMASQ_DIR=$(BUILD_DIR)/dnsmasq-$(DNSMASQ_UPVER)
DNSMASQ_BINARY=dnsmasq
DNSMASQ_TARGET_BINARY=usr/sbin/dnsmasq

$(DL_DIR)/$(DNSMASQ_SOURCE):
	$(WGET) -P $(DL_DIR) $(DNSMASQ_SITE)/$(DNSMASQ_SOURCE)

$(DNSMASQ_DIR)/.source: $(DL_DIR)/$(DNSMASQ_SOURCE)
	$(ZCAT) $(DL_DIR)/$(DNSMASQ_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(DNSMASQ_DIR) package/dnsmasq/ \
		$(DNSMASQ_VERSION)\*.patch
	touch $@

$(DNSMASQ_DIR)/src/$(DNSMASQ_BINARY): $(DNSMASQ_DIR)/.source
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" \
		PREFIX=/usr -C $(DNSMASQ_DIR)

$(TARGET_DIR)/$(DNSMASQ_TARGET_BINARY): $(DNSMASQ_DIR)/src/$(DNSMASQ_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) PREFIX=/usr -C $(DNSMASQ_DIR) install
	$(STRIP) $(TARGET_DIR)/$(DNSMASQ_TARGET_BINARY)
	mkdir -p $(TARGET_DIR)/var/lib/misc
	# Isn't this vulverable to symlink attacks?
	ln -sf /tmp/dnsmasq.leases $(TARGET_DIR)/var/lib/misc/dnsmasq.leases
	# Another questionable wipe out :(
	#rm -rf $(TARGET_DIR)/usr/share/man

dnsmasq: uclibc $(TARGET_DIR)/$(DNSMASQ_TARGET_BINARY)

dnsmasq1: uclibc $(TARGET_DIR)/$(DNSMASQ_TARGET_BINARY)

dnsmasq-source: $(DL_DIR)/$(DNSMASQ_SOURCE)

dnsmasq-clean:
	rm -f $(addprefix $(TARGET_DIR)/,var/lib/misc/dnsmasq.leases \
					 usr/share/man/man?/dnsmasq.* \
					 $(DNSMASQ_TARGET_BINARY))
	-$(MAKE) -C $(DNSMASQ_DIR) clean

dnsmasq-dirclean:
	rm -rf $(DNSMASQ_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DNSMASQ)),y)
TARGETS+=dnsmasq
endif
