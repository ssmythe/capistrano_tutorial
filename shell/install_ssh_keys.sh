#!/usr/bin/env bash

VAGRANT_CONFIG_DIR="/vagrant/config"
SSH_DIR="/home/vagrant/.ssh"
KEY_NAME="captut"

copy_key() {
    key_type=$1
    file_mode=$2
    source_key=$3
    target_key=$4

    if ! test -f "${target_key}"; then
        cp "${source_key}" "${target_key}"
        chown vagrant:vagrant "${target_key}"
        chmod "${file_mode}" "${target_key}"
        echo ${target_key}: adding ${key_type} SSH key [ADDED]
    else
        echo ${target_key}: adding ${key_type} SSH key [SKIPPED]
    fi
}

install_private_key() {
    source_private_key_file="${VAGRANT_CONFIG_DIR}/id_rsa"
    target_private_key_file="${SSH_DIR}/id_rsa"

    copy_key "private" "600" "${source_private_key_file}" "${target_private_key_file}"
}

install_public_key() {
    source_public_key_file="${VAGRANT_CONFIG_DIR}/id_rsa.pub"
    target_public_key_file="${SSH_DIR}/id_rsa.pub"

    copy_key "public" "644" "${source_public_key_file}" "${target_public_key_file}"
}

append_authorized_keys() {
    source_public_key_file="${VAGRANT_CONFIG_DIR}/id_rsa.pub"
    authorize_keys_file="${SSH_DIR}/authorized_keys"

    if ! grep -q "${KEY_NAME}$" ${authorize_keys_file}; then
        echo "" >> ${authorize_keys_file}
        cat ${source_key} >> ${authorize_keys_file}
        echo ${authorize_keys_file}: adding ${key_type} SSH key for ${KEY_NAME} [ADDED]
    else
        echo ${authorize_keys_file}: adding ${key_type} SSH key for ${KEY_NAME} [SKIPPED]
    fi
}

install_private_key
install_public_key
append_authorized_keys
