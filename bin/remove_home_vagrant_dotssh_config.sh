#!/usr/bin/env bash

DOTSSH_CONFIG="/home/vagrant/.ssh/config"

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

remove_config_file_change() {
    local config_file=$1
    local config_pattern=$2

    sed -i "/${config_pattern}/d" ${config_file}
#    grep -v -e "${config_pattern}" ${config_file} > ${config_file}.$$
#    mv ${config_file}.$$ ${config_file}
}

check_remove_verify() {
    local config_file=$1
    local config_pattern=$2
    local config_value=$3

    if [[ $(is_config_file_updated "${config_file}" "${config_pattern}" "${config_value}") -eq 0 ]]; then
        remove_config_file_change "${config_file}" "${config_pattern}"
        if [[ $(is_config_file_updated "${config_file}" "${config_pattern}" "${config_value}") -eq 1 ]]; then
            echo "${config_file} ${config_value} removed"
        else
            echo "Error: ${config_file} ${config_value} remove failed"
            exit 1
        fi
    else
        echo "${config_file} ${config_value} already removed"
    fi
}

require_running_as_root
check_remove_verify "${DOTSSH_CONFIG}" "^Host" "Host *"
check_remove_verify "${DOTSSH_CONFIG}" "^    ServerAliveInterval" "    ServerAliveInterval 10" # for testing
