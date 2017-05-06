#!/usr/bin/env bash

DEBUG=1

usage() {
    cat - <<END_OF_USAGE
$(basename $0): {module} {task} {arg}

package:
package install {package}
package remove  {package}

service:
service enable  {service}
service disable {service}
service start   {service}
service stop    {service}

END_OF_USAGE
}

debug() {
    message=$1

    if [[ DEBUG -eq 1 ]]; then
        echo "DEBUG: ${message}"
    fi
}

error() {
    message=$1
    display_usage=$2
    rc=$3
    echo "ERROR: ${message}"

    if [[ ${display_usage} = 1 ]]; then
        usage
    fi

    exit ${rc}
}

status() {
    message=$1
    status=$2

    pad=$(printf '%0.1s' "."{1..100})
    padlength=78
    printf '%s' "${message}"
    printf '%*.*s'  0 $((padlength - ${#message} - ${#status} - 2)) "$pad"
    printf '%s\n' "[${status}]"
}

verify_running_as_root() {
    if [[ $(whoami) != "root" ]]; then
        error "$(basename $0): must be run as root" 0 1
    fi
}


###########
# PACKAGE #
###########

is_package_name_valid() {
    if [[ ! -z ${arg} ]]; then
        echo 0
    else
        echo 1
    fi
}

is_package_installed() {
    # 0=yes, 1=no
    case $(is_package_name_valid) in
        0)
            yum -q list installed ${arg} 1>/dev/null 2>&1; echo $?
            ;;
        *)
            error "package_verify(): invalid package_name" 0 1
            ;;
    esac
}

package_install() {
    if [[ $(is_package_installed) -eq 0 ]]; then
        status "package ${verb} ${arg}" "SKIP"
    else
        yum -y install ${arg} 1>/dev/null 2>&1
        if [[ $(is_package_installed) -eq 1 ]]; then
            status "package ${verb} ${arg}" "ERROR"
            error "unable to ${verb} package \"${arg}\"" 0 1
        else
            status "package ${verb} ${arg}" "OK"
        fi
    fi
}

package_removed() {
    if [[ $(is_package_installed) -eq 1 ]]; then
        status "package ${verb} ${arg}" "SKIP"
    else
        yum -y remove ${arg} 1>/dev/null 2>&1
        if [[ $(is_package_installed) -eq 0 ]]; then
            status "package ${verb} ${arg}" "ERROR"
            error "unable to ${verb} package \"${arg}\"" 0 1
        else
            status "package ${verb} ${arg}" "OK"
        fi
    fi
}

process_package() {
    case $verb in
        install)
            package_install
            ;;
        remove)
            package_removed
            ;;
        *)
            error "unknown verb \"${verb}\" for object \"${object}\"" 1 1
            ;;
    esac
}

###########
# SERVICE #
###########

is_service_name_valid() {
    if [[ ! -z ${arg} ]]; then
        echo 0
    else
        echo 1
    fi
}

does_service_exist() {
    # 0=yes, 1=no
    case $(is_service_name_valid) in
        0)
            test -f /etc/init.d/${arg}; echo $?
            ;;
        *)
            error "service_verify(): invalid service_name: ${arg}" 0 1
            ;;
    esac
}

is_service_enabled() {
    # 0=yes, 1=no
    case $(is_service_name_valid) in
        0)
            chkconfig --list ${arg} | grep ':on' | wc -l
            ;;
        *)
            error "service_verify(): invalid service_name: ${arg}" 0 1
            ;;
    esac
}

is_service_running() {
    # 0=yes, 1=no
    case $(is_service_name_valid) in
        0)
            service ${arg} status | grep -v running | wc -l
            ;;
        *)
            error "service_verify(): invalid service_name: ${arg}" 0 1
            ;;
    esac
}

service_enable() {
    if [[ $(does_service_exist) -eq 0 && $(is_service_enabled) -eq 1 ]]; then
        status "service ${verb} ${arg}" "SKIP"
    else
        chkconfig ${arg} on 1>/dev/null 2>&1
        if [[ $(is_service_enabled) -eq 0 ]]; then
            status "service ${verb} ${arg}" "ERROR"
            error "unable to ${verb} service \"${arg}\"" 0 1
        else
            status "service ${verb} ${arg}" "OK"
        fi
    fi
}

service_disable() {
    if [[ $(does_service_exist) -eq 0 && $(is_service_enabled) -eq 0 ]]; then
        status "service ${verb} ${arg}" "SKIP"
    else
        chkconfig ${arg} off 1>/dev/null 2>&1
        if [[ $(is_service_enabled) -eq 1 ]]; then
            status "service ${verb} ${arg}" "ERROR"
            error "unable to ${verb} service \"${arg}\"" 0 1
        else
            status "service ${verb} ${arg}" "OK"
        fi
    fi
}

service_start() {
    if [[ $(does_service_exist) -eq 0 && $(is_service_running) -eq 0 ]]; then
        status "service ${verb} ${arg}" "SKIP"
    else
        service ${arg} start 1>/dev/null 2>&1
        if [[ $(is_service_running) -eq 1 ]]; then
            status "service ${verb} ${arg}" "ERROR"
            error "unable to ${verb} service \"${arg}\"" 0 1
        else
            status "service ${verb} ${arg}" "OK"
        fi
    fi
}

service_stop() {
    if [[ $(does_service_exist) -eq 0 && $(is_service_running) -eq 1 ]]; then
        status "service ${verb} ${arg}" "SKIP"
    else
        service ${arg} stop 1>/dev/null 2>&1
        if [[ $(is_service_running) -eq 0 ]]; then
            status "service ${verb} ${arg}" "ERROR"
            error "unable to ${verb} service \"${arg}\"" 0 1
        else
            status "service ${verb} ${arg}" "OK"
        fi
    fi
}

process_service() {
    case $verb in
        enable)
            service_enable
            ;;
        disable)
            service_disable
            ;;
        start)
            service_start
            ;;
        stop)
            service_stop
            ;;
        *)
            error "unknown verb \"${verb}\" for object \"${object}\"" 1 1
            ;;
    esac
}


###########
# PROCESS #
###########

process() {
    object=$1
    verb=$2
    arg=$3

    case $object in
        package)
            process_package
            ;;
        service)
            process_service
            ;;
        *)
            error "unknown object \"${object}\"" 1 1
            ;;
    esac
}

main() {
    verify_running_as_root
    process $1 $2 $3
}

main "$@"
