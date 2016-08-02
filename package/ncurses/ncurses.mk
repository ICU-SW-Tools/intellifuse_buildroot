################################################################################
#
# ncurses
#
################################################################################

NCURSES_VERSION = 5.9
NCURSES_SITE = $(BR2_GNU_MIRROR)/ncurses
NCURSES_INSTALL_STAGING = YES
NCURSES_DEPENDENCIES = host-ncurses
NCURSES_PROGS = clear infocmp tabs tic toe tput tset
NCURSES_LICENSE = MIT with advertising clause
NCURSES_LICENSE_FILES = README
NCURSES_CONFIG_SCRIPTS = ncurses$(NCURSES_LIB_SUFFIX)$(NCURSES_ABI_VERSION)-config

NCURSES_CONF_OPTS = \
	--without-cxx \
	--without-cxx-binding \
	--without-ada \
	--without-tests \
	--disable-big-core \
	--without-profile \
	--disable-rpath \
	--disable-rpath-hack \
	--enable-echo \
	--enable-const \
	--enable-overwrite \
	--enable-pc-files \
	$(if $(BR2_PACKAGE_NCURSES_TARGET_PROGS),,--without-progs) \
	--without-manpages

# Install after busybox for the full-blown versions
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
NCURSES_DEPENDENCIES += busybox
endif

ifeq ($(BR2_STATIC_LIBS),y)
NCURSES_CONF_OPTS += --without-shared --with-normal
else ifeq ($(BR2_SHARED_LIBS),y)
NCURSES_CONF_OPTS += --with-shared --without-normal
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
NCURSES_CONF_OPTS += --with-shared --with-normal
endif

# configure can't find the soname for libgpm when cross compiling
ifeq ($(BR2_PACKAGE_GPM),y)
NCURSES_CONF_OPTS += --with-gpm=libgpm.so.2
NCURSES_DEPENDENCIES += gpm
else
NCURSES_CONF_OPTS += --without-gpm
endif

NCURSES_LIBS-y = ncurses
NCURSES_LIBS-$(BR2_PACKAGE_NCURSES_TARGET_MENU) += menu
NCURSES_LIBS-$(BR2_PACKAGE_NCURSES_TARGET_PANEL) += panel
NCURSES_LIBS-$(BR2_PACKAGE_NCURSES_TARGET_FORM) += form

NCURSES_TERMINFO_FILES = \
	a/ansi \
	p/putty \
	p/putty-vt100 \
	s/screen \
	v/vt100 \
	v/vt100-putty \
	v/vt102 \
	v/vt200 \
	v/vt220 \
	x/xterm \
	x/xterm-color \
	x/xterm-xfree86 \

ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
NCURSES_CONF_OPTS += --enable-widec
NCURSES_LIB_SUFFIX = w

define NCURSES_LINK_LIBS_STATIC
	$(foreach lib,$(NCURSES_LIBS-y:%=lib%), \
		ln -sf $(lib)$(NCURSES_LIB_SUFFIX).a $(1)/usr/lib/$(lib).a
	)
	ln -sf libncurses$(NCURSES_LIB_SUFFIX).a \
		$(1)/usr/lib/libcurses.a
endef

define NCURSES_LINK_LIBS_SHARED
	$(foreach lib,$(NCURSES_LIBS-y:%=lib%), \
		ln -sf $(lib)$(NCURSES_LIB_SUFFIX).so $(1)/usr/lib/$(lib).so
	)
	ln -sf libncurses$(NCURSES_LIB_SUFFIX).so \
		$(1)/usr/lib/libcurses.so
endef

define NCURSES_LINK_PC
	$(foreach pc,$(NCURSES_LIBS-y), \
		ln -sf $(pc)$(NCURSES_LIB_SUFFIX).pc \
			$(1)/usr/lib/pkgconfig/$(pc).pc
	)
endef

NCURSES_LINK_TARGET_LIBS = \
	$(if $(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),$(call NCURSES_LINK_LIBS_STATIC,$(TARGET_DIR));) \
	$(if $(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),$(call NCURSES_LINK_LIBS_SHARED,$(TARGET_DIR)))
NCURSES_LINK_STAGING_LIBS = \
	$(if $(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),$(call NCURSES_LINK_LIBS_STATIC,$(STAGING_DIR));) \
	$(if $(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),$(call NCURSES_LINK_LIBS_SHARED,$(STAGING_DIR)))

NCURSES_LINK_STAGING_PC = $(call NCURSES_LINK_PC,$(STAGING_DIR))

NCURSES_CONF_OPTS += --enable-ext-colors
NCURSES_ABI_VERSION = 6
NCURSES_TERMINFO_FILES += \
	p/putty-256color \
	x/xterm+256color \
	x/xterm-256color

NCURSES_POST_INSTALL_STAGING_HOOKS += NCURSES_LINK_STAGING_LIBS
NCURSES_POST_INSTALL_STAGING_HOOKS += NCURSES_LINK_STAGING_PC

else # BR2_PACKAGE_NCURSES_WCHAR
NCURSES_ABI_VERSION = 5
endif # BR2_PACKAGE_NCURSES_WCHAR

ifneq ($(BR2_ENABLE_DEBUG),y)
NCURSES_CONF_OPTS += --without-debug
endif

# ncurses breaks with parallel build, but takes quite a while to
# build single threaded. Work around it similar to how Gentoo does
define NCURSES_BUILD_CMDS
	$(MAKE1) -C $(@D) DESTDIR=$(STAGING_DIR) sources
	rm -rf $(@D)/misc/pc-files
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR)
endef

ifneq ($(BR2_STATIC_LIBS),y)
define NCURSES_INSTALL_TARGET_LIBS
	$(foreach lib,$(NCURSES_LIBS-y:%=lib%), \
		cp -dpf $(NCURSES_DIR)/lib/$(lib)$(NCURSES_LIB_SUFFIX).so* \
			$(TARGET_DIR)/usr/lib/
	)
endef
endif

ifeq ($(BR2_PACKAGE_NCURSES_TARGET_PROGS),y)
define NCURSES_INSTALL_TARGET_PROGS
	$(foreach prog,$(NCURSES_PROGS), \
		$(INSTALL) -m 0755 $(NCURSES_DIR)/progs/$(prog) \
			$(TARGET_DIR)/usr/bin/$(prog)
	)
	ln -sf tset $(TARGET_DIR)/usr/bin/reset
endef
endif

define NCURSES_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib
	$(NCURSES_INSTALL_TARGET_LIBS)
	$(NCURSES_LINK_TARGET_LIBS)
	$(NCURSES_INSTALL_TARGET_PROGS)
	ln -snf /usr/share/terminfo $(TARGET_DIR)/usr/lib/terminfo
	$(foreach terminfo,$(NCURSES_TERMINFO_FILES),\
		$(INSTALL) -D -m 0644 $(STAGING_DIR)/usr/share/terminfo/$(terminfo) \
			$(TARGET_DIR)/usr/share/terminfo/$(terminfo)
	)
endef # NCURSES_INSTALL_TARGET_CMDS

#
# On systems with an older version of tic, the installation of ncurses hangs
# forever. To resolve the problem, build a static version of tic on host
# ourselves, and use that during installation.
#
define HOST_NCURSES_BUILD_CMDS
	$(MAKE1) -C $(@D) sources
	$(MAKE) -C $(@D)/progs tic
endef

HOST_NCURSES_CONF_OPTS = \
	--with-shared \
	--without-gpm \
	--without-manpages \
	--without-cxx \
	--without-cxx-binding \
	--without-ada \
	--without-normal

$(eval $(autotools-package))
$(eval $(host-autotools-package))
