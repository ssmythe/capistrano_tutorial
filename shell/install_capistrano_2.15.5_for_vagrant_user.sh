#!/usr/bin/env bash

SCRIPT="install_capistrano_2.15.5_for_vagrant_user.sh"

echo "${SCRIPT}: start - $(date)"

su -l -c "gem install capistrano --version 2.15.5" vagrant

echo "${SCRIPT}: finish - $(date)"
