#############################################################
#
# less
#
#############################################################

LESS_VERSION = 444
LESS_SITE = http://www.greenwoodsoftware.com/less
# Build after busybox, full-blown is better
LESS_DEPENDENCIES = ncurses $(if $(BR2_PACKAGE_BUSYBOX),busybox)

define LESS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/less $(TARGET_DIR)/usr/bin/less
endef

define LESS_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/less
endef

$(eval $(autotools-package))
