#############################################################
#
# gmpc
#
#############################################################
GMPC_VERSION = 0.17.0
GMPC_SOURCE = gmpc-$(GMPC_VERSION).tar.gz
GMPC_SITE = http://download.sarine.nl/download/Programs/gmpc/$(GMPC_VERSION)/
GMPC_LIBTOOL_PATCH = NO
GMPC_CONF_ENV = ac_cv_lib_curl_curl_global_init=yes
GMPC_CONF_OPT = --disable-mmkeys

GMPC_DEPENDENCIES = libglib2 libgtk2 libglade libcurl libmpd

ifeq ($(BR2_PACKAGE_XLIB_LIBSM),y)
GMPC_DEPENENCIES += xlib_libSM
GMPC_CONF_OPT += --enable-sm
else
GMPC_CONF_OPT += --disable-sm
endif

$(eval $(call AUTOTARGETS,package,gmpc))

# we NEED a host gob2
ifeq ($(BR2_PACKAGE_GMPC),y)
ifeq ($(wildcard $(shell which gob2 || echo /usr/bin/gob2)),)
$(error Host gob2 not found. Please install GTK+ Object Builder package on your host (something like gob2))
endif
endif
