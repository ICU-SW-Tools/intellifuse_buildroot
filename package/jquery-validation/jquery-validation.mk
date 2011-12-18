JQUERY_VALIDATION_VERSION = 1.9.0
JQUERY_VALIDATION_SITE = http://jquery.bassistance.de/validate
JQUERY_VALIDATION_SOURCE = jquery-validation-$(JQUERY_VALIDATION_VERSION).zip

define JQUERY_VALIDATION_EXTRACT_CMDS
	unzip -d $(BUILD_DIR) $(DL_DIR)/$(JQUERY_VALIDATION_SOURCE)
endef

define JQUERY_VALIDATION_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/jquery.validate.min.js \
		$(TARGET_DIR)/var/www/jquery.validate.js
endef

define JQUERY_VALIDATION_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/var/www/jquery.validate.js
endef

$(eval $(call GENTARGETS))
