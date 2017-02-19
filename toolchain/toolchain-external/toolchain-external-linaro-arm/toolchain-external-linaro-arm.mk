################################################################################
#
# toolchain-external-linaro-arm
#
################################################################################

TOOLCHAIN_EXTERNAL_LINARO_ARM_VERSION = 2017.02
TOOLCHAIN_EXTERNAL_LINARO_ARM_SITE = https://releases.linaro.org/components/toolchain/binaries/6.3-$(TOOLCHAIN_EXTERNAL_LINARO_ARM_VERSION)/arm-linux-gnueabihf

ifeq ($(HOSTARCH),x86)
TOOLCHAIN_EXTERNAL_LINARO_ARM_SOURCE = gcc-linaro-6.3.1-$(TOOLCHAIN_EXTERNAL_LINARO_ARM_VERSION)-i686_arm-linux-gnueabihf.tar.xz
else
TOOLCHAIN_EXTERNAL_LINARO_ARM_SOURCE = gcc-linaro-6.3.1-$(TOOLCHAIN_EXTERNAL_LINARO_ARM_VERSION)-x86_64_arm-linux-gnueabihf.tar.xz
endif

$(eval $(toolchain-external-package))
