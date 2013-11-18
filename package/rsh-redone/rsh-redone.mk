################################################################################
#
# rsh-redone
#
################################################################################

RSH_REDONE_VERSION = 85
RSH_REDONE_SOURCE = rsh-redone_$(RSH_REDONE_VERSION).orig.tar.gz
RSH_REDONE_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/r/rsh-redone

rsh-redone-bin-y =
rsh-redone-bin-$(BR2_PACKAGE_RSH_REDONE_RCP) += rcp
rsh-redone-bin-$(BR2_PACKAGE_RSH_REDONE_RLOGIN) += rlogin
rsh-redone-bin-$(BR2_PACKAGE_RSH_REDONE_RSH) += rsh
rsh-redone-sbin-y =
rsh-redone-sbin-$(BR2_PACKAGE_RSH_REDONE_RLOGIND) += in.rlogind
rsh-redone-sbin-$(BR2_PACKAGE_RSH_REDONE_RSHD) += in.rshd

ifneq ($(BR2_PACKAGE_RSH_REDONE_RSHD)$(BR2_PACKAGE_RSH_REDONE_RLOGIND),)
RSH_REDONE_DEPENDENCIES = linux-pam
endif

define RSH_REDONE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) BIN="$(rsh-redone-bin-y)" SBIN="$(rsh-redone-sbin-y)"
endef

define RSH_REDONE_INSTALL_TARGET_CMDS
	$(if $(rsh-redone-bin-y)$(rsh-redone-sbin-y),
		$(RSH_REDONE_BUILD_CMDS) DESTDIR=$(TARGET_DIR) \
			$(if $(rsh-redone-bin-y),install-bin) \
			$(if $(rsh-redone-sbin-y),install-sbin))
endef

$(eval $(generic-package))
