################################################################################
#
# irda-utils
#
################################################################################

IRDA_UTILS_VERSION = 0.9.18
IRDA_UTILS_SITE = http://downloads.sourceforge.net/project/irda/irda-utils/$(IRDA_UTILS_VERSION)

IRDA_UTILS_CFLAGS = $(TARGET_CFLAGS) -I.
ifeq ($(BR2_USE_MMU),)
IRDA_UTILS_CFLAGS += -DNO_FORK=1
endif

define IRDA_UTILS_BUILD_CMDS
	$(MAKE) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(IRDA_UTILS_CFLAGS)" \
		SYS_INCLUDES= \
		DIRS="irattach irdaping irnetd" \
		V=1 -C $(@D)
endef

IRDA_UTILS_SBINS-  =
IRDA_UTILS_SBINS-y =
IRDA_UTILS_SBINS-$(BR2_PACKAGE_IRDA_UTILS_IRATTACH) += irattach
IRDA_UTILS_SBINS-$(BR2_PACKAGE_IRDA_UTILS_IRDAPING) += irdaping
IRDA_UTILS_SBINS-$(BR2_PACKAGE_IRDA_UTILS_IRNETD)   += irnetd
IRDA_UTILS_SBINS- += $(IRDA_UTILS_SBINS-y)

define IRDA_UTILS_INSTALL_TARGET_CMDS
	for i in $(IRDA_UTILS_SBINS-y); do \
		$(INSTALL) -m 0755 -D $(@D)/$$i/$$i $(TARGET_DIR)/usr/sbin/$$i; \
	done
endef

$(eval $(generic-package))
