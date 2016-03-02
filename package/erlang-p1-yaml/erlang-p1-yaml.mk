################################################################################
#
# erlang-p1-yaml
#
################################################################################

ERLANG_P1_YAML_VERSION = 1.0.0
ERLANG_P1_YAML_SITE = $(call github,processone,p1_yaml,$(ERLANG_P1_YAML_VERSION))
ERLANG_P1_YAML_LICENSE = Apache-2.0
ERLANG_P1_YAML_LICENSE_FILES = COPYING
ERLANG_P1_YAML_DEPENDENCIES = libyaml erlang-p1-utils

$(eval $(rebar-package))
