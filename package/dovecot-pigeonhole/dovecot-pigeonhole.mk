################################################################################
#
# dovecot-pigeonhole
#
################################################################################

DOVECOT_PIGEONHOLE_VERSION = 0.4.19
DOVECOT_PIGEONHOLE_SOURCE = dovecot-2.2-pigeonhole-$(DOVECOT_PIGEONHOLE_VERSION).tar.gz
DOVECOT_PIGEONHOLE_SITE = http://pigeonhole.dovecot.org/releases/2.2
DOVECOT_PIGEONHOLE_LICENSE = LGPL-2.1
DOVECOT_PIGEONHOLE_LICENSE_FILES = COPYING
DOVECOT_PIGEONHOLE_DEPENDENCIES = dovecot

DOVECOT_PIGEONHOLE_CONF_OPTS = --with-dovecot=$(STAGING_DIR)/usr/lib

$(eval $(autotools-package))
