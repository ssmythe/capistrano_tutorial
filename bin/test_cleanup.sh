#!/usr/bin/env bash
set -e

deploy() {
    /bin/bash /vagrant/bin/deploy.sh "$@"
}

# PACKAGE INSTALL
#deploy package install httpd
#deploy package install httpd
#deploy package install java-1.8.0-openjdk-1.8.0.121-1.b13.el6.x86_64
#deploy package install java-1.8.0-openjdk-1.8.0.121-1.b13.el6.x86_64

# SERVICE ENABLE
#chkconfig --list httpd
#deploy service enable httpd
#deploy service enable httpd
#chkconfig --list httpd

# SERVICE DISABLE
#deploy service disable httpd
#deploy service disable httpd
#chkconfig --list httpd

# SERVICE START
#/sbin/service httpd status || true
#deploy service start httpd
#sleep 1
#/sbin/service httpd status || true

# SERVICE STOP
#deploy service stop httpd
#sleep 1
#/sbin/service httpd status || true

# PACKAGE REMOVE
deploy package remove httpd
#deploy package remove httpd
#deploy package remove java-1.8.0-openjdk-1.8.0.121-1.b13.el6.x86_64
#deploy package remove java-1.8.0-openjdk-1.8.0.121-1.b13.el6.x86_64
