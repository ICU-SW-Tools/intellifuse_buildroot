################################################################################
# External toolchain package infrastructure
#
# This package infrastructure implements the support for external
# toolchains, i.e toolchains that are available pre-built, ready to
# use. Such toolchain may either be readily available on the Web
# (Linaro, Sourcery CodeBench, from processor vendors) or may be built
# with tools like Crosstool-NG or Buildroot itself. So far, we have
# tested this with:
#
#  * Toolchains generated by Crosstool-NG
#  * Toolchains generated by Buildroot
#  * Toolchains provided by Linaro for the ARM and AArch64
#    architectures
#  * Sourcery CodeBench toolchains (from Mentor Graphics) for the ARM,
#    MIPS, PowerPC, x86, x86_64 and NIOS 2 architectures. For the MIPS
#    toolchain, the -muclibc variant isn't supported yet, only the
#    default glibc-based variant is.
#  * Analog Devices toolchains for the Blackfin architecture
#  * Xilinx toolchains for the Microblaze architecture
#  * Synopsys DesignWare toolchains for ARC cores
#
# The basic principle is the following
#
#  1. If the toolchain is not pre-installed, download and extract it
#  in $(TOOLCHAIN_EXTERNAL_INSTALL_DIR). Otherwise,
#  $(TOOLCHAIN_EXTERNAL_INSTALL_DIR) points to were the toolchain has
#  already been installed by the user.
#
#  2. For all external toolchains, perform some checks on the
#  conformity between the toolchain configuration described in the
#  Buildroot menuconfig system, and the real configuration of the
#  external toolchain. This is for example important to make sure that
#  the Buildroot configuration system knows whether the toolchain
#  supports RPC, IPv6, locales, large files, etc. Unfortunately, these
#  things cannot be detected automatically, since the value of these
#  options (such as BR2_TOOLCHAIN_HAS_NATIVE_RPC) are needed at
#  configuration time because these options are used as dependencies
#  for other options. And at configuration time, we are not able to
#  retrieve the external toolchain configuration.
#
#  3. Copy the libraries needed at runtime to the target directory,
#  $(TARGET_DIR). Obviously, things such as the C library, the dynamic
#  loader and a few other utility libraries are needed if dynamic
#  applications are to be executed on the target system.
#
#  4. Copy the libraries and headers to the staging directory. This
#  will allow all further calls to gcc to be made using --sysroot
#  $(STAGING_DIR), which greatly simplifies the compilation of the
#  packages when using external toolchains. So in the end, only the
#  cross-compiler binaries remains external, all libraries and headers
#  are imported into the Buildroot tree.
#
#  5. Build a toolchain wrapper which executes the external toolchain
#  with a number of arguments (sysroot/march/mtune/..) hardcoded,
#  so we're sure the correct configuration is always used and the
#  toolchain behaves similar to an internal toolchain.
#  This toolchain wrapper and symlinks are installed into
#  $(HOST_DIR)/usr/bin like for the internal toolchains, and the rest
#  of Buildroot is handled identical for the 2 toolchain types.
################################################################################

#
# Definitions of where the toolchain can be found
#

TOOLCHAIN_EXTERNAL_PREFIX = $(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_PREFIX))
TOOLCHAIN_EXTERNAL_DOWNLOAD_INSTALL_DIR = $(HOST_DIR)/opt/ext-toolchain

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD),y)
TOOLCHAIN_EXTERNAL_INSTALL_DIR = $(TOOLCHAIN_EXTERNAL_DOWNLOAD_INSTALL_DIR)
else
TOOLCHAIN_EXTERNAL_INSTALL_DIR = $(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_PATH))
endif

ifeq ($(TOOLCHAIN_EXTERNAL_INSTALL_DIR),)
ifneq ($(TOOLCHAIN_EXTERNAL_PREFIX),)
# if no path set, figure it out from path
TOOLCHAIN_EXTERNAL_BIN := $(shell dirname $(shell which $(TOOLCHAIN_EXTERNAL_PREFIX)-gcc))
endif
else
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX),y)
TOOLCHAIN_EXTERNAL_BIN := $(TOOLCHAIN_EXTERNAL_INSTALL_DIR)/$(TOOLCHAIN_EXTERNAL_PREFIX)/bin
else
TOOLCHAIN_EXTERNAL_BIN := $(TOOLCHAIN_EXTERNAL_INSTALL_DIR)/bin
endif
endif

# If this is a buildroot toolchain, it already has a wrapper which we want to
# bypass. Since this is only evaluated after it has been extracted, we can use
# $(wildcard ...) here.
TOOLCHAIN_EXTERNAL_SUFFIX = \
	$(if $(wildcard $(TOOLCHAIN_EXTERNAL_BIN)/*.br_real),.br_real)

TOOLCHAIN_EXTERNAL_CROSS = $(TOOLCHAIN_EXTERNAL_BIN)/$(TOOLCHAIN_EXTERNAL_PREFIX)-
TOOLCHAIN_EXTERNAL_CC = $(TOOLCHAIN_EXTERNAL_CROSS)gcc$(TOOLCHAIN_EXTERNAL_SUFFIX)
TOOLCHAIN_EXTERNAL_CXX = $(TOOLCHAIN_EXTERNAL_CROSS)g++$(TOOLCHAIN_EXTERNAL_SUFFIX)
TOOLCHAIN_EXTERNAL_FC = $(TOOLCHAIN_EXTERNAL_CROSS)gfortran$(TOOLCHAIN_EXTERNAL_SUFFIX)
TOOLCHAIN_EXTERNAL_READELF = $(TOOLCHAIN_EXTERNAL_CROSS)readelf$(TOOLCHAIN_EXTERNAL_SUFFIX)

# Normal handling of downloaded toolchain tarball extraction.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD),y)
# As a regular package, the toolchain gets extracted in $(@D), but
# since it's actually a fairly special package, we need it to be moved
# into TOOLCHAIN_EXTERNAL_DOWNLOAD_INSTALL_DIR.
define TOOLCHAIN_EXTERNAL_MOVE
	rm -rf $(TOOLCHAIN_EXTERNAL_DOWNLOAD_INSTALL_DIR)
	mkdir -p $(TOOLCHAIN_EXTERNAL_DOWNLOAD_INSTALL_DIR)
	mv $(@D)/* $(TOOLCHAIN_EXTERNAL_DOWNLOAD_INSTALL_DIR)/
endef
endif

#
# Definitions of the list of libraries that should be copied to the target.
#
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_GLIBC)$(BR2_TOOLCHAIN_EXTERNAL_UCLIBC),y)
TOOLCHAIN_EXTERNAL_LIBS += libatomic.so.* libc.so.* libcrypt.so.* libdl.so.* libgcc_s.so.* libm.so.* libnsl.so.* libresolv.so.* librt.so.* libutil.so.*
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_GLIBC)$(BR2_ARM_EABIHF),yy)
TOOLCHAIN_EXTERNAL_LIBS += ld-linux-armhf.so.*
else
TOOLCHAIN_EXTERNAL_LIBS += ld*.so.*
endif
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
TOOLCHAIN_EXTERNAL_LIBS += libpthread.so.*
ifneq ($(BR2_PACKAGE_GDB)$(BR2_TOOLCHAIN_EXTERNAL_GDB_SERVER_COPY),)
TOOLCHAIN_EXTERNAL_LIBS += libthread_db.so.*
endif # gdbserver
endif # ! no threads
endif

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_GLIBC),y)
TOOLCHAIN_EXTERNAL_LIBS += libnss_files.so.* libnss_dns.so.* libmvec.so.*
endif

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_MUSL),y)
TOOLCHAIN_EXTERNAL_LIBS += libc.so libgcc_s.so.*
endif

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
TOOLCHAIN_EXTERNAL_LIBS += libstdc++.so.*
endif

ifeq ($(BR2_TOOLCHAIN_HAS_FORTRAN),y)
TOOLCHAIN_EXTERNAL_LIBS += libgfortran.so.*
# fortran needs quadmath on x86 and x86_64
ifeq ($(BR2_TOOLCHAIN_HAS_LIBQUADMATH),y)
TOOLCHAIN_EXTERNAL_LIBS += libquadmath.so*
endif
endif

TOOLCHAIN_EXTERNAL_LIBS += $(call qstrip,$(BR2_TOOLCHAIN_EXTRA_EXTERNAL_LIBS))


#
# Definition of the CFLAGS to use with the external toolchain, as well as the
# common toolchain wrapper build arguments
#
ifeq ($(call qstrip,$(BR2_GCC_TARGET_CPU_REVISION)),)
CC_TARGET_CPU_ := $(call qstrip,$(BR2_GCC_TARGET_CPU))
else
CC_TARGET_CPU_ := $(call qstrip,$(BR2_GCC_TARGET_CPU)-$(BR2_GCC_TARGET_CPU_REVISION))
endif
CC_TARGET_ARCH_ := $(call qstrip,$(BR2_GCC_TARGET_ARCH))
CC_TARGET_ABI_ := $(call qstrip,$(BR2_GCC_TARGET_ABI))
CC_TARGET_FPU_ := $(call qstrip,$(BR2_GCC_TARGET_FPU))
CC_TARGET_FLOAT_ABI_ := $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
CC_TARGET_MODE_ := $(call qstrip,$(BR2_GCC_TARGET_MODE))

# march/mtune/floating point mode needs to be passed to the external toolchain
# to select the right multilib variant
ifeq ($(BR2_x86_64),y)
TOOLCHAIN_EXTERNAL_CFLAGS += -m64
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_64
endif
ifneq ($(CC_TARGET_ARCH_),)
TOOLCHAIN_EXTERNAL_CFLAGS += -march=$(CC_TARGET_ARCH_)
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_ARCH='"$(CC_TARGET_ARCH_)"'
endif
ifneq ($(CC_TARGET_CPU_),)
TOOLCHAIN_EXTERNAL_CFLAGS += -mcpu=$(CC_TARGET_CPU_)
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_CPU='"$(CC_TARGET_CPU_)"'
endif
ifneq ($(CC_TARGET_ABI_),)
TOOLCHAIN_EXTERNAL_CFLAGS += -mabi=$(CC_TARGET_ABI_)
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_ABI='"$(CC_TARGET_ABI_)"'
endif
ifneq ($(CC_TARGET_FPU_),)
TOOLCHAIN_EXTERNAL_CFLAGS += -mfpu=$(CC_TARGET_FPU_)
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_FPU='"$(CC_TARGET_FPU_)"'
endif
ifneq ($(CC_TARGET_FLOAT_ABI_),)
TOOLCHAIN_EXTERNAL_CFLAGS += -mfloat-abi=$(CC_TARGET_FLOAT_ABI_)
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_FLOAT_ABI='"$(CC_TARGET_FLOAT_ABI_)"'
endif
ifneq ($(CC_TARGET_MODE_),)
TOOLCHAIN_EXTERNAL_CFLAGS += -m$(CC_TARGET_MODE_)
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_MODE='"$(CC_TARGET_MODE_)"'
endif
ifeq ($(BR2_BINFMT_FLAT),y)
TOOLCHAIN_EXTERNAL_CFLAGS += -Wl,-elf2flt
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_BINFMT_FLAT
endif
ifeq ($(BR2_mipsel)$(BR2_mips64el),y)
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_MIPS_TARGET_LITTLE_ENDIAN
TOOLCHAIN_EXTERNAL_CFLAGS += -EL
endif
ifeq ($(BR2_mips)$(BR2_mips64),y)
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_MIPS_TARGET_BIG_ENDIAN
TOOLCHAIN_EXTERNAL_CFLAGS += -EB
endif
ifeq ($(BR2_arceb),y)
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_ARC_TARGET_BIG_ENDIAN
TOOLCHAIN_EXTERNAL_CFLAGS += -EB
endif

TOOLCHAIN_EXTERNAL_CFLAGS += $(call qstrip,$(BR2_TARGET_OPTIMIZATION))

ifeq ($(BR2_SOFT_FLOAT),y)
TOOLCHAIN_EXTERNAL_CFLAGS += -msoft-float
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += -DBR_SOFTFLOAT=1
endif

TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += \
	-DBR_CROSS_PATH_SUFFIX='"$(TOOLCHAIN_EXTERNAL_SUFFIX)"'

ifeq ($(filter $(HOST_DIR)/%,$(TOOLCHAIN_EXTERNAL_BIN)),)
# TOOLCHAIN_EXTERNAL_BIN points outside HOST_DIR => absolute path
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += \
	-DBR_CROSS_PATH_ABS='"$(TOOLCHAIN_EXTERNAL_BIN)"'
else
# TOOLCHAIN_EXTERNAL_BIN points inside HOST_DIR => relative path
TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS += \
	-DBR_CROSS_PATH_REL='"$(TOOLCHAIN_EXTERNAL_BIN:$(HOST_DIR)/%=%)"'
endif


#
# The following functions creates the symbolic links needed to get the
# cross-compilation tools visible in $(HOST_DIR)/usr/bin. Some of
# links are done directly to the corresponding tool in the external
# toolchain installation directory, while some other links are done to
# the toolchain wrapper (preprocessor, C, C++ and Fortran compiler)
#
# We skip gdb symlink when we are building our own gdb to prevent two
# gdb's in $(HOST_DIR)/usr/bin.
#
# The LTO support in gcc creates wrappers for ar, ranlib and nm which load
# the lto plugin. These wrappers are called *-gcc-ar, *-gcc-ranlib, and
# *-gcc-nm and should be used instead of the real programs when -flto is
# used. However, we should not add the toolchain wrapper for them, and they
# match the *cc-* pattern. Therefore, an additional case is added for *-ar,
# *-ranlib and *-nm.
define TOOLCHAIN_EXTERNAL_INSTALL_WRAPPER
	$(Q)cd $(HOST_DIR)/usr/bin; \
	for i in $(TOOLCHAIN_EXTERNAL_CROSS)*; do \
		base=$${i##*/}; \
		case "$$base" in \
		*-ar|*-ranlib|*-nm) \
			ln -sf $$(echo $$i | sed 's%^$(HOST_DIR)%../..%') .; \
			;; \
		*cc|*cc-*|*++|*++-*|*cpp|*-gfortran) \
			ln -sf toolchain-wrapper $$base; \
			;; \
		*gdb|*gdbtui) \
			if test "$(BR2_PACKAGE_HOST_GDB)" != "y"; then \
				ln -sf $$(echo $$i | sed 's%^$(HOST_DIR)%../..%') .; \
			fi \
			;; \
		*) \
			ln -sf $$(echo $$i | sed 's%^$(HOST_DIR)%../..%') .; \
			;; \
		esac; \
	done
endef


# Various utility functions used by the external toolchain package
# infrastructure. Those functions are mainly responsible for:
#
#   - installation the toolchain libraries to $(TARGET_DIR)
#   - copying the toolchain sysroot to $(STAGING_DIR)
#   - installing a gdbinit file
#
# Details about sysroot directory selection.
#
# To find the sysroot directory, we use the trick of looking for the
# 'libc.a' file with the -print-file-name gcc option, and then
# mangling the path to find the base directory of the sysroot.
#
# Note that we do not use the -print-sysroot option, because it is
# only available since gcc 4.4.x, and we only recently dropped support
# for 4.2.x and 4.3.x.
#
# When doing this, we don't pass any option to gcc that could select a
# multilib variant (such as -march) as we want the "main" sysroot,
# which contains all variants of the C library in the case of multilib
# toolchains. We use the TARGET_CC_NO_SYSROOT variable, which is the
# path of the cross-compiler, without the --sysroot=$(STAGING_DIR),
# since what we want to find is the location of the original toolchain
# sysroot. This "main" sysroot directory is stored in SYSROOT_DIR.
#
# Then, multilib toolchains are a little bit more complicated, since
# they in fact have multiple sysroots, one for each variant supported
# by the toolchain. So we need to find the particular sysroot we're
# interested in.
#
# To do so, we ask the compiler where its sysroot is by passing all
# flags (including -march and al.), except the --sysroot flag since we
# want to the compiler to tell us where its original sysroot
# is. ARCH_SUBDIR will contain the subdirectory, in the main
# SYSROOT_DIR, that corresponds to the selected architecture
# variant. ARCH_SYSROOT_DIR will contain the full path to this
# location.
#
# One might wonder why we don't just bother with ARCH_SYSROOT_DIR. The
# fact is that in multilib toolchains, the header files are often only
# present in the main sysroot, and only the libraries are available in
# each variant-specific sysroot directory.


# toolchain_find_sysroot returns the sysroot location for the given
# compiler + flags. We need to handle cases where libc.a is in:
#
#  - lib/
#  - usr/lib/
#  - lib32/
#  - lib64/
#  - lib32-fp/ (Cavium toolchain)
#  - lib64-fp/ (Cavium toolchain)
#  - usr/lib/<tuple>/ (Linaro toolchain)
#
# And variations on these.
define toolchain_find_sysroot
$$(printf $(call toolchain_find_libc_a,$(1)) | sed -r -e 's:(usr/)?lib(32|64)?([^/]*)?/([^/]*/)?libc\.a::')
endef

# Returns the lib subdirectory for the given compiler + flags (i.e
# typically lib32 or lib64 for some toolchains)
define toolchain_find_libdir
$$(printf $(call toolchain_find_libc_a,$(1)) | sed -r -e 's:.*/(usr/)?(lib(32|64)?([^/]*)?)/([^/]*/)?libc.a:\2:')
endef

# Returns the location of the libc.a file for the given compiler + flags
define toolchain_find_libc_a
$$(readlink -f $$(LANG=C $(1) -print-file-name=libc.a))
endef

# Integration of the toolchain into Buildroot: find the main sysroot
# and the variant-specific sysroot, then copy the needed libraries to
# the $(TARGET_DIR) and copy the whole sysroot (libraries and headers)
# to $(STAGING_DIR).
#
# Variables are defined as follows:
#
#  LIBC_A_LOCATION:     location of the libc.a file in the default
#                       multilib variant (allows to find the main
#                       sysroot directory)
#                       Ex: /x-tools/mips-2011.03/mips-linux-gnu/libc/usr/lib/libc.a
#
#  SYSROOT_DIR:         the main sysroot directory, deduced from
#                       LIBC_A_LOCATION by removing the
#                       usr/lib[32|64]/libc.a part of the path.
#                       Ex: /x-tools/mips-2011.03/mips-linux-gnu/libc/
#
# ARCH_LIBC_A_LOCATION: location of the libc.a file in the selected
#                       multilib variant (taking into account the
#                       CFLAGS). Allows to find the sysroot of the
#                       selected multilib variant.
#                       Ex: /x-tools/mips-2011.03/mips-linux-gnu/libc/mips16/soft-float/el/usr/lib/libc.a
#
# ARCH_SYSROOT_DIR:     the sysroot of the selected multilib variant,
#                       deduced from ARCH_LIBC_A_LOCATION by removing
#                       usr/lib[32|64]/libc.a at the end of the path.
#                       Ex: /x-tools/mips-2011.03/mips-linux-gnu/libc/mips16/soft-float/el/
#
# ARCH_LIB_DIR:         'lib', 'lib32' or 'lib64' depending on where libraries
#                       are stored. Deduced from ARCH_LIBC_A_LOCATION by
#                       looking at usr/lib??/libc.a.
#                       Ex: lib
#
# ARCH_SUBDIR:          the relative location of the sysroot of the selected
#                       multilib variant compared to the main sysroot.
#			Ex: mips16/soft-float/el
#
# SUPPORT_LIB_DIR:      some toolchains, such as recent Linaro toolchains,
#                       store GCC support libraries (libstdc++,
#                       libgcc_s, etc.) outside of the sysroot. In
#                       this case, SUPPORT_LIB_DIR is set to a
#                       non-empty value, and points to the directory
#                       where these support libraries are
#                       available. Those libraries will be copied to
#                       our sysroot, and the directory will also be
#                       considered when searching libraries for copy
#                       to the target filesystem.
#
# Please be very careful to check the major toolchain sources:
# Buildroot, Crosstool-NG, CodeSourcery and Linaro
# before doing any modification on the below logic.

ifeq ($(BR2_STATIC_LIBS),)
define TOOLCHAIN_EXTERNAL_INSTALL_TARGET_LIBS
	$(Q)$(call MESSAGE,"Copying external toolchain libraries to target...")
	$(Q)for libs in $(TOOLCHAIN_EXTERNAL_LIBS); do \
		$(call copy_toolchain_lib_root,$$libs); \
	done
endef
endif

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_GDB_SERVER_COPY),y)
define TOOLCHAIN_EXTERNAL_INSTALL_TARGET_GDBSERVER
	$(Q)$(call MESSAGE,"Copying gdbserver")
	$(Q)ARCH_SYSROOT_DIR="$(call toolchain_find_sysroot,$(TOOLCHAIN_EXTERNAL_CC) $(TOOLCHAIN_EXTERNAL_CFLAGS))" ; \
	ARCH_LIB_DIR="$(call toolchain_find_libdir,$(TOOLCHAIN_EXTERNAL_CC) $(TOOLCHAIN_EXTERNAL_CFLAGS))" ; \
	gdbserver_found=0 ; \
	for d in $${ARCH_SYSROOT_DIR}/usr \
		 $${ARCH_SYSROOT_DIR}/../debug-root/usr \
		 $${ARCH_SYSROOT_DIR}/usr/$${ARCH_LIB_DIR} \
		 $(TOOLCHAIN_EXTERNAL_INSTALL_DIR); do \
		if test -f $${d}/bin/gdbserver ; then \
			install -m 0755 -D $${d}/bin/gdbserver $(TARGET_DIR)/usr/bin/gdbserver ; \
			gdbserver_found=1 ; \
			break ; \
		fi ; \
	done ; \
	if [ $${gdbserver_found} -eq 0 ] ; then \
		echo "Could not find gdbserver in external toolchain" ; \
		exit 1 ; \
	fi
endef
endif

define TOOLCHAIN_EXTERNAL_INSTALL_SYSROOT_LIBS
	$(Q)SYSROOT_DIR="$(call toolchain_find_sysroot,$(TOOLCHAIN_EXTERNAL_CC))" ; \
	ARCH_SYSROOT_DIR="$(call toolchain_find_sysroot,$(TOOLCHAIN_EXTERNAL_CC) $(TOOLCHAIN_EXTERNAL_CFLAGS))" ; \
	ARCH_LIB_DIR="$(call toolchain_find_libdir,$(TOOLCHAIN_EXTERNAL_CC) $(TOOLCHAIN_EXTERNAL_CFLAGS))" ; \
	SUPPORT_LIB_DIR="" ; \
	if test `find $${ARCH_SYSROOT_DIR} -name 'libstdc++.a' | wc -l` -eq 0 ; then \
		LIBSTDCPP_A_LOCATION=$$(LANG=C $(TOOLCHAIN_EXTERNAL_CC) $(TOOLCHAIN_EXTERNAL_CFLAGS) -print-file-name=libstdc++.a) ; \
		if [ -e "$${LIBSTDCPP_A_LOCATION}" ]; then \
			SUPPORT_LIB_DIR=`readlink -f $${LIBSTDCPP_A_LOCATION} | sed -r -e 's:libstdc\+\+\.a::'` ; \
		fi ; \
	fi ; \
	if [ "$${SYSROOT_DIR}" == "$${ARCH_SYSROOT_DIR}" ] ; then \
		ARCH_SUBDIR="" ; \
	elif [ "`dirname $${ARCH_SYSROOT_DIR}`" = "`dirname $${SYSROOT_DIR}`" ] ; then \
		SYSROOT_DIR_DIRNAME=`dirname $${SYSROOT_DIR}`/ ; \
		ARCH_SUBDIR=`echo $${ARCH_SYSROOT_DIR} | sed -r -e "s:^$${SYSROOT_DIR_DIRNAME}(.*)/$$:\1:"` ; \
	else \
		ARCH_SUBDIR=`echo $${ARCH_SYSROOT_DIR} | sed -r -e "s:^$${SYSROOT_DIR}(.*)/$$:\1:"` ; \
	fi ; \
	$(call MESSAGE,"Copying external toolchain sysroot to staging...") ; \
	$(call copy_toolchain_sysroot,$${SYSROOT_DIR},$${ARCH_SYSROOT_DIR},$${ARCH_SUBDIR},$${ARCH_LIB_DIR},$${SUPPORT_LIB_DIR})
endef

# Create a symlink from (usr/)$(ARCH_LIB_DIR) to lib.
# Note: the skeleton package additionally creates lib32->lib or lib64->lib
# (as appropriate)
#
# $1: destination directory (TARGET_DIR / STAGING_DIR)
create_lib_symlinks = \
       $(Q)DESTDIR="$(strip $1)" ; \
       ARCH_LIB_DIR="$(call toolchain_find_libdir,$(TOOLCHAIN_EXTERNAL_CC) $(TOOLCHAIN_EXTERNAL_CFLAGS))" ; \
       if [ ! -e "$${DESTDIR}/$${ARCH_LIB_DIR}" -a ! -e "$${DESTDIR}/usr/$${ARCH_LIB_DIR}" ]; then \
               ln -snf lib "$${DESTDIR}/$${ARCH_LIB_DIR}" ; \
               ln -snf lib "$${DESTDIR}/usr/$${ARCH_LIB_DIR}" ; \
       fi

define TOOLCHAIN_EXTERNAL_CREATE_STAGING_LIB_SYMLINK
       $(call create_lib_symlinks,$(STAGING_DIR))
endef

define TOOLCHAIN_EXTERNAL_CREATE_TARGET_LIB_SYMLINK
       $(call create_lib_symlinks,$(TARGET_DIR))
endef

#
# Generate gdbinit file for use with Buildroot
#
define TOOLCHAIN_EXTERNAL_INSTALL_GDBINIT
	$(Q)if test -f $(TARGET_CROSS)gdb ; then \
		$(call MESSAGE,"Installing gdbinit"); \
		$(gen_gdbinit_file); \
	fi
endef

# Various utility functions used by the external toolchain based on musl.

# With the musl C library, the libc.so library directly plays the role
# of the dynamic library loader. We just need to create a symbolic
# link to libc.so with the appropriate name.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_MUSL),y)
ifeq ($(BR2_i386),y)
MUSL_ARCH = i386
else ifeq ($(BR2_ARM_EABIHF),y)
MUSL_ARCH = armhf
else ifeq ($(BR2_mipsel):$(BR2_SOFT_FLOAT),y:y)
MUSL_ARCH = mipsel-sf
else ifeq ($(BR2_sh),y)
MUSL_ARCH = sh
else
MUSL_ARCH = $(ARCH)
endif
define TOOLCHAIN_EXTERNAL_MUSL_LD_LINK
	ln -sf libc.so $(TARGET_DIR)/lib/ld-musl-$(MUSL_ARCH).so.1
endef
endif

#
# Various functions used by the external toolchain package
# infrastructure to handle the Blackfin specific
# BR2_BFIN_INSTALL_FDPIC_SHARED and BR2_BFIN_INSTALL_FLAT_SHARED
# options.
#

# Special installation target used on the Blackfin architecture when
# FDPIC is not the primary binary format being used, but the user has
# nonetheless requested the installation of the FDPIC libraries to the
# target filesystem.
ifeq ($(BR2_BFIN_INSTALL_FDPIC_SHARED),y)
define TOOLCHAIN_EXTERNAL_INSTALL_SYSROOT_LIBS_BFIN_FDPIC
	$(Q)$(call MESSAGE,"Install external toolchain FDPIC libraries to staging...")
	$(Q)FDPIC_EXTERNAL_CC=$(dir $(TOOLCHAIN_EXTERNAL_CC))/../../bfin-linux-uclibc/bin/bfin-linux-uclibc-gcc ; \
	FDPIC_SYSROOT_DIR="$(call toolchain_find_sysroot,$${FDPIC_EXTERNAL_CC} $(TOOLCHAIN_EXTERNAL_CFLAGS))" ; \
	FDPIC_LIB_DIR="$(call toolchain_find_libdir,$${FDPIC_EXTERNAL_CC} $(TOOLCHAIN_EXTERNAL_CFLAGS))" ; \
	FDPIC_SUPPORT_LIB_DIR="" ; \
	if test `find $${FDPIC_SYSROOT_DIR} -name 'libstdc++.a' | wc -l` -eq 0 ; then \
	        FDPIC_LIBSTDCPP_A_LOCATION=$$(LANG=C $${FDPIC_EXTERNAL_CC} $(TOOLCHAIN_EXTERNAL_CFLAGS) -print-file-name=libstdc++.a) ; \
	        if [ -e "$${FDPIC_LIBSTDCPP_A_LOCATION}" ]; then \
	                FDPIC_SUPPORT_LIB_DIR=`readlink -f $${FDPIC_LIBSTDCPP_A_LOCATION} | sed -r -e 's:libstdc\+\+\.a::'` ; \
	        fi ; \
	fi ; \
	$(call copy_toolchain_sysroot,$${FDPIC_SYSROOT_DIR},$${FDPIC_SYSROOT_DIR},,$${FDPIC_LIB_DIR},$${FDPIC_SUPPORT_LIB_DIR})
endef
define TOOLCHAIN_EXTERNAL_INSTALL_TARGET_BFIN_FDPIC
	$(Q)$(call MESSAGE,"Install external toolchain FDPIC libraries to target...")
	$(Q)for libs in $(TOOLCHAIN_EXTERNAL_LIBS); do \
		$(call copy_toolchain_lib_root,$$libs); \
	done
endef
endif

# Special installation target used on the Blackfin architecture when
# shared FLAT is not the primary format being used, but the user has
# nonetheless requested the installation of the shared FLAT libraries
# to the target filesystem. The flat libraries are found and linked
# according to the index in name "libN.so". Index 1 is reserved for
# the standard C library. Customer libraries can use 4 and above.
ifeq ($(BR2_BFIN_INSTALL_FLAT_SHARED),y)
define TOOLCHAIN_EXTERNAL_INSTALL_TARGET_BFIN_FLAT
	$(Q)$(call MESSAGE,"Install external toolchain FLAT libraries to target...")
	$(Q)FLAT_EXTERNAL_CC=$(dir $(TOOLCHAIN_EXTERNAL_CC))../../bfin-uclinux/bin/bfin-uclinux-gcc ; \
	FLAT_LIBC_A_LOCATION=`$${FLAT_EXTERNAL_CC} $(TOOLCHAIN_EXTERNAL_CFLAGS) -mid-shared-library -print-file-name=libc`; \
	if [ -f $${FLAT_LIBC_A_LOCATION} -a ! -h $${FLAT_LIBC_A_LOCATION} ] ; then \
	        $(INSTALL) -D $${FLAT_LIBC_A_LOCATION} $(TARGET_DIR)/lib/lib1.so; \
	fi
endef
endif

# uClibc-ng dynamic loader is called ld-uClibc.so.1, but gcc is not
# patched specifically for uClibc-ng, so it continues to generate
# binaries that expect the dynamic loader to be named ld-uClibc.so.0,
# like with the original uClibc. Therefore, we create an additional
# symbolic link to make uClibc-ng systems work properly.
define TOOLCHAIN_EXTERNAL_FIXUP_UCLIBCNG_LDSO
	$(Q)if test -e $(TARGET_DIR)/lib/ld-uClibc.so.1; then \
		ln -sf ld-uClibc.so.1 $(TARGET_DIR)/lib/ld-uClibc.so.0 ; \
	fi
	$(Q)if test -e $(TARGET_DIR)/lib/ld64-uClibc.so.1; then \
		ln -sf ld64-uClibc.so.1 $(TARGET_DIR)/lib/ld64-uClibc.so.0 ; \
	fi
endef


################################################################################
# inner-toolchain-external-package -- defines the generic installation rules
# for external toolchain packages
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################
define inner-toolchain-external-package

$(2)_INSTALL_STAGING = YES
$(2)_ADD_TOOLCHAIN_DEPENDENCY = NO

# In fact, we don't need to download the toolchain, since it is already
# available on the system, so force the site and source to be empty so
# that nothing will be downloaded/extracted.
ifeq ($$(BR2_TOOLCHAIN_EXTERNAL_PREINSTALLED),y)
$(2)_SITE =
$(2)_SOURCE =
endif

ifeq ($$(BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD),y)
$(2)_EXCLUDES = usr/lib/locale/*

$(2)_POST_EXTRACT_HOOKS += \
	TOOLCHAIN_EXTERNAL_MOVE
endif

# Checks for an already installed toolchain: check the toolchain
# location, check that it is usable, and then verify that it
# matches the configuration provided in Buildroot: ABI, C++ support,
# kernel headers version, type of C library and all C library features.
define $(2)_CONFIGURE_CMDS
	$$(Q)$$(call check_cross_compiler_exists,$$(TOOLCHAIN_EXTERNAL_CC))
	$$(Q)$$(call check_unusable_toolchain,$$(TOOLCHAIN_EXTERNAL_CC))
	$$(Q)SYSROOT_DIR="$$(call toolchain_find_sysroot,$$(TOOLCHAIN_EXTERNAL_CC))" ; \
	$$(call check_kernel_headers_version,\
		$$(call toolchain_find_sysroot,$$(TOOLCHAIN_EXTERNAL_CC)),\
		$$(call qstrip,$$(BR2_TOOLCHAIN_HEADERS_AT_LEAST))); \
	$$(call check_gcc_version,$$(TOOLCHAIN_EXTERNAL_CC),\
		$$(call qstrip,$$(BR2_TOOLCHAIN_GCC_AT_LEAST))); \
	if test "$$(BR2_arm)" = "y" ; then \
		$$(call check_arm_abi,\
			"$$(TOOLCHAIN_EXTERNAL_CC) $$(TOOLCHAIN_EXTERNAL_CFLAGS)",\
			$$(TOOLCHAIN_EXTERNAL_READELF)) ; \
	fi ; \
	if test "$$(BR2_INSTALL_LIBSTDCPP)" = "y" ; then \
		$$(call check_cplusplus,$$(TOOLCHAIN_EXTERNAL_CXX)) ; \
	fi ; \
	if test "$$(BR2_TOOLCHAIN_HAS_FORTRAN)" = "y" ; then \
		$$(call check_fortran,$$(TOOLCHAIN_EXTERNAL_FC)) ; \
	fi ; \
	if test "$$(BR2_TOOLCHAIN_EXTERNAL_UCLIBC)" = "y" ; then \
		$$(call check_uclibc,$$$${SYSROOT_DIR}) ; \
	elif test "$$(BR2_TOOLCHAIN_EXTERNAL_MUSL)" = "y" ; then \
		$$(call check_musl,$$$${SYSROOT_DIR}) ; \
	else \
		$$(call check_glibc,$$$${SYSROOT_DIR}) ; \
	fi
	$$(Q)$$(call check_toolchain_ssp,$$(TOOLCHAIN_EXTERNAL_CC))
endef

$(2)_TOOLCHAIN_WRAPPER_ARGS += $$(TOOLCHAIN_EXTERNAL_TOOLCHAIN_WRAPPER_ARGS)

$(2)_BUILD_CMDS = $$(TOOLCHAIN_WRAPPER_BUILD)

define $(2)_INSTALL_STAGING_CMDS
	$$(TOOLCHAIN_WRAPPER_INSTALL)
	$$(TOOLCHAIN_EXTERNAL_CREATE_STAGING_LIB_SYMLINK)
	$$(TOOLCHAIN_EXTERNAL_INSTALL_SYSROOT_LIBS)
	$$(TOOLCHAIN_EXTERNAL_INSTALL_SYSROOT_LIBS_BFIN_FDPIC)
	$$(TOOLCHAIN_EXTERNAL_INSTALL_WRAPPER)
	$$(TOOLCHAIN_EXTERNAL_INSTALL_GDBINIT)
endef

ifeq ($$(BR2_TOOLCHAIN_EXTERNAL_MUSL),y)
$(2)_POST_INSTALL_STAGING_HOOKS += TOOLCHAIN_EXTERNAL_MUSL_LD_LINK
endif

# Even though we're installing things in both the staging, the host
# and the target directory, we do everything within the
# install-staging step, arbitrarily.
define $(2)_INSTALL_TARGET_CMDS
	$$(TOOLCHAIN_EXTERNAL_CREATE_TARGET_LIB_SYMLINK)
	$$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_LIBS)
	$$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_GDBSERVER)
	$$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_BFIN_FDPIC)
	$$(TOOLCHAIN_EXTERNAL_INSTALL_TARGET_BFIN_FLAT)
	$$(TOOLCHAIN_EXTERNAL_FIXUP_UCLIBCNG_LDSO)
endef

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef

toolchain-external-package = $(call inner-toolchain-external-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
