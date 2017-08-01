#!/usr/bin/env bash

SCRIPT="install_capistrano_2.6.0_for_vagrant_user.sh"

echo "${SCRIPT}: start - $(date)"

su -l -c "gem install capistrano --version 2.6.0" vagrant

echo "${SCRIPT}: finish - $(date)"
