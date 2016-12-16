#!/usr/bin/env bash

SCRIPT="accept_known_hosts_ssh_fingerprints.sh"
SSH_DIR="/home/vagrant/.ssh"
KNOWN_HOSTS_FILE="${SSH_DIR}/known_hosts"

accept_known_host_ssh_fingerprint() {
    hostname=$1

    touch "${KNOWN_HOSTS_FILE}"
    if ! grep -q "^${hostname}" "${KNOWN_HOSTS_FILE}"; then
        ssh -o StrictHostKeyChecking=no ${hostname} 'hostname -f' || true
        echo ${KNOWN_HOSTS_FILE}: adding ${hostname} [ADDED]
    else
        echo ${KNOWN_HOSTS_FILE}: adding ${hostname} [SKIPPED]
    fi
}

echo "${SCRIPT}: start - $(date)"

accept_known_host_ssh_fingerprint 'captut'
accept_known_host_ssh_fingerprint 'capalpha'
accept_known_host_ssh_fingerprint 'capbravo'

echo "${SCRIPT}: finish - $(date)"
