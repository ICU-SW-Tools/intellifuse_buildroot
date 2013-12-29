################################################################################
#
# grub
#
################################################################################

GRUB_VERSION = 0.97
GRUB_SOURCE = grub_$(GRUB_VERSION).orig.tar.gz
GRUB_PATCH  = grub_$(GRUB_VERSION)-35.diff.gz
GRUB_SITE   = http://snapshot.debian.org/archive/debian/20080329T000000Z/pool/main/g/grub/

GRUB_LICENSE = GPLv2+
GRUB_LICENSE_FILES = COPYING

# Passing -O0 since the default -O2 passed by Buildroot generates
# non-working stage2.  Passing --build-id=none to the linker, because
# the ".note.gnu.build-id" ELF sections generated by default confuse
# objcopy when generating raw binaries. Passing -fno-stack-protector
# to avoid undefined references to __stack_chk_fail.
GRUB_CFLAGS = \
	-DSUPPORT_LOOPDEV \
	-O0 -Wl,--build-id=none \
	-fno-stack-protector

GRUB_CONFIG-y += $(if $(BR2_TARGET_GRUB_SPLASH),--enable-graphics,--disable-graphics)

GRUB_CONFIG-$(BR2_TARGET_GRUB_DISKLESS) += --enable-diskless
GRUB_CONFIG-$(BR2_TARGET_GRUB_3c595) += --enable-3c595
GRUB_CONFIG-$(BR2_TARGET_GRUB_3c90x) += --enable-3c90x
GRUB_CONFIG-$(BR2_TARGET_GRUB_davicom) += --enable-davicom
GRUB_CONFIG-$(BR2_TARGET_GRUB_e1000) += --enable-e1000
GRUB_CONFIG-$(BR2_TARGET_GRUB_eepro100) += --enable-eepro100
GRUB_CONFIG-$(BR2_TARGET_GRUB_epic100) += --enable-epic100
GRUB_CONFIG-$(BR2_TARGET_GRUB_forcedeth) += --enable-forcedeth
GRUB_CONFIG-$(BR2_TARGET_GRUB_natsemi) += --enable-natsemi
GRUB_CONFIG-$(BR2_TARGET_GRUB_ns83820) += --enable-ns83820
GRUB_CONFIG-$(BR2_TARGET_GRUB_ns8390) += --enable-ns8390
GRUB_CONFIG-$(BR2_TARGET_GRUB_pcnet32) += --enable-pcnet32
GRUB_CONFIG-$(BR2_TARGET_GRUB_pnic) += --enable-pnic
GRUB_CONFIG-$(BR2_TARGET_GRUB_rtl8139) += --enable-rtl8139
GRUB_CONFIG-$(BR2_TARGET_GRUB_r8169) += --enable-r8169
GRUB_CONFIG-$(BR2_TARGET_GRUB_sis900) += --enable-sis900
GRUB_CONFIG-$(BR2_TARGET_GRUB_tg3) += --enable-tg3
GRUB_CONFIG-$(BR2_TARGET_GRUB_tulip) += --enable-tulip
GRUB_CONFIG-$(BR2_TARGET_GRUB_tlan) += --enable-tlan
GRUB_CONFIG-$(BR2_TARGET_GRUB_undi) += --enable-undi
GRUB_CONFIG-$(BR2_TARGET_GRUB_via_rhine) += --enable-via-rhine
GRUB_CONFIG-$(BR2_TARGET_GRUB_w89c840) += --enable-w89c840

GRUB_CONFIG-y += $(if $(BR2_TARGET_GRUB_FS_EXT2),--enable-ext2fs,--disable-ext2fs)
GRUB_CONFIG-y += $(if $(BR2_TARGET_GRUB_FS_FAT),--enable-fat,--disable-fat)
GRUB_CONFIG-y += $(if $(BR2_TARGET_GRUB_FS_ISO9660),--enable-iso9660,--disable-iso9660)
GRUB_CONFIG-y += $(if $(BR2_TARGET_GRUB_FS_JFS),--enable-jfs,--disable-jfs)
GRUB_CONFIG-y += $(if $(BR2_TARGET_GRUB_FS_REISERFS),--enable-reiserfs,--disable-reiserfs)
GRUB_CONFIG-y += $(if $(BR2_TARGET_GRUB_FS_XFS),--enable-xfs,--disable-xfs)
GRUB_CONFIG-y += --disable-ffs --disable-ufs2 --disable-minix --disable-vstafs

GRUB_STAGE_1_5_TO_INSTALL += $(if $(BR2_TARGET_GRUB_FS_EXT2),e2fs)
GRUB_STAGE_1_5_TO_INSTALL += $(if $(BR2_TARGET_GRUB_FS_FAT),fat)
GRUB_STAGE_1_5_TO_INSTALL += $(if $(BR2_TARGET_GRUB_FS_ISO9660),iso9660)
GRUB_STAGE_1_5_TO_INSTALL += $(if $(BR2_TARGET_GRUB_FS_JFS),jfs)
GRUB_STAGE_1_5_TO_INSTALL += $(if $(BR2_TARGET_GRUB_FS_REISERFS),reiserfs)
GRUB_STAGE_1_5_TO_INSTALL += $(if $(BR2_TARGET_GRUB_FS_XFS),xfs)

define GRUB_DEBIAN_PATCHES
	# Apply the patches from the Debian patch
	(cd $(@D) ; for f in `cat debian/patches/00list | grep -v ^#` ; do \
		cat debian/patches/$$f | patch -g0 -p1 ; \
	done)
endef

GRUB_POST_PATCH_HOOKS += GRUB_DEBIAN_PATCHES

GRUB_CONF_ENV = \
	$(HOST_CONFIGURE_OPTS) \
	CFLAGS="$(HOST_CFLAGS) $(GRUB_CFLAGS) -m32"

GRUB_CONF_OPT = \
	--disable-auto-linux-mem-opt \
	$(GRUB_CONFIG-y)

ifeq ($(BR2_TARGET_GRUB_SPLASH),y)
define GRUB_INSTALL_SPLASH
	cp boot/grub/splash.xpm.gz $(TARGET_DIR)/boot/grub/
endef
else
define GRUB_INSTALL_SPLASH
	$(SED) '/^splashimage/d' $(TARGET_DIR)/boot/grub/menu.lst
endef
endif

# We're cheating here as we're installing the grub binary not in the
# target directory (where it is useless), but in the host
# directory. This grub binary can be used to install grub into the MBR
# of a disk or disk image.

define GRUB_INSTALL_TARGET_CMDS
	install -m 0755 -D $(@D)/grub/grub $(HOST_DIR)/sbin/grub
	mkdir -p $(TARGET_DIR)/boot/grub
	cp $(@D)/stage1/stage1 $(TARGET_DIR)/boot/grub
	for f in $(GRUB_STAGE_1_5_TO_INSTALL) ; do \
		cp $(@D)/stage2/$${f}_stage1_5 $(TARGET_DIR)/boot/grub ; \
	done
	cp $(@D)/stage2/stage2 $(TARGET_DIR)/boot/grub
	cp boot/grub/menu.lst $(TARGET_DIR)/boot/grub
	$(GRUB_INSTALL_SPLASH)
endef

$(eval $(autotools-package))
