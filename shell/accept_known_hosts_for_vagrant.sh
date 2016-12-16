#!/usr/bin/env bash

SCRIPT="accept_known_hosts_for_vagrant.sh"

echo "${SCRIPT}: start - $(date)"

su -l -c "bash /vagrant/shell/accept_known_hosts_ssh_fingerprints.sh" vagrant

echo "${SCRIPT}: finish - $(date)"
