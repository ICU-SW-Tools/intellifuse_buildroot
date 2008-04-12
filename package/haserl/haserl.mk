#############################################################
#
# haserl
#
#############################################################

HASERL_VERSION:=$(strip $(subst ",,$(BR2_PACKAGE_HASERL_VERSION)))
#"))
HASERL_SOURCE:=haserl-$(HASERL_VERSION).tar.gz
HASERL_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/haserl/
HASERL_DIR:=$(BUILD_DIR)/haserl-$(HASERL_VERSION)
HASERL_CAT:=$(ZCAT)
HASERL_BINARY:=usr/bin/haserl

$(DL_DIR)/$(HASERL_SOURCE):
	$(WGET) -P $(DL_DIR) $(HASERL_SITE)/$(HASERL_SOURCE)

$(HASERL_DIR)/.unpacked: $(DL_DIR)/$(HASERL_SOURCE)
	$(HASERL_CAT) $(DL_DIR)/$(HASERL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(HASERL_DIR) package/haserl/ haserl-$(HASERL_VERSION)\*.patch
	touch $@

$(HASERL_DIR)/.configured: $(HASERL_DIR)/.unpacked
	(cd $(HASERL_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
	)
	touch $@

$(HASERL_DIR)/src/haserl: $(HASERL_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(HASERL_DIR)

$(TARGET_DIR)/$(HASERL_BINARY): $(HASERL_DIR)/src/haserl
	cp $^ $@

haserl: uclibc $(TARGET_DIR)/$(HASERL_BINARY)

haserl-source: $(DL_DIR)/$(HASERL_SOURCE)

haserl-unpacked: $(HASERL_DIR)/.unpacked

haserl-clean:
	-$(MAKE) -C $(HASERL_DIR) clean
	rm -f $(TARGET_DIR)/$(HASERL_BINARY)

haserl-dirclean:
	rm -rf $(HASERL_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_HASERL)),y)
TARGETS+=haserl
endif
