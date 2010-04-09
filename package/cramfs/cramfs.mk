#############################################################
#
# cramfs
#
#############################################################

CRAMFS_VERSION=1.1
CRAMFS_SOURCE=cramfs-$(CRAMFS_VERSION).tar.gz
CRAMFS_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/cramfs

CRAMFS_DEPENDENCIES = zlib
HOST_CRAMFS_DEPENDENCIES = host-zlib

define CRAMFS_BUILD_CMDS
 $(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D)
endef

define CRAMFS_INSTALL_TARGET_CMDS
 install -m 755 $(@D)/mkcramfs $(TARGET_DIR)/usr/bin
 install -m 755 $(@D)/cramfsck $(TARGET_DIR)/usr/bin
endef

define HOST_CRAMFS_BUILD_CMDS
 $(HOST_MAKE_ENV) $(MAKE) CFLAGS="$(HOST_CFLAGS) -Wall -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64" LDFLAGS="$(HOST_LDFLAGS)" -C $(@D)
endef

define HOST_CRAMFS_INSTALL_CMDS
 install -m 755 $(@D)/mkcramfs $(HOST_DIR)/usr/bin
 install -m 755 $(@D)/cramfsck $(HOST_DIR)/usr/bin
endef

$(eval $(call GENTARGETS,package,cramfs))
$(eval $(call GENTARGETS,package,cramfs,host))
