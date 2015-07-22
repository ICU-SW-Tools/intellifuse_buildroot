################################################################################
#
# kodi-audioencoder-vorbis
#
################################################################################

KODI_AUDIOENCODER_VORBIS_VERSION = 15d619dae4411ecebadf2ec2996d611600ad0bee
KODI_AUDIOENCODER_VORBIS_SITE = $(call github,xbmc,audioencoder.vorbis,$(KODI_AUDIOENCODER_VORBIS_VERSION))
KODI_AUDIOENCODER_VORBIS_LICENSE = GPLv2+
KODI_AUDIOENCODER_VORBIS_LICENSE_FILES = src/EncoderVorbis.cpp
KODI_AUDIOENCODER_VORBIS_DEPENDENCIES = kodi libogg libvorbis
KODI_AUDIOENCODER_VORBIS_CONF_OPTS += \
	-DOGG_INCLUDE_DIRS=$(STAGING_DIR)/usr/include \
	-DVORBIS_INCLUDE_DIRS=$(STAGING_DIR)/usr/include \
	-DVORBISENC_INCLUDE_DIRS=$(STAGING_DIR)/usr/include

$(eval $(cmake-package))
