################################################################################
#
# ifupdown-scripts
#
################################################################################

define IFUPDOWN_SCRIPTS_LOCALHOST
	( \
		echo "# interface file auto-generated by buildroot"; \
		echo ; \
		echo "auto lo"; \
		echo "iface lo inet loopback"; \
	) > $(TARGET_DIR)/etc/network/interfaces
endef

IFUPDOWN_SCRIPTS_DHCP_IFACE = $(call qstrip,$(BR2_SYSTEM_DHCP))

ifneq ($(IFUPDOWN_SCRIPTS_DHCP_IFACE),)
define IFUPDOWN_SCRIPTS_DHCP
	( \
		echo ; \
		echo "auto $(IFUPDOWN_SCRIPTS_DHCP_IFACE)"; \
		echo "iface $(IFUPDOWN_SCRIPTS_DHCP_IFACE) inet dhcp"; \
		echo "  pre-up /etc/network/nfs_check"; \
		echo "  wait-delay 15"; \
	) >> $(TARGET_DIR)/etc/network/interfaces
	$(INSTALL) -m 0755 -D $(IFUPDOWN_SCRIPTS_PKGDIR)/nfs_check \
		$(TARGET_DIR)/etc/network/nfs_check
endef
endif

define IFUPDOWN_SCRIPTS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/network
	$(call SYSTEM_RSYNC,$(IFUPDOWN_SCRIPTS_PKGDIR)/network,$(TARGET_DIR)/etc/network)
	$(IFUPDOWN_SCRIPTS_LOCALHOST)
	$(IFUPDOWN_SCRIPTS_DHCP)
endef

define IFUPDOWN_SCRIPTS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(IFUPDOWN_SCRIPTS_PKGDIR)/S40network \
		$(TARGET_DIR)/etc/init.d/S40network
endef

# ifupdown-scripts can not be selected when systemd-networkd is
# enabled, so if we are enabled with systemd, we must install our
# own service file.
define IFUPDOWN_SCRIPTS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(IFUPDOWN_SCRIPTS_PKGDIR)/network.service \
		$(TARGET_DIR)/etc/systemd/system/network.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../network.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/network.service
endef

$(eval $(generic-package))
