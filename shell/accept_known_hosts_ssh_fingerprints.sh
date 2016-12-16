#!/usr/bin/env bash

SSH_DIR="/home/vagrant/.ssh"
KNOWN_HOSTS_FILE="${SSH_DIR}/known_hosts"

accept_known_host_ssh_fingerprint() {
    hostname=$1

    touch "${KNOWN_HOSTS_FILE}"
    if ! grep -q "^${hostname}" "${KNOWN_HOSTS_FILE}"; then
        ssh -o StrictHostKeyChecking=no ${hostname} 'hostname -f'
        echo ${KNOWN_HOSTS_FILE}: adding ${hostname} [ADDED]
    else
        echo ${KNOWN_HOSTS_FILE}: adding ${hostname} [SKIPPED]
    fi
}

accept_known_host_ssh_fingerprint 'captut'
accept_known_host_ssh_fingerprint 'capalpha'
accept_known_host_ssh_fingerprint 'capbravo'
