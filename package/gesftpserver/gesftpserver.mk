#############################################################
#
# gesftpserver
#
#############################################################

GESFTPSERVER_VERSION = 0.1
GESFTPSERVER_SOURCE = sftpserver-$(GESFTPSERVER_VERSION).tar.gz
GESFTPSERVER_SITE = http://www.greenend.org.uk/rjk/sftpserver/
GESFTPSERVER_LICENSE = GPLv2+
GESFTPSERVER_LICENSE_FILES = COPYING
# forgets to link against pthread when cross compiling
GESFTPSERVER_CONF_ENV = LIBS=-lpthread

# overwrite openssh version if enabled
GESFTPSERVER_DEPENDENCIES += \
	$(if $(BR2_ENABLE_LOCALE),,libiconv) \
	$(if $(BR2_PACKAGE_OPENSSH),openssh)

# openssh/dropbear looks here
define GESFTPSERVER_ADD_SYMLINK
	ln -sf gesftpserver $(TARGET_DIR)/usr/libexec/sftp-server
endef

GESFTPSERVER_POST_INSTALL_TARGET_HOOKS += GESFTPSERVER_ADD_SYMLINK

$(eval $(autotools-package))
