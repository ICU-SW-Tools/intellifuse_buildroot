#
# Macro that builds the needed Makefile target to create a root
# filesystem image.
#
# The following variable must be defined before calling this macro
#
#  ROOTFS_$(FSTYPE)_CMD, the command that generates the root
#  filesystem image. A single command is allowed. The filename of the
#  filesystem image that it must generate is $$@.
#
# The following variables can optionaly be defined
#
#  ROOTFS_$(FSTYPE)_DEPENDENCIES, the list of dependencies needed to
#  build the root filesystem (usually host tools)
#
#  ROOTFS_$(FSTYPE)_PRE_GEN_HOOKS, a list of hooks to call before
#  generating the filesystem image
#
#  ROOTFS_$(FSTYPE)_POST_GEN_HOOKS, a list of hooks to call after
#  generating the filesystem image
#
# In terms of configuration option, this macro assumes that the
# BR2_TARGET_ROOTFS_$(FSTYPE) config option allows to enable/disable
# the generation of a filesystem image of a particular type. If
# configura options BR2_TARGET_ROOTFS_$(FSTYPE)_GZIP,
# BR2_TARGET_ROOTFS_$(FSTYPE)_BZIP2 or
# BR2_TARGET_ROOTFS_$(FSTYPE)_LZMA exist and are enabled, then the
# macro will automatically generate a compressed filesystem image.

FAKEROOT_SCRIPT = $(BUILD_DIR)/_fakeroot.fs

define ROOTFS_TARGET_INTERNAL

$(BINARIES_DIR)/rootfs.$(1): $(ROOTFS_$(2)_DEPENDENCIES) host-fakeroot makedevs $(if $(BR2_TARGET_ROOTFS_$(2)_LZMA),host-lzma)
	@$(call MESSAGE,"Generating root filesystem image rootfs.$(1)")
	$(foreach hook,$(ROOTFS_$(2)_PRE_GEN_HOOKS),$(call $(hook))$(sep))
	rm -f $(FAKEROOT_SCRIPT)
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(FAKEROOT_SCRIPT)
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(FAKEROOT_SCRIPT)
ifneq ($(TARGET_DEVICE_TABLE),)
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" >> $(FAKEROOT_SCRIPT)
endif
	echo "$(ROOTFS_$(2)_CMD)" >> $(FAKEROOT_SCRIPT)
	chmod a+x $(FAKEROOT_SCRIPT)
	$(HOST_DIR)/usr/bin/fakeroot -- $(FAKEROOT_SCRIPT)
	-@rm -f $(FAKEROOT_SCRIPT)
	$(foreach hook,$(ROOTFS_$(2)_POST_GEN_HOOKS),$(call $(hook))$(sep))
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_GZIP),y)
	gzip -9 -c $$@ > $$@.gz
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_BZIP2),y)
	bzip2 -9 -c $$@ > $$@.bz2
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_LZMA),y)
	$(LZMA) -9 -c $$@ > $$@.lzma
endif

$(1)-root: $(BINARIES_DIR)/rootfs.$(1)

ifeq ($$(BR2_TARGET_ROOTFS_$(2)),y)
TARGETS += $(1)-root
endif
endef

define ROOTFS_TARGET
$(call ROOTFS_TARGET_INTERNAL,$(1),$(call UPPERCASE,$(1)))
endef
