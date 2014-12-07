################################################################################
#
# gst1-plugins-bad
#
################################################################################

GST1_PLUGINS_BAD_VERSION = 1.4.4
GST1_PLUGINS_BAD_SOURCE = gst-plugins-bad-$(GST1_PLUGINS_BAD_VERSION).tar.xz
GST1_PLUGINS_BAD_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-bad
GST1_PLUGINS_BAD_LICENSE_FILES = COPYING COPYING.LIB
# Unknown and GPL licensed plugins will append to GST1_PLUGINS_BAD_LICENSE if
# enabled.
GST1_PLUGINS_BAD_LICENSE = LGPLv2+ LGPLv2.1+

GST1_PLUGINS_BAD_AUTORECONF = YES
GST1_PLUGINS_BAD_AUTORECONF_OPTS = -I $(@D)/common/m4
GST1_PLUGINS_BAD_GETTEXTIZE = YES

GST1_PLUGINS_BAD_CONF_OPTS = \
	--disable-examples \
	--disable-valgrind \
	--disable-directsound \
	--disable-wsapi \
	--disable-direct3d \
	--disable-directdraw \
	--disable-direct3d9 \
	--disable-winks \
	--disable-android_media \
	--disable-apple_media \
	--disable-osx_video \
	--disable-sdltest \
	--disable-wininet \
	--disable-acm

# Options which require currently unpackaged libraries
GST1_PLUGINS_BAD_CONF_OPTS += \
	--disable-avc \
	--disable-quicktime \
	--disable-opensles \
	--disable-uvch264 \
	--disable-voamrwbenc \
	--disable-chromaprint \
	--disable-dash \
	--disable-dc1394 \
	--disable-dts \
	--disable-resindvd \
	--disable-faac \
	--disable-flite \
	--disable-gsm \
	--disable-fluidsynth \
	--disable-kate \
	--disable-ladspa \
	--disable-lv2 \
	--disable-strp \
	--disable-linsys \
	--disable-modplug \
	--disable-mimic \
	--disable-mplex \
	--disable-mythtv \
	--disable-nas \
	--disable-ofa \
	--disable-openal \
	--disable-openexr \
	--disable-openjpeg \
	--disable-openni2 \
	--disable-pvr \
	--disable-libvisual \
	--disable-timidity \
	--disable-teletextdec \
	--disable-wildmidi \
	--disable-smoothstreaming \
	--disable-soundtouch \
	--disable-spc \
	--disable-gme \
	--disable-xvid \
	--disable-vdpau \
	--disable-sbc \
	--disable-schro \
	--disable-zbar \
	--disable-rtmp \
	--disable-spandsp \
	--disable-gsettings \
	--disable-sndio \
	--disable-hls

GST1_PLUGINS_BAD_DEPENDENCIES = gst1-plugins-base gstreamer1

ifeq ($(BR2_PACKAGE_ORC),y)
GST1_PLUGINS_BAD_DEPENDENCIES += orc
GST1_PLUGINS_BAD_CONF_OPTS += --enable-orc
endif

ifeq ($(BR2_PACKAGE_BLUEZ_UTILS),y)
GST1_PLUGINS_BAD_DEPENDENCIES += bluez_utils
GST1_PLUGINS_BAD_CONF_OPTS += --enable-bluez
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-bluez
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ACCURIP),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-accurip
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-accurip
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ADPCMDEC),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-adpcmdec
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-adpcmdec
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ADPCMENC),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-adpcmenc
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-adpcmenc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AIFF),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-aiff
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-aiff
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ASFMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-asfmux
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-asfmux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUDIOFXBAD),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-audiofxbad
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-audiofxbad
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUDIOMIXER),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-audiomixer
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-audiomixer
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_COMPOSITOR),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-compositor
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-compositor
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUDIOVISUALIZERS),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-audiovisualizers
GST1_PLUGINS_BAD_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-audiovisualizers
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUTOCONVERT),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-autoconvert
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-autoconvert
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_BAYER),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-bayer
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-bayer
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_CAMERABIN2),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-camerabin2
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-camerabin2
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_CDXAPARSE),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-cdxaparse
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-cdxaparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_COLOREFFECTS),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-coloreffects
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-coloreffects
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DATAURISRC),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-dataurisrc
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-dataurisrc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DCCP),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-dccp
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-dccp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DEBUGUTILS),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-debugutils
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-debugutils
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DVBSUBOVERLAY),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-dvbsuboverlay
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-dvbsuboverlay
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DVDSPU),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-dvdspu
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-dvdspu
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FACEOVERLAY),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-faceoverlay
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-faceoverlay
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FESTIVAL),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-festival
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-festival
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FIELDANALYSIS),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-fieldanalysis
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-fieldanalysis
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FREEVERB),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-freeverb
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-freeverb
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FREI0R),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-frei0r
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-frei0r
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GAUDIEFFECTS),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-gaudieffects
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-gaudieffects
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GEOMETRICTRANSFORM),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-geometrictransform
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-geometrictransform
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GDP),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-gdp
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-gdp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_HDVPARSE),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-hdvparse
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-hdvparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ID3TAG),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-id3tag
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-id3tag
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_INTER),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-inter
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-inter
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_INTERLACE),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-interlace
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-interlace
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_IVFPARSE),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-ivfparse
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-ivfparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_IVTC),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-ivtc
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-ivtc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_JP2KDECIMATOR),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-jp2kdecimator
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-jp2kdecimator
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_JPEGFORMAT),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-jpegformat
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-jpegformat
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_LIBRFB),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-librfb
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-librfb
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_LIVEADDER),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-liveadder
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-liveadder
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MIDI),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-midi
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-midi
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGDEMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-mpegdemux
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-mpegdemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGTSDEMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-mpegtsdemux
GST1_PLUGINS_BAD_HAS_UNKNOWN_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-mpegtsdemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGTSMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-mpegtsmux
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-mpegtsmux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGPSMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-mpegpsmux
GST1_PLUGINS_BAD_HAS_UNKNOWN_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-mpegpsmux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MVE),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-mve
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-mve
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MXF),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-mxf
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-mxf
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_NUVDEMUX),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-nuvdemux
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-nuvdemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_PATCHDETECT),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-patchdetect
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-patchdetect
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_PCAPPARSE),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-pcapparse
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-pcapparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_PNM),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-pnm
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-pnm
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_RAWPARSE),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-rawparse
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-rawparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_REAL),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-real
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-real
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_REMOVESILENCE),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-removesilence
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-removesilence
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SDI),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-sdi
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-sdi
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SDP),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-sdp
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-sdp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SEGMENTCLIP),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-segmentclip
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-segmentclip
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SIREN),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-siren
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-siren
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SMOOTH),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-smooth
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-smooth
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SPEED),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-speed
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-speed
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SUBENC),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-subenc
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-subenc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_STEREO),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-stereo
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-stereo
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_TTA),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-tta
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-tta
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOFILTERS),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-videofilters
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-videofilters
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOMEASURE),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-videomeasure
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-videomeasure
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOPARSERS),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-videoparsers
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-videoparsers
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOSIGNAL),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-videosignal
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-videosignal
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VMNC),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-vmnc
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-vmnc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_Y4M),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-y4m
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-y4m
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_YADIF),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-yadif
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-yadif
endif

# Plugins with dependencies

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SHM),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-shm
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-shm
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VCD),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-vcd
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-vcd
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_APEXSINK),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-apexsink
GST1_PLUGINS_BAD_DEPENDENCIES += openssl
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-apexsink
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ASSRENDER),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-assrender
GST1_PLUGINS_BAD_DEPENDENCIES += libass
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-assrender
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VOAACENC),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-voaacenc
GST1_PLUGINS_BAD_DEPENDENCIES += vo-aacenc
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-voaacenc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_BZ2),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-bz2
GST1_PLUGINS_BAD_DEPENDENCIES += bzip2
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-bz2
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_CDAUDIO),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-cdaudio
GST1_PLUGINS_BAD_DEPENDENCIES += libcdaudio
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-cdaudio
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_CURL),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-curl
GST1_PLUGINS_BAD_DEPENDENCIES += libcurl
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-curl
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DASH),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-dash
GST1_PLUGINS_BAD_DEPENDENCIES += libxml2
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-dash
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DECKLINK),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-decklink
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-decklink
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_WEBP),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-webp
GST1_PLUGINS_BAD_DEPENDENCIES += webp
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-webp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DIRECTFB),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-directfb
GST1_PLUGINS_BAD_DEPENDENCIES += directfb
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-directfb
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_WAYLAND),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-wayland
GST1_PLUGINS_BAD_DEPENDENCIES += wayland
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-wayland
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FAAD),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-faad
GST1_PLUGINS_BAD_DEPENDENCIES += faad2
GST1_PLUGINS_BAD_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-faad
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FBDEV),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-fbdev
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-fbdev
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_LIBMMS),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-libmms
GST1_PLUGINS_BAD_DEPENDENCIES += libmms
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-libmms
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEG2ENC),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-mpeg2enc
GST1_PLUGINS_BAD_DEPENDENCIES += libmpeg2
GST1_PLUGINS_BAD_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-mpeg2enc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPG123),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-mpg123
GST1_PLUGINS_BAD_DEPENDENCIES += mpg123
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-mpg123
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MUSEPACK),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-musepack
GST1_PLUGINS_BAD_DEPENDENCIES += musepack
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-musepack
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_NEON),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-neon
GST1_PLUGINS_BAD_DEPENDENCIES += neon
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-neon
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_OPENCV),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-opencv
GST1_PLUGINS_BAD_DEPENDENCIES += opencv
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-opencv
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_OPUS),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-opus
GST1_PLUGINS_BAD_DEPENDENCIES += opus
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-opus
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_RSVG),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-rsvg
GST1_PLUGINS_BAD_DEPENDENCIES += librsvg
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-rsvg
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_EGLGLES),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-eglgles
GST1_PLUGINS_BAD_DEPENDENCIES += libegl libgles

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
# RPI has odd locations for several required headers.
GST1_PLUGINS_BAD_CONF_OPTS += --with-egl-window-system=rpi
GST1_PLUGINS_BAD_CONF_ENV += \
	CFLAGS="$(TARGET_CFLAGS) \
	-I$(STAGING_DIR)/usr/include/IL \
	-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads \
	-I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux"
endif
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-eglgles
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SDL),y)
GST1_PLUGINS_BAD_CONF_ENV += ac_cv_path_SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl-config
GST1_PLUGINS_BAD_CONF_OPTS += --enable-sdl
GST1_PLUGINS_BAD_DEPENDENCIES += sdl
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SNDFILE),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-sndfile
GST1_PLUGINS_BAD_DEPENDENCIES += libsndfile
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-sndfile
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DVB),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-dvb
GST1_PLUGINS_BAD_DEPENDENCIES += dtv-scan-tables
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-dvb
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_HLS),y)
GST1_PLUGINS_BAD_CONF_OPTS += --enable-hls
GST1_PLUGINS_BAD_DEPENDENCIES += gnutls
else
GST1_PLUGINS_BAD_CONF_OPTS += --disable-hls
endif

# Add GPL license if GPL licensed plugins enabled.
ifeq ($(GST1_PLUGINS_BAD_HAS_GPL_LICENSE),y)
GST1_PLUGINS_BAD_LICENSE += GPL
endif

# Add Unknown license if Unknown licensed plugins enabled.
ifeq ($(GST1_PLUGINS_BAD_HAS_UNKNOWN_LICENSE),y)
GST1_PLUGINS_BAD_LICENSE += UNKNOWN
endif

# Use the following command to extract license info for plugins.
# # find . -name 'plugin-*.xml' | xargs grep license

$(eval $(autotools-package))
