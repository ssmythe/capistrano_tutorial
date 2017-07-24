#!/usr/bin/env bash

DOTSSH_CONFIG="/home/vagrant/.ssh/config"
OWNER="vagrant"

require_running_as_root() {
    if [[ $(whoami) != "root" ]]; then
        echo "ERROR: must run as root"
        exit 1
    fi
}

is_config_file_updated() {
    local config_file=$1
    local config_pattern=$2
    local config_value=$3

    if [[ $(grep -e "${config_pattern}" "${config_file}") == "${config_value}" ]]; then
        echo 0
    else
        echo 1
    fi
}

apply_config_file_change() {
    local config_file=$1
    local config_value=$2

    echo "${config_value}" >> ${config_file}
}

check_apply_verify() {
    local config_file=$1
    local config_pattern=$2
    local config_value=$3

    if [[ $(is_config_file_updated "${config_file}" "${config_pattern}" "${config_value}") -eq 1 ]]; then
        apply_config_file_change "${config_file}" "${config_value}"
        if [[ $(is_config_file_updated "${config_file}" "${config_pattern}" "${config_value}") -eq 0 ]]; then
            echo "${config_file} ${config_value} updated"
        else
            echo "Error: ${config_file} ${config_value} update failed"
            exit 1
        fi
    else
        echo "${config_file} ${config_value} already updated"
    fi
    chown ${OWNER}:${OWNER} ${config_file}
}

require_running_as_root
check_apply_verify "${DOTSSH_CONFIG}" "^Host" "Host *"
check_apply_verify "${DOTSSH_CONFIG}" "^    ServerAliveInterval" "    ServerAliveInterval 10" # for testing
