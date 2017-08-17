#!/usr/bin/env bash

SCRIPT="install_capistrano_2.6.0_for_vagrant_user.sh"

echo "${SCRIPT}: start - $(date)"

su -l -c "cd /vagrant; bundle install" vagrant

echo "${SCRIPT}: finish - $(date)"
