#!/usr/bin/env bash

SCRIPT="install_rvm_prereqs_centos6.sh"

echo "${SCRIPT}: start - $(date)"

yum -y update
yum -y groupinstall development
yum -y install libyaml-devel libffi-devel readline-devel zlib-devel openssl-devel sqlite-devel

echo "${SCRIPT}: finish - $(date)"
