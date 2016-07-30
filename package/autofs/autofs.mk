################################################################################
#
# autofs
#
################################################################################

AUTOFS_VERSION = 5.1.2
AUTOFS_SOURCE = autofs-$(AUTOFS_VERSION).tar.xz
AUTOFS_SITE = $(BR2_KERNEL_MIRROR)/linux/daemons/autofs/v5
AUTOFS_LICENSE = GPLv2+
AUTOFS_LICENSE_FILES = COPYING COPYRIGHT
AUTOFS_DEPENDENCIES = host-flex host-bison
# For 0002-autofs-configure-check-for-clock_gettime-in-librt.patch and
# 0003-configure-add-cache-variable-for-Linux-proc-filesyst.patch.
AUTOFS_AUTORECONF = YES

# autofs looks on the build machine for the path of modprobe, so tell
# it explicitly where it will be located on the target.
AUTOFS_CONF_ENV = \
	ac_cv_path_KRB5_CONFIG=no \
	ac_cv_path_MODPROBE=/sbin/modprobe \
	ac_cv_linux_procfs=yes

# instead of looking in the PATH like any reasonable package, autofs
# configure looks only in an hardcoded search path for host tools,
# which we have to override with --with-path.
AUTOFS_CONF_OPTS = \
	--disable-mount-locking \
	--enable-ignore-busy \
	--without-openldap \
	--without-sasl \
	--with-path="$(BR_PATH)" \
	--with-hesiod=no

AUTOFS_MAKE_ENV = DONTSTRIP=1

$(eval $(autotools-package))
