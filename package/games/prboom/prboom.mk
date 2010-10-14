#############################################################
#
# PrBoom
#
#############################################################
PRBOOM_VERSION = 2.5.0
PRBOOM_CONF_ENV = ac_cv_type_uid_t=yes
PRBOOM_DEPENDENCIES = sdl SDL_net sdl_mixer

PRBOOM_CONF_OPT = \
		--oldincludedir=$(STAGING_DIR)/usr/include \
		--with-sdl-prefix=$(STAGING_DIR)/usr \
		--with-sdl-exec-prefix=$(STAGING_DIR)/usr \
		--disable-cpu-opt \
		--disable-sdltest \
		--disable-gl

define PRBOOM_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/src/prboom $(TARGET_DIR)/usr/games/prboom
	$(INSTALL) -D $(@D)/src/prboom-game-server $(TARGET_DIR)/usr/games/prboom-game-server
	$(INSTALL) -D $(@D)/data/prboom.wad $(TARGET_DIR)/usr/share/games/doom/prboom.wad
endef

define PRBOOM_UINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/usr/share/games/doom/prboom.wad \
		$(TARGET_DIR)/usr/games/prboom-game-server \
		$(TARGET_DIR)/usr/games/prboom
endef

$(eval $(call AUTOTARGETS,package/games,prboom))
