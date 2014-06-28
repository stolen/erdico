PROJECT = erdico
ERLC_OPTS= "+{parse_transform, lager_transform}"

DEPS = cowboy lager
dep_cowboy = pkg://cowboy 0.10.0
dep_lager = https://github.com/basho/lager.git 2.0.3

include erlang.mk

deb:
	$(MAKE) -C pkg/$(PROJECT) deb
