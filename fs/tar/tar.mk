################################################################################
#
# tar to archive target filesystem
#
################################################################################

TAR_OPTS := $(call qstrip,$(BR2_TARGET_ROOTFS_TAR_OPTIONS))

define ROOTFS_TAR_CMD
	tar $(TAR_OPTS) -cf $@ --numeric-owner -C $(TARGET_DIR) .
endef

$(eval $(call ROOTFS_TARGET,tar))
