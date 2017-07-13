################################################################################
#
# minetest_game
#
################################################################################

MINETEST_GAME_VERSION = 0.4.16
MINETEST_GAME_SITE = $(call github,minetest,minetest_game,$(MINETEST_GAME_VERSION))
MINETEST_GAME_LICENSE = LGPL-2.1+ (code), CC-BY-SA-2.0, CC-BY-SA-3.0, \
	CC-BY-SA-4.0, MIT, CC0 1.0, CC-BY-2.0 (mods)
MINETEST_GAME_LICENSE_FILES = LICENSE.txt \
	mods/beds/license.txt \
	mods/boats/license.txt \
	mods/bones/license.txt \
	mods/bucket/license.txt \
	mods/carts/license.txt \
	mods/creative/license.txt \
	mods/default/license.txt \
	mods/doors/license.txt \
	mods/dye/license.txt \
	mods/farming/license.txt \
	mods/fire/license.txt \
	mods/flowers/license.txt \
	mods/give_initial_stuff/license.txt \
	mods/screwdriver/license.txt \
	mods/sethome/license.txt \
	mods/stairs/license.txt \
	mods/tnt/license.txt \
	mods/vessels/license.txt \
	mods/walls/license.txt \
	mods/wool/license.txt \
	mods/xpanes/license.txt

define MINETEST_GAME_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/minetest/games/minetest_game
	cp -dpfr $(@D)/* $(TARGET_DIR)/usr/share/minetest/games/minetest_game
endef

$(eval $(generic-package))
