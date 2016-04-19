################################################################################
#
# qt5connectivity
#
################################################################################

QT5CONNECTIVITY_VERSION = $(QT5_VERSION)
QT5CONNECTIVITY_SITE = $(QT5_SITE)
QT5CONNECTIVITY_SOURCE = qtconnectivity-opensource-src-$(QT5CONNECTIVITY_VERSION).tar.xz
QT5CONNECTIVITY_DEPENDENCIES = qt5base
QT5CONNECTIVITY_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5CONNECTIVITY_LICENSE = GPLv2 or GPLv3 or LGPLv2.1 with exception or LGPLv3, GFDLv1.3 (docs)
QT5CONNECTIVITY_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
else
QT5CONNECTIVITY_LICENSE = Commercial license
QT5CONNECTIVITY_REDISTRIBUTE = NO
endif

QT5CONNECTIVITY_DEPENDENCIES += $(if $(BR2_PACKAGE_QT5DECLARATIVE),qt5declarative)
QT5CONNECTIVITY_DEPENDENCIES += $(if $(BR2_PACKAGE_BLUEZ_UTILS),bluez_utils)
QT5CONNECTIVITY_DEPENDENCIES += $(if $(BR2_PACKAGE_BLUEZ5_UTILS),bluez5_utils)
QT5CONNECTIVITY_DEPENDENCIES += $(if $(BR2_PACKAGE_NEARD),neard)

define QT5CONNECTIVITY_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5CONNECTIVITY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5CONNECTIVITY_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
ifneq ($(BR2_PACKAGE_BLUEZ_UTILS)$(BR2_PACKAGE_BLUEZ5_UTILS),)
define QT5CONNECTIVITY_INSTALL_TARGET_BLUETOOTH_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtBluetooth $(TARGET_DIR)/usr/qml/
endef
endif
ifeq ($(BR2_PACKAGE_NEARD),y)
define QT5CONNECTIVITY_INSTALL_TARGET_NFC_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtNfc $(TARGET_DIR)/usr/qml/
endef
endif
endif

ifneq ($(BR2_PACKAGE_BLUEZ_UTILS)$(BR2_PACKAGE_BLUEZ5_UTILS),)
define QT5CONNECTIVITY_INSTALL_TARGET_BLUETOOTH
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Bluetooth.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/bin/sdpscanner $(TARGET_DIR)/usr/bin
endef
endif

ifeq ($(BR2_PACKAGE_NEARD),y)
define QT5CONNECTIVITY_INSTALL_TARGET_NFC
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Nfc.so.* $(TARGET_DIR)/usr/lib
endef
endif

define QT5CONNECTIVITY_INSTALL_TARGET_CMDS
	$(QT5CONNECTIVITY_INSTALL_TARGET_BLUETOOTH)
	$(QT5CONNECTIVITY_INSTALL_TARGET_NFC)
	$(QT5CONNECTIVITY_INSTALL_TARGET_BLUETOOTH_QMLS)
	$(QT5CONNECTIVITY_INSTALL_TARGET_NFC_QMLS)
endef

$(eval $(generic-package))
