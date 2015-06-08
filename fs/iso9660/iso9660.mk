################################################################################
#
# Build the iso96600 root filesystem image
#
################################################################################

#
# We need to handle three cases:
#
#  1. The ISO9660 filesystem will really be the real root filesystem
#     itself. This is when BR2_TARGET_ROOTFS_ISO9660_INITRD is
#     disabled.
#
#  2. The ISO9660 filesystem will be a filesystem with just a kernel
#     image, initrd and grub. This is when
#     BR2_TARGET_ROOTFS_ISO9660_INITRD is enabled, but
#     BR2_TARGET_ROOTFS_INITRAMFS is disabled.
#
#  3. The ISO9660 filesystem will be a filesystem with just a kernel
#     image and grub. This is like (2), except that the initrd is
#     built into the kernel image. This is when
#     BR2_TARGET_ROOTFS_INITRAMFS is enabled (regardless of the value
#     of BR2_TARGET_ROOTFS_ISO9660_INITRD).

ROOTFS_ISO9660_BOOT_MENU = $(call qstrip,$(BR2_TARGET_ROOTFS_ISO9660_BOOT_MENU))

ROOTFS_ISO9660_DEPENDENCIES = grub host-cdrkit host-fakeroot linux

ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
ROOTFS_ISO9660_USE_INITRD = YES
endif

ifeq ($(BR2_TARGET_ROOTFS_ISO9660_INITRD),y)
ROOTFS_ISO9660_USE_INITRD = YES
endif

ifeq ($(ROOTFS_ISO9660_USE_INITRD),YES)
ROOTFS_ISO9660_TARGET_DIR = $(BUILD_DIR)/rootfs-iso9660.tmp
define ROOTFS_ISO9660_CREATE_TEMPDIR
	$(RM) -rf $(ROOTFS_ISO9660_TARGET_DIR)
	mkdir -p $(ROOTFS_ISO9660_TARGET_DIR)
endef
else
ROOTFS_ISO9660_TARGET_DIR = $(TARGET_DIR)
endif

ROOTFS_ISO9660_BOOTLOADER_CONFIG_PATH = \
	$(ROOTFS_ISO9660_TARGET_DIR)/boot/grub/menu.lst
ROOTFS_ISO9660_BOOT_IMAGE = boot/grub/stage2_eltorito

define ROOTFS_ISO9660_PREPARATION
	$(INSTALL) -D -m 0644 $(GRUB_DIR)/stage2/stage2_eltorito \
		$(ROOTFS_ISO9660_TARGET_DIR)/boot/grub/stage2_eltorito
	$(INSTALL) -D -m 0644 $(ROOTFS_ISO9660_BOOT_MENU) \
		$(ROOTFS_ISO9660_BOOTLOADER_CONFIG_PATH)
	$(SED) "s%__KERNEL_PATH__%/boot/$(LINUX_IMAGE_NAME)%" \
		$(ROOTFS_ISO9660_BOOTLOADER_CONFIG_PATH)
endef

ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_PREPARATION

# Splash screen disabling
ifeq ($(BR2_TARGET_GRUB_SPLASH),)
define ROOTFS_ISO9660_DISABLE_SPLASHSCREEN
	$(SED) '/^splashimage/d' $(ROOTFS_ISO9660_BOOTLOADER_CONFIG_PATH)
endef
ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_DISABLE_SPLASHSCREEN
endif

define ROOTFS_ISO9660_DISABLE_EXTERNAL_INITRD
	$(SED) '/__INITRD_PATH__/d'  $(ROOTFS_ISO9660_BOOTLOADER_CONFIG_PATH)
endef

ifeq ($(ROOTFS_ISO9660_USE_INITRD),YES)

# Copy splashscreen to temporary filesystem
ifeq ($(BR2_TARGET_GRUB_SPLASH),y)
define ROOTFS_ISO9660_INSTALL_SPLASHSCREEN
	$(INSTALL) -D -m 0644 $(TARGET_DIR)/boot/grub/splash.xpm.gz \
		$(ROOTFS_ISO9660_TARGET_DIR)/boot/grub/splash.xpm.gz
endef
ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_INSTALL_SPLASHSCREEN
endif

# Copy the kernel to temporary filesystem
define ROOTFS_ISO9660_COPY_KERNEL
	$(INSTALL) -D -m 0644 $(LINUX_IMAGE_PATH) \
		$(ROOTFS_ISO9660_TARGET_DIR)/boot/$(LINUX_IMAGE_NAME)
endef

ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_COPY_KERNEL

# If initramfs is used, disable loading the initrd as the rootfs is
# already inside the kernel image. Otherwise, make sure a cpio is
# generated and use it as the initrd.
ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_DISABLE_EXTERNAL_INITRD
else
ROOTFS_ISO9660_DEPENDENCIES += rootfs-cpio
define ROOTFS_ISO9660_COPY_INITRD
	$(INSTALL) -D -m 0644 $(BINARIES_DIR)/rootfs.cpio$(ROOTFS_CPIO_COMPRESS_EXT) \
		$(ROOTFS_ISO9660_TARGET_DIR)/boot/initrd
	$(SED) "s%__INITRD_PATH__%/boot/initrd%" \
		$(ROOTFS_ISO9660_BOOTLOADER_CONFIG_PATH)
endef
ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_COPY_INITRD
endif

else # ROOTFS_ISO9660_USE_INITRD

ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_DISABLE_EXTERNAL_INITRD

endif # ROOTFS_ISO9660_USE_INITRD


define ROOTFS_ISO9660_CMD
	$(HOST_DIR)/usr/bin/genisoimage -J -R -b $(ROOTFS_ISO9660_BOOT_IMAGE) \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-o $@ $(ROOTFS_ISO9660_TARGET_DIR)
endef

$(eval $(call ROOTFS_TARGET,iso9660))
