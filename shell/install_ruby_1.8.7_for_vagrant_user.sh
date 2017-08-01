#!/usr/bin/env bash

SCRIPT="install_ruby_1.8.7_for_vagrant_user.sh"

echo "${SCRIPT}: start - $(date)"

su -l -c "bash /vagrant/shell/install_ruby_1.8.7_via_rvm_no_docs.sh" vagrant

echo "${SCRIPT}: finish - $(date)"
