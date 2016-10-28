################################################################################
#
# libselinux
#
################################################################################

LIBSELINUX_VERSION = 2.5
LIBSELINUX_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20160223
LIBSELINUX_LICENSE = Public Domain
LIBSELINUX_LICENSE_FILES = LICENSE

LIBSELINUX_DEPENDENCIES = libsepol pcre

LIBSELINUX_INSTALL_STAGING = YES

# Filter out D_FILE_OFFSET_BITS=64. This fixes errors caused by glibc 2.22.
LIBSELINUX_MAKE_OPTS = \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS))" \
	LDFLAGS="$(TARGET_LDFLAGS) -lpcre -lpthread" \
	ARCH=$(KERNEL_ARCH)

define LIBSELINUX_BUILD_CMDS
	# DESTDIR is needed during the compile to compute library and
	# header paths.
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) DESTDIR=$(STAGING_DIR) all
endef

define LIBSELINUX_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
endef

define LIBSELINUX_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
	# Create the selinuxfs mount point
	if [ ! -d "$(TARGET_DIR)/selinux" ]; then mkdir $(TARGET_DIR)/selinux; fi
	if ! grep -q "selinuxfs" $(TARGET_DIR)/etc/fstab; then \
		echo "none /selinux selinuxfs noauto 0 0" >> $(TARGET_DIR)/etc/fstab ; fi
endef

HOST_LIBSELINUX_DEPENDENCIES = \
	host-libsepol host-pcre host-swig

ifeq ($(BR2_PACKAGE_PYTHON3),y)
HOST_LIBSELINUX_DEPENDENCIES += host-python3
HOST_LIBSELINUX_PYTHONLIBDIR = -L$(HOST_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/
HOST_LIBSELINUX_PYINC = -I$(HOST_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR)m/
HOST_LIBSELINUX_PYLIBVER = python$(PYTHON3_VERSION_MAJOR)
else
HOST_LIBSELINUX_DEPENDENCIES += host-python
HOST_LIBSELINUX_PYTHONLIBDIR = -L$(HOST_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/
HOST_LIBSELINUX_PYINC = -I$(HOST_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)/
HOST_LIBSELINUX_PYLIBVER = python$(PYTHON_VERSION_MAJOR)
endif

HOST_LIBSELINUX_MAKE_OPTS = \
	$(HOST_CONFIGURE_OPTS) \
	LDFLAGS="$(HOST_LDFLAGS) -lpcre -lpthread" \
	PYINC="$(HOST_LIBSELINUX_PYINC)" \
	PYTHONLIBDIR="$(HOST_LIBSELINUX_PYTHONLIBDIR)" \
	PYLIBVER="$(HOST_LIBSELINUX_PYLIBVER)" \
	SWIG_LIB="$(HOST_DIR)/usr/share/swig/$(SWIG_VERSION)/"

define HOST_LIBSELINUX_BUILD_CMDS
	# DESTDIR is needed during the compile to compute library and
	# header paths.
	$(MAKE1) -C $(@D) $(HOST_LIBSELINUX_MAKE_OPTS) DESTDIR=$(HOST_DIR) \
		SHLIBDIR=$(HOST_DIR)/usr/lib all
	# Generate python interface wrapper
	$(MAKE1) -C $(@D) $(HOST_LIBSELINUX_MAKE_OPTS) DESTDIR=$(HOST_DIR) swigify pywrap
endef

define HOST_LIBSELINUX_INSTALL_CMDS
	$(MAKE) -C $(@D) $(HOST_LIBSELINUX_MAKE_OPTS) DESTDIR=$(HOST_DIR) \
		SHLIBDIR=$(HOST_DIR)/usr/lib SBINDIR=$(HOST_DIR)/usr/sbin install
	(cd $(HOST_DIR)/usr/lib; $(HOSTLN) -sf libselinux.so.1 libselinux.so)
	# Install python interface wrapper
	$(MAKE) -C $(@D) $(HOST_LIBSELINUX_MAKE_OPTS) DESTDIR=$(HOST_DIR) install-pywrap
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
