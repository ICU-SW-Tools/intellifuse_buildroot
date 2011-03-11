#############################################################
#
# libraw
#
#############################################################

LIBRAW_VERSION = 0.13.1
LIBRAW_SOURCE = LibRaw-$(LIBRAW_VERSION).tar.gz
LIBRAW_SITE = http://www.libraw.org/data/

LIBRAW_INSTALL_STAGING = YES
LIBRAW_CONF_OPT += --disable-examples --disable-lcms \
			--disable-openmp --disable-demosaic-pack-gpl2 \
			--disable-demosaic-pack-gpl3

$(eval $(call AUTOTARGETS,package,libraw))
