################################################################################
#
# freerdp
#
################################################################################

# Changeset on the stable-1.1 branch
FREERDP_VERSION = 440916eae2e07463912d5fe507677e67096eb083
FREERDP_SITE = $(call github,FreeRDP,FreeRDP,$(FREERDP_VERSION))
FREERDP_DEPENDENCIES = openssl zlib \
	xlib_libX11 xlib_libXt xlib_libXext xlib_libXcursor
FREERDP_LICENSE = Apache-2.0
FREERDP_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_CUPS),y)
FREERDP_CONF_OPT += -DWITH_CUPS=ON
FREERDP_DEPENDENCIES += cups
else
FREERDP_CONF_OPT += -DWITH_CUPS=OFF
endif

ifeq ($(BR2_PACKAGE_FFMPEG),y)
FREERDP_CONF_OPT += -DWITH_FFMPEG=ON
FREERDP_DEPENDENCIES += ffmpeg
else
FREERDP_CONF_OPT += -DWITH_FFMPEG=OFF
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
FREERDP_CONF_OPT += -DWITH_ALSA=ON
FREERDP_DEPENDENCIES += alsa-lib
else
FREERDP_CONF_OPT += -DWITH_ALSA=OFF
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
FREERDP_CONF_OPT += -DWITH_PULSEAUDIO=ON
FREERDP_DEPENDENCIES += pulseaudio
else
FREERDP_CONF_OPT += -DWITH_PULSEAUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
FREERDP_CONF_OPT += -DWITH_XINERAMA=ON
FREERDP_DEPENDENCIES += xlib_libXinerama
else
FREERDP_CONF_OPT += -DWITH_XINERAMA=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXKBFILE),y)
FREERDP_CONF_OPT += -DWITH_XKBFILE=ON
FREERDP_DEPENDENCIES += xlib_libxkbfile
else
FREERDP_CONF_OPT += -DWITH_XKBFILE=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXV),y)
FREERDP_CONF_OPT += -DWITH_XV=ON
FREERDP_DEPENDENCIES += xlib_libXv
else
FREERDP_CONF_OPT += -DWITH_XV=OFF
endif

$(eval $(cmake-package))
