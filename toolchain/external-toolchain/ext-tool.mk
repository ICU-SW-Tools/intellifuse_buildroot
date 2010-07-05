
#
# This file implements the support for external toolchains, i.e
# toolchains that have not been produced by Buildroot itself and that
# are already available on the system on which Buildroot runs. So far,
# we have tested this with:
#
#  * Toolchains generated by Crosstool-NG
#  * Toolchains generated by Buildroot
#  * ARM, MIPS and PowerPC toolchains made available by
#    Codesourcery. For the MIPS toolchain, the -muclibc variant isn't
#    supported yet, only the default glibc-based variant is.
#
# The basic principle is the following
#
#  1. Perform some checks on the conformity between the toolchain
#  configuration described in the Buildroot menuconfig system, and the
#  real configuration of the external toolchain. This is for example
#  important to make sure that the Buildroot configuration system
#  knows whether the toolchain supports RPC, IPv6, locales, large
#  files, etc. Unfortunately, these things cannot be detected
#  automatically, since the value of these options (such as
#  BR2_INET_RPC) are needed at configuration time because these
#  options are used as dependencies for other options. And at
#  configuration time, we are not able to retrieve the external
#  toolchain configuration.
#
#  2. Copy the libraries needed at runtime to the target directory,
#  $(TARGET_DIR). Obviously, things such as the C library, the dynamic
#  loader and a few other utility libraries are needed if dynamic
#  applications are to be executed on the target system.
#
#  3. Copy the libraries and headers to the staging directory. This
#  will allow all further calls to gcc to be made using --sysroot
#  $(STAGING_DIR), which greatly simplifies the compilation of the
#  packages when using external toolchains. So in the end, only the
#  cross-compiler binaries remains external, all libraries and headers
#  are imported into the Buildroot tree.

#
# Copy a toolchain library and its symbolic links from the sysroot
# directory to the target directory. Also optionaly strips the
# library.
#
# $1: arch specific sysroot directory
# $2: library name
# $3: destination directory
# $4: strip (y|n), default is to strip
#
copy_toolchain_lib_root = \
	ARCH_SYSROOT_DIR="$(strip $1)"; \
	LIB="$(strip $2)"; \
	STRIP="$(strip $4)"; \
 \
	LIBS=`(cd $${ARCH_SYSROOT_DIR}; find . -path "./lib/$${LIB}.*" -o -path "./usr/lib/$${LIB}.*")` ; \
	for FILE in $${LIBS} ; do \
		LIB=`basename $${FILE}`; \
		LIBDIR=`dirname $${FILE}` ; \
		while test \! -z "$${LIB}"; do \
			FULLPATH="$${ARCH_SYSROOT_DIR}/$${LIBDIR}/$${LIB}" ; \
			rm -fr $(TARGET_DIR)/$${LIBDIR}/$${LIB}; \
			mkdir -p $(TARGET_DIR)/$${LIBDIR}; \
			if test -h $${FULLPATH} ; then \
				cp -d $${FULLPATH} $(TARGET_DIR)/$${LIBDIR}/; \
			elif test -f $${FULLPATH}; then \
				$(INSTALL) -D -m0755 $${FULLPATH} $(TARGET_DIR)/$${LIBDIR}/$${LIB}; \
				case "$${STRIP}" in \
				(0 | n | no) \
;; \
				(*) \
					$(TARGET_CROSS)strip "$(TARGET_DIR)/$${LIBDIR}/$${LIB}"; \
;; \
				esac; \
			else \
				exit -1; \
			fi; \
			LIB="`readlink $${FULLPATH}`"; \
		done; \
	done; \
 \
	echo -n

#
# Copy the full external toolchain sysroot directory to the staging
# dir. The operation of this function is rendered a little bit
# complicated by the support for multilib toolchains.
#
# We start by copying etc, lib, sbin and usr from the sysroot of the
# selected architecture variant (as pointed by ARCH_SYSROOT_DIR). This
# allows to import into the staging directory the C library and
# companion libraries for the correct architecture variant. We
# explictly only copy etc, lib, sbin and usr since other directories
# might exist for other architecture variants (on Codesourcery
# toolchain, the sysroot for the default architecture variant contains
# the armv4t and thumb2 subdirectories, which are the sysroot for the
# corresponding architecture variants), and we don't want to import
# them.
#
# Then, if the selected architecture variant is not the default one
# (i.e, if SYSROOT_DIR != ARCH_SYSROOT_DIR), then we :
#
#  * Import the header files from the default architecture
#    variant. Header files are typically shared between the sysroots
#    for the different architecture variants. If we use the
#    non-default one, header files were not copied by the previous
#    step, so we copy them here from the sysroot of the default
#    architecture variant.
#
#  * Create a symbolic link that matches the name of the subdirectory
#    for the architecture variant in the original sysroot. This is
#    required as the compiler will by default look in
#    sysroot_dir/arch_variant/ for libraries and headers, when the
#    non-default architecture variant is used. Without this, the
#    compiler fails to find libraries and headers.
#
# $1: main sysroot directory of the toolchain
# $2: arch specific sysroot directory of the toolchain
# $3: arch specific subdirectory in the sysroot
#
copy_toolchain_sysroot = \
	SYSROOT_DIR="$(strip $1)"; \
	ARCH_SYSROOT_DIR="$(strip $2)"; \
	ARCH_SUBDIR="$(strip $3)"; \
	for i in etc lib sbin usr ; do \
		if [ -d $${ARCH_SYSROOT_DIR}/$$i ] ; then \
			cp -a $${ARCH_SYSROOT_DIR}/$$i $(STAGING_DIR)/ ; \
		fi ; \
	done ; \
	if [ `readlink -f $${SYSROOT_DIR}` != `readlink -f $${ARCH_SYSROOT_DIR}` ] ; then \
		if [ ! -d $${ARCH_SYSROOT_DIR}/usr/include ] ; then \
			cp -a $${SYSROOT_DIR}/usr/include $(STAGING_DIR)/usr ; \
		fi ; \
		ln -s . $(STAGING_DIR)/$(ARCH_SUBDIR) ; \
	fi ; \
	find $(STAGING_DIR) -type d | xargs chmod 755

#
# Create lib64 -> lib and usr/lib64 -> usr/lib symbolic links in the
# target and staging directories. This is needed for some 64 bits
# toolchains such as the Crosstool-NG toolchains, for which the path
# to the dynamic loader and other libraries is /lib64, but the
# libraries are stored in /lib.
#
create_lib64_symlinks = \
	(cd $(TARGET_DIR) ;      ln -s lib lib64) ; \
	(cd $(TARGET_DIR)/usr ;  ln -s lib lib64) ; \
	(cd $(STAGING_DIR) ;     ln -s lib lib64) ; \
	(cd $(STAGING_DIR)/usr ; ln -s lib lib64)

#
# Check the availability of a particular glibc feature. We assume that
# all Buildroot toolchain options are supported by glibc, so we just
# check that they are enabled.
#
# $1: Buildroot option name
# $2: feature description
#
check_glibc_feature = \
	if [ x$($(1)) != x"y" ] ; then \
		echo "$(2) available in C library, please enable $(1)" ; \
		exit 1 ; \
	fi

#
# Check the correctness of a glibc external toolchain configuration.
#  1. Check that the C library selected in Buildroot matches the one
#     of the external toolchain
#  2. Check that all the C library-related features are enabled in the
#     config, since glibc always supports all of them
#
# $1: sysroot directory
#
check_glibc = \
	SYSROOT_DIR="$(strip $1)"; \
	if ! test -f $${SYSROOT_DIR}/lib/ld-linux*.so.* -o -f $${SYSROOT_DIR}/lib/ld.so.* ; then \
		echo "Incorrect selection of the C library"; \
		exit -1; \
	fi; \
	$(call check_glibc_feature,BR2_LARGEFILE,Large file support) ;\
	$(call check_glibc_feature,BR2_INET_IPV6,IPv6 support) ;\
	$(call check_glibc_feature,BR2_INET_RPC,RPC support) ;\
	$(call check_glibc_feature,BR2_ENABLE_LOCALE,Locale support) ;\
	$(call check_glibc_feature,BR2_USE_WCHAR,Wide char support) ;\
	$(call check_glibc_feature,BR2_PROGRAM_INVOCATION,Program invocation support)

#
# Check the conformity of Buildroot configuration with regard to the
# uClibc configuration of the external toolchain, for a particular
# feature.
#
# $1: uClibc macro name
# $2: Buildroot option name
# $3: uClibc config file
# $4: feature description
#
check_uclibc_feature = \
	IS_IN_LIBC=`grep -q "\#define $(1) 1" $(3) && echo y` ; \
	if [ x$($(2)) != x"y" -a x$${IS_IN_LIBC} == x"y" ] ; then \
		echo "$(4) available in C library, please enable $(2)" ; \
		exit 1 ; \
	fi ; \
	if [ x$($(2)) == x"y" -a x$${IS_IN_LIBC} != x"y" ] ; then \
		echo "$(4) not available in C library, please disable $(2)" ; \
		exit 1 ; \
	fi

#
# Check the correctness of a uclibc external toolchain configuration
#  1. Check that the C library selected in Buildroot matches the one
#     of the external toolchain
#  2. Check that the features enabled in the Buildroot configuration
#     match the features available in the uClibc of the external
#     toolchain
#
# $1: sysroot directory
#
check_uclibc = \
	SYSROOT_DIR="$(strip $1)"; \
	if ! test -f $${SYSROOT_DIR}/lib/ld-uClibc.so.* ; then \
		echo "Incorrect selection of the C library"; \
		exit -1; \
	fi; \
	UCLIBC_CONFIG_FILE=$${SYSROOT_DIR}/usr/include/bits/uClibc_config.h ; \
	$(call check_uclibc_feature,__UCLIBC_HAS_LFS__,BR2_LARGEFILE,$${UCLIBC_CONFIG_FILE},Large file support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_IPV6__,BR2_INET_IPV6,$${UCLIBC_CONFIG_FILE},IPv6 support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_RPC__,BR2_INET_RPC,$${UCLIBC_CONFIG_FILE},RPC support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_LOCALE__,BR2_ENABLE_LOCALE,$${UCLIBC_CONFIG_FILE},Locale support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_WCHAR__,BR2_USE_WCHAR,$${UCLIBC_CONFIG_FILE},Wide char support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_PROGRAM_INVOCATION_NAME__,BR2_PROGRAM_INVOCATION,$${UCLIBC_CONFIG_FILE},Program invocation support) ;\

#
# Check that the Buildroot configuration of the ABI matches the
# configuration of the external toolchain.
#
check_arm_abi = \
	EXT_TOOLCHAIN_TARGET=$(shell LANG=C $(TARGET_CC) -v 2>&1 | grep ^Target | cut -f2 -d ' ') ; \
	if echo $${EXT_TOOLCHAIN_TARGET} | grep -q 'eabi$$' ; then \
		EXT_TOOLCHAIN_ABI="eabi" ; \
	else \
		EXT_TOOLCHAIN_ABI="oabi" ; \
	fi ; \
	if [ x$(BR2_ARM_OABI) == x"y" -a $${EXT_TOOLCHAIN_ABI} == "eabi" ] ; then \
		echo "Incorrect ABI setting" ; \
		exit 1 ; \
	fi ; \
	if [ x$(BR2_ARM_EABI) == x"y" -a $${EXT_TOOLCHAIN_ABI} == "oabi" ] ; then \
		echo "Incorrect ABI setting" ; \
		exit 1 ; \
	fi ; \

#
# Check that the external toolchain supports C++
#
check_cplusplus = \
	if ! test -x $(TARGET_CXX) ; then \
		echo "BR2_INSTALL_LIBSTDCPP is selected but C++ support not available in external toolchain" ; \
		exit 1 ; \
	fi ; \

#
# Check that the cross-compiler given in the configuration exists
#
check_cross_compiler_exists = \
	if ! test -x $(TARGET_CC) ; then \
		echo "Cannot find cross-compiler $(TARGET_CC)" ; \
		exit 1 ; \
	fi ; \

uclibc: dependencies $(STAMP_DIR)/ext-toolchain-installed

EXTERNAL_LIBS=ld*.so libc.so libcrypt.so libdl.so libgcc_s.so libm.so libnsl.so libresolv.so librt.so libutil.so
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_GCLIBC),y)
EXTERNAL_LIBS+=libnss_files.so libnss_dns.so
endif

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
EXTERNAL_LIBS+=libstdc++.so
endif

ifneq ($(BR2_PTHREADS_NONE),y)
EXTERNAL_LIBS+=libpthread.so
ifeq ($(BR2_PACKAGE_GDB_SERVER),y)
EXTERNAL_LIBS+=libthread_db.so
endif # gdbserver
endif # ! no threads

# SYSROOT_DIR selection. We first try the -print-sysroot option,
# available in gcc 4.4.x and in some Codesourcery toolchains. If this
# option is not available, we fallback to the value of --with-sysroot
# as visible in CROSS-gcc -v. We don't pass any option to gcc that
# could select a multilib variant as we want the "main" sysroot, which
# contains all variants of the C library in the case of multilib
# toolchains.
SYSROOT_DIR=$(shell $(TARGET_CC) -print-sysroot 2>/dev/null)
ifeq ($(SYSROOT_DIR),)
SYSROOT_DIR=$(shell readlink -f $$(LANG=C $(TARGET_CC) -print-file-name=libc.a |sed -r -e 's:usr/lib/libc\.a::;'))
endif

# Now, find if the toolchain specifies a sub-directory for the
# specific architecture variant we're interested in. This is the case
# with multilib toolchain, when the selected architecture variant is
# not the default one. To do so, we ask the compiler by passing all
# flags, except the --sysroot flag since we want to the compiler to
# tell us where its original sysroot is. ARCH_SUBDIR will contain the
# subdirectory, in the main SYSROOT_DIR, that corresponds to the
# selected architecture variant. ARCH_SYSROOT_DIR will contain the
# full path to this location.
TARGET_CFLAGS_NO_SYSROOT=$(filter-out --sysroot=%,$(TARGET_CFLAGS))
ARCH_SUBDIR=$(shell $(TARGET_CC) $(TARGET_CFLAGS_NO_SYSROOT) -print-multi-directory)
ARCH_SYSROOT_DIR=$(SYSROOT_DIR)/$(ARCH_SUBDIR)

$(STAMP_DIR)/ext-toolchain-installed:
	@echo "Checking external toolchain settings"
	$(Q)$(call check_cross_compiler_exists)
ifeq ($(strip $(SYSROOT_DIR)),)
	@echo "External toolchain doesn't support --sysroot. Cannot use."
	exit 1
endif
ifeq ($(BR2_arm),y)
	$(Q)$(call check_arm_abi)
endif
ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
	$(Q)$(call check_cplusplus)
endif
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_UCLIBC),y)
	$(Q)$(call check_uclibc,$(SYSROOT_DIR))
else
	$(Q)$(call check_glibc,$(SYSROOT_DIR))
endif
	mkdir -p $(TARGET_DIR)/lib
	@echo "Copy external toolchain libraries to target..."
	$(Q)for libs in $(EXTERNAL_LIBS); do \
		$(call copy_toolchain_lib_root,$(ARCH_SYSROOT_DIR),$$libs,$(BR2_TOOLCHAIN_EXTERNAL_STRIP)); \
	done
	@echo "Copy external toolchain sysroot to staging..."
	$(Q)$(call copy_toolchain_sysroot,$(SYSROOT_DIR),$(ARCH_SYSROOT_DIR),$(ARCH_SUBDIR))
	# Create lib64 symbolic links if needed
	$(Q)if [ -L $(ARCH_SYSROOT_DIR)/lib64 ] ; then \
		$(call create_lib64_symlinks) ; \
	fi
	@touch $@
