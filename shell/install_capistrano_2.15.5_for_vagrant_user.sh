#!/usr/bin/env bash

SCRIPT="install_capistrano_2.15.5_for_vagrant_user.sh"

echo "${SCRIPT}: start - $(date)"

su -l -c "cp -f /vagrant/Gemfile_ruby233 ./Gemfile; bundle install" vagrant

echo "${SCRIPT}: finish - $(date)"
