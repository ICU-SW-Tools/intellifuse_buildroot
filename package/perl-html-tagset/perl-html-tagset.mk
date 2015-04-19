################################################################################
#
# perl-html-tagset
#
################################################################################

PERL_HTML_TAGSET_VERSION = 3.20
PERL_HTML_TAGSET_SOURCE = HTML-Tagset-$(PERL_HTML_TAGSET_VERSION).tar.gz
PERL_HTML_TAGSET_SITE = $(BR2_CPAN_MIRROR)/authors/id/P/PE/PETDANCE
PERL_HTML_TAGSET_DEPENDENCIES = perl
PERL_HTML_TAGSET_LICENSE = Artistic or GPLv1+
PERL_HTML_TAGSET_LICENSE_FILES = README

$(eval $(perl-package))
