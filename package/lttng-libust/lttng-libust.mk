LTTNG_LIBUST_SITE    = http://lttng.org/files/bundles/20111214/
LTTNG_LIBUST_VERSION = 1.9.2
LTTNG_LIBUST_SOURCE  = lttng-ust-$(LTTNG_LIBUST_VERSION).tar.gz

LTTNG_LIBUST_INSTALL_STAGING = YES
LTTNG_LIBUST_DEPENDENCIES    = liburcu util-linux

$(eval $(call AUTOTARGETS))
