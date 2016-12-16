#!/usr/bin/env bash

SCRIPT="install_ruby_2.3.3_for_vagrant_user.sh"

echo "${SCRIPT}: start - $(date)"

su -l -c "bash /vagrant/shell/install_ruby_2.3.3_via_rvm_no_docs.sh" vagrant

echo "${SCRIPT}: finish - $(date)"
