################################################################################
#
# wsapi-fcgi
#
################################################################################

WSAPI_FCGI_VERSION_MAJOR = 1.6.1
WSAPI_FCGI_VERSION = $(WSAPI_FCGI_VERSION_MAJOR)-1
WSAPI_FCGI_SUBDIR = wsapi-$(WSAPI_FCGI_VERSION_MAJOR)
WSAPI_FCGI_DEPENDENCIES = libfcgi
WSAPI_FCGI_LICENSE = MIT

$(eval $(luarocks-package))
