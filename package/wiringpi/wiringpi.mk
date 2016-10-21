################################################################################
#
# wiringpi
#
################################################################################

WIRINGPI_VERSION = 2.32
WIRINGPI_SITE = git://git.drogon.net/wiringPi

WIRINGPI_LICENSE = LGPLv3+
WIRINGPI_LICENSE_FILES = COPYING.LESSER
WIRINGPI_INSTALL_STAGING = YES

ifeq ($(BR2_STATIC_LIBS),y)
WIRINGPI_LIB_BUILD_TARGETS = static
WIRINGPI_LIB_INSTALL_TARGETS = install-static
WIRINGPI_BIN_BUILD_TARGETS = gpio-static
else ifeq ($(BR2_SHARED_LIBS),y)
WIRINGPI_LIB_BUILD_TARGETS = all
WIRINGPI_LIB_INSTALL_TARGETS = install
WIRINGPI_BIN_BUILD_TARGETS = all
else
WIRINGPI_LIB_BUILD_TARGETS = all static
WIRINGPI_LIB_INSTALL_TARGETS = install install-static
WIRINGPI_BIN_BUILD_TARGETS = all
endif

define WIRINGPI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/wiringPi $(WIRINGPI_LIB_BUILD_TARGETS)
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/devLib $(WIRINGPI_LIB_BUILD_TARGETS)
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/gpio $(WIRINGPI_BIN_BUILD_TARGETS)
endef

define WIRINGPI_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/wiringPi $(WIRINGPI_LIB_INSTALL_TARGETS) DESTDIR=$(STAGING_DIR) PREFIX=/usr LDCONFIG=true
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/devLib $(WIRINGPI_LIB_INSTALL_TARGETS) DESTDIR=$(STAGING_DIR) PREFIX=/usr LDCONFIG=true
endef

define WIRINGPI_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/wiringPi $(WIRINGPI_LIB_INSTALL_TARGETS) DESTDIR=$(TARGET_DIR) PREFIX=/usr LDCONFIG=true
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/devLib $(WIRINGPI_LIB_INSTALL_TARGETS) DESTDIR=$(TARGET_DIR) PREFIX=/usr LDCONFIG=true
	$(INSTALL) -D -m 0755 $(@D)/gpio/gpio $(TARGET_DIR)/usr/bin/gpio
	$(INSTALL) -D -m 0755 $(@D)/gpio/pintest $(TARGET_DIR)/usr/bin/pintest
endef

$(eval $(generic-package))
