#!/usr/bin/env bash

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

add_host 'captut' '10.0.0.101'
add_host 'capalpha' '10.0.0.102'
add_host 'capbravo' '10.0.0.103'
