#############################################################
#
# SDL_ttf
#
#############################################################
SDL_TTF_VERSION:=2.0.9
SDL_TTF_SOURCE:=SDL_ttf-$(SDL_TTF_VERSION).tar.gz
SDL_TTF_SITE:=http://www.libsdl.org/projects/SDL_ttf/release/

SDL_TTF_LIBTOOL_PATCH = NO
SDL_TTF_INSTALL_STAGING = YES
SDL_TTF_DEPENDENCIES = sdl freetype
SDL_TTF_CONF_OPT = --without-x \
		--with-freetype-prefix=$(STAGING_DIR)/usr \
		--with-sdl-prefix=$(STAGING_DIR)/usr

SDL_TTF_MAKE_OPT = INCLUDES="-I$(STAGING_DIR)/usr/include/SDL"  LDFLAGS="-L$(STAGING_DIR)/usr/lib"
$(eval $(call AUTOTARGETS,package,sdl_ttf))
