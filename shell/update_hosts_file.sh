#!/usr/bin/env bash

SCRIPT="update_hosts_file.sh"

add_host() {
    hostname=$1
    ip=$2

    if ! grep -q "${hostname}$" /etc/hosts; then
        echo "${ip} ${hostname}" >> /etc/hosts
        echo /etc/hosts: adding ${hostname} [ADDED]
    else
        echo /etc/hosts: adding ${hostname} [SKIPPED]
    fi
}

echo "${SCRIPT}: start - $(date)"

add_host 'captut' '10.0.0.101'
add_host 'capalpha' '10.0.0.102'
add_host 'capbravo' '10.0.0.103'

echo "${SCRIPT}: finish - $(date)"
