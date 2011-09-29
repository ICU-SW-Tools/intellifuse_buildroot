################################################################################
#
# portaudio
#
################################################################################

PORTAUDIO_VERSION = V19
PORTAUDIO_SITE = http://www.portaudio.com/archives
PORTAUDIO_SOURCE = pa_stable_v19_20110326.tgz
PORTAUDIO_INSTALL_STAGING = YES
PORTAUDIO_MAKE = $(MAKE1)

PORTAUDIO_DEPENDENCIES = \
       $(if $(BR2_PACKAGE_PORTAUDIO_WITH_ALSA),alsa-lib)

PORTAUDIO_CONF_OPT = \
       $(if $(BR2_PACKAGE_PORTAUDIO_ALSA),--with-alsa,--without-alsa) \
       $(if $(BR2_PACKAGE_PORTAUDIO_OSS),--with-oss,--without-oss) \
       $(if $(BR2_PACKAGE_PORTAUDIO_CXX),--enable-cxx,--disable-cxx)

$(eval $(call AUTOTARGETS))
