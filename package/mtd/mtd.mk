ifeq ($(BR2_PACKAGE_MTD_UTILS),y)
include package/mtd/mtd-utils/mtd.mk
endif
ifeq ($(BR2_PACKAGE_MTD_UTILS_GIT),y)
include package/mtd/mtd-utils.git/mtd.mk
endif
