#############################################################
#
# Build the ubifs root filesystem image
#
#############################################################

UBIFS_OPTS := -e $(BR2_TARGET_ROOTFS_UBIFS_LEBSIZE) -c $(BR2_TARGET_ROOTFS_UBIFS_MAXLEBCNT) -m $(BR2_TARGET_ROOTFS_UBIFS_MINIOSIZE)

ifeq ($(BR2_TARGET_ROOTFS_UBIFS_RT_ZLIB),y)
UBIFS_OPTS += -x zlib
endif
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_RT_LZI),y)
UBIFS_OPTS += -x lzo
endif
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_RT_NONE),y)
UBIFS_OPTS += -x none
endif

ROOTFS_UBIFS_DEPENDENCIES = host-mtd

define ROOTFS_UBIFS_CMD
	$(HOST_DIR)/usr/sbin/mkfs.ubifs -d $(TARGET_DIR) $(UBIFS_OPTS) -o $$@
endef

$(eval $(call ROOTFS_TARGET,ubifs))