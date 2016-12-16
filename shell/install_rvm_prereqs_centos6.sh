#!/usr/bin/env bash

yum -y groupinstall development
yum -y install libyaml-devel libffi-devel readline-devel zlib-devel openssl-devel sqlite-devel
