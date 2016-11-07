################################################################################
#
# toolchain-external
#
################################################################################

TOOLCHAIN_EXTERNAL_ADD_TOOLCHAIN_DEPENDENCY = NO

# musl does not provide an implementation for sys/queue.h or sys/cdefs.h.
# So, add the musl-compat-headers package that will install those files,
# into the staging directory:
#   sys/queue.h:  header from NetBSD
#   sys/cdefs.h:  minimalist header bundled in Buildroot
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
TOOLCHAIN_EXTERNAL_DEPENDENCIES += musl-compat-headers
endif

# All the definition that are common between the toolchain-external
# generic package and the toolchain-external-package infrastructure
# can be found in pkg-toolchain-external.mk

# Legacy toolchains that don't use the toolchain-external-package infrastructure
# yet. We can recognise that because no provider is set.
ifeq ($(call qstrip,$(BR2_PACKAGE_PROVIDES_TOOLCHAIN_EXTERNAL)),)

# Now we are the provider. However, we can't set it to ourselves or we'll get a
# circular dependency. Let's set it to a target that we always depend on
# instead.
BR2_PACKAGE_PROVIDES_TOOLCHAIN_EXTERNAL = skeleton

TOOLCHAIN_EXTERNAL_INSTALL_STAGING = YES

# In fact, we don't need to download the toolchain, since it is already
# available on the system, so force the site and source to be empty so
# that nothing will be downloaded/extracted.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_PREINSTALLED),y)
TOOLCHAIN_EXTERNAL_SITE =
TOOLCHAIN_EXTERNAL_SOURCE =
endif

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_ARAGO_ARMV7A),y)
TOOLCHAIN_EXTERNAL_SITE = http://software-dl.ti.com/sdoemb/sdoemb_public_sw/arago_toolchain/2011_09/exports
TOOLCHAIN_EXTERNAL_SOURCE = arago-2011.09-armv7a-linux-gnueabi-sdk.tar.bz2
TOOLCHAIN_EXTERNAL_ACTUAL_SOURCE_TARBALL = arago-toolchain-2011.09-sources.tar.bz2
define TOOLCHAIN_EXTERNAL_FIXUP_CMDS
	mv $(@D)/arago-2011.09/armv7a/* $(@D)/
	rm -rf $(@D)/arago-2011.09/
endef
TOOLCHAIN_EXTERNAL_POST_EXTRACT_HOOKS += TOOLCHAIN_EXTERNAL_FIXUP_CMDS
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_ARAGO_ARMV5TE),y)
TOOLCHAIN_EXTERNAL_SITE = http://software-dl.ti.com/sdoemb/sdoemb_public_sw/arago_toolchain/2011_09/exports
TOOLCHAIN_EXTERNAL_SOURCE = arago-2011.09-armv5te-linux-gnueabi-sdk.tar.bz2
TOOLCHAIN_EXTERNAL_ACTUAL_SOURCE_TARBALL = arago-toolchain-2011.09-sources.tar.bz2
define TOOLCHAIN_EXTERNAL_FIXUP_CMDS
	mv $(@D)/arago-2011.09/armv5te/* $(@D)/
	rm -rf $(@D)/arago-2011.09/
endef
TOOLCHAIN_EXTERNAL_POST_EXTRACT_HOOKS += TOOLCHAIN_EXTERNAL_FIXUP_CMDS
endif

# Some toolchain vendors have a regular file naming pattern.
# For them, mass-define _ACTUAL_SOURCE_TARBALL based _SITE.
ifneq ($(findstring sourcery.mentor.com/public/gnu_toolchain,$(TOOLCHAIN_EXTERNAL_SITE)),)
TOOLCHAIN_EXTERNAL_ACTUAL_SOURCE_TARBALL ?= \
	$(subst -i686-pc-linux-gnu.tar.bz2,.src.tar.bz2,$(subst -i686-pc-linux-gnu-i386-linux.tar.bz2,-i686-pc-linux-gnu.src.tar.bz2,$(TOOLCHAIN_EXTERNAL_SOURCE)))
endif

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD),y)
TOOLCHAIN_EXTERNAL_EXCLUDES = usr/lib/locale/*

TOOLCHAIN_EXTERNAL_POST_EXTRACT_HOOKS += \
	TOOLCHAIN_EXTERNAL_MOVE
endif

# Checks for an already installed toolchain: check the toolchain
# location, check that it is usable, and then verify that it
# matches the configuration provided in Buildroot: ABI, C++ support,
# kernel headers version, type of C library and all C library features.
define TOOLCHAIN_EXTERNAL_CONFIGURE_CMDS
	$(Q)$(call check_cross_compiler_exists,$(TOOLCHAIN_EXTERNAL_CC))
	$(Q)$(call check_unusable_toolchain,$(TOOLCHAIN_EXTERNAL_CC))
	$(Q)SYSROOT_DIR="$(call toolchain_find_sysroot,$(TOOLCHAIN_EXTERNAL_CC))" ; \
	$(call check_kernel_headers_version,\
		$(call toolchain_find_sysroot,$(TOOLCHAIN_EXTERNAL_CC)),\
		$(call qstrip,$(BR2_TOOLCHAIN_HEADERS_AT_LEAST))); \
	$(call check_gcc_version,$(TOOLCHAIN_EXTERNAL_CC),\
		$(call qstrip,$(BR2_TOOLCHAIN_GCC_AT_LEAST))); \
	if test "$(BR2_arm)" = "y" ; then \
		$(call check_arm_abi,\
			"$(TOOLCHAIN_EXTERNAL_CC) $(TOOLCHAIN_EXTERNAL_CFLAGS)",\
			$(TOOLCHAIN_EXTERNAL_READELF)) ; \
	fi ; \
	if test "$(BR2_INSTALL_LIBSTDCPP)" = "y" ; then \
		$(call check_cplusplus,$(TOOLCHAIN_EXTERNAL_CXX)) ; \
	fi ; \
	if test "$(BR2_TOOLCHAIN_HAS_FORTRAN)" = "y" ; then \
		$(call check_fortran,$(TOOLCHAIN_EXTERNAL_FC)) ; \
	fi ; \
	if test "$(BR2_TOOLCHAIN_EXTERNAL_UCLIBC)" = "y" ; then \
		$(call check_uclibc,$${SYSROOT_DIR}) ; \
	elif test "$(BR2_TOOLCHAIN_EXTERNAL_MUSL)" = "y" ; then \
		$(call check_musl,$${SYSROOT_DIR}) ; \
	else \
		$(call check_glibc,$${SYSROOT_DIR}) ; \
	fi
	$(Q)$(call check_toolchain_ssp,$(TOOLCHAIN_EXTERNAL_CC))
endef

TOOLCHAIN_EXTERNAL_BUILD_CMDS = $(TOOLCHAIN_WRAPPER_BUILD)

define TOOLCHAIN_EXTERNAL_INSTALL_STAGING_CMDS
	$(TOOLCHAIN_WRAPPER_INSTALL)
	$(TOOLCHAIN_EXTERNAL_CREATE_STAGING_LIB_SYMLINK)
	$(TOOLCHAIN_EXTERNAL_INSTALL_SYSROOT_LIBS)
	$(TOOLCHAIN_EXTERNAL_INSTALL_SYSROOT_LIBS_BFIN_FDPIC)
	$(TOOLCHAIN_EXTERNAL_INSTALL_WRAPPER)
	$(TOOLCHAIN_EXTERNAL_INSTALL_GDBINIT)
endef

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_MUSL),y)
TOOLCHAIN_EXTERNAL_POST_INSTALL_STAGING_HOOKS += TOOLCHAIN_EXTERNAL_MUSL_LD_LINK
endif

# Even though we're installing things in both the staging, the host
# and the target directory, we do everything within the
# install-staging step, arbitrarily.
define TOOLCHAIN_EXTERNAL_INSTALL_TARGET_CMDS
	$(TOOLCHAIN_EXTERNAL_CREATE_TARGET_LIB_SYMLINK)
	$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_LIBS)
	$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_GDBSERVER)
	$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_BFIN_FDPIC)
	$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_BFIN_FLAT)
	$(TOOLCHAIN_EXTERNAL_FIXUP_UCLIBCNG_LDSO)
endef

endif # BR2_PACKAGE_PROVIDES_TOOLCHAIN_EXTERNAL


# Since a virtual package is just a generic package, we can still
# define commands for the legacy toolchains.
$(eval $(virtual-package))

# Ensure the external-toolchain package has a prefix defined.
# This comes after the virtual-package definition, which checks the provider.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
ifeq ($(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)),)
$(error No prefix selected for external toolchain package $(BR2_PACKAGE_PROVIDES_TOOLCHAIN_EXTERNAL). Configuration error)
endif
endif

include toolchain/toolchain-external/*/*.mk
