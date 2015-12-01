################################################################################
#
# miraclecast
#
################################################################################

MIRACLECAST_VERSION = 8b61f733da124ccbfd1b85e188581fad1c41c1e1
MIRACLECAST_SITE = $(call github,albfan,miraclecast,$(MIRACLECAST_VERSION))
MIRACLECAST_LICENSE = LGPLv2.1+, GPLv2 (gdhcp)
MIRACLECAST_LICENSE_FILES = COPYING LICENSE_gdhcp LICENSE_htable LICENSE_lgpl
MIRACLECAST_DEPENDENCIES = host-pkgconf systemd gstreamer1 \
	readline libglib2
# Straight out the repository, no ./configure
MIRACLECAST_AUTORECONF = YES

define MIRACLECAST_INSTALL_DBUS_POLICY
	$(INSTALL) -m 0644 -D \
		$(@D)/res/org.freedesktop.miracle.conf \
		$(TARGET_DIR)/etc/dbus-1/system.d/org.freedesktop.miracle.conf
endef
MIRACLECAST_POST_INSTALL_TARGET_HOOKS += MIRACLECAST_INSTALL_DBUS_POLICY

$(eval $(autotools-package))
