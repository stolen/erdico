#!/bin/sh

APP=erdico
LOG=/var/log/$APP
export HOME=/var/lib/$APP

export NL="
"
export RELX_REPLACE_OS_VARS=1   # Expand vars in config
export RUNNER_LOG_DIR=$LOG
export VMARGS_PATH=$HOME/vm.args
export CONFIG_PATH=$HOME/sys.config

# Read config
export CLUSTERNODES=$(sh -c '. /etc/'$APP'.conf; for h in $CLUSTERHOSTS; do echo "'\'$APP'@$h'\''"; done | paste -sd, -')
# save hostname
export FQDN=$(hostname -f)

exec `dirname $0`/$APP $@
