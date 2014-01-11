################################################################################
#
# lua-ev
#
################################################################################

LUA_EV_VERSION = 458165bdfe0c6eadc788813925f11a0e6a823845
LUA_EV_SITE = $(call github,brimworks,lua-ev,$(LUA_EV_VERSION))
LUA_EV_DEPENDENCIES = luainterpreter libev
LUA_EV_LICENSE = MIT
LUA_EV_LICENSE_FILES = README
LUA_EV_CONF_OPT = -DINSTALL_CMOD="/usr/lib/lua/5.1"

$(eval $(cmake-package))
