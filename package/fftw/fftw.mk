################################################################################
#
# fftw
#
################################################################################

FFTW_VERSION = 3.3
FFTW_SITE = http://www.fftw.org
FFTW_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package,fftw))
