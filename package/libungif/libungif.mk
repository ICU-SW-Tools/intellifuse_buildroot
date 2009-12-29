#############################################################
#
# libungif
#
#############################################################
LIBUNGIF_VERSION:=4.1.4
LIBUNGIF_SOURCE:=libungif-$(LIBUNGIF_VERSION).tar.bz2
LIBUNGIF_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/giflib
LIBUNGIF_INSTALL_STAGING = YES
LIBUNGIF_INSTALL_TARGET = YES

LIBUNGIF_CONF_OPT = --without-x

LIBUNGIF_BINS = gif2epsn gif2ps gif2rgb gif2x11 gifasm gifbg gifburst gifclip \
		gifclrmp gifcolor gifcomb gifcompose giffiltr giffix gifflip  \
		gifhisto gifinfo gifinter gifinto gifovly gifpos gifrotat     \
		gifrsize gifspnge giftext gifwedge icon2gif raw2gif rgb2gif   \
		text2gif

$(eval $(call AUTOTARGETS,package,libungif))

$(LIBUNGIF_HOOK_POST_INSTALL):
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,$(LIBUNGIF_BINS))
	touch $@
