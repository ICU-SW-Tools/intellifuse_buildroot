################################################################################
#
# kodi-addon-xvdr
#
################################################################################

# This cset is on master. When a Isengard branch is made, we should
# follow it, as incompatible changes in the plugins API can happen
# on the master branch.
KODI_ADDON_XVDR_VERSION = 88265b86896513a219acb8d5f0c0f77956fae939
KODI_ADDON_XVDR_SITE = $(call github,pipelka,xbmc-addon-xvdr,$(KODI_ADDON_XVDR_VERSION))
KODI_ADDON_XVDR_LICENSE = GPLv2+
KODI_ADDON_XVDR_LICENSE_FILES = COPYING

# There's no ./configure in the git tree, we need to generate it
# kodi-addon-xvdr uses a weird autogen.sh script, which
# is even incorrect (it's missing the #! ) Sigh... :-(
# Fortunately, with our little patch, it autoreconfs nicely! :-)
KODI_ADDON_XVDR_AUTORECONF = YES

# This really is a runtime dependency, but we need KODI to be installed
# first, since we'll install files in KODI's directories _after_ KODI has
# installed his own files
KODI_ADDON_XVDR_DEPENDENCIES = kodi

$(eval $(autotools-package))
