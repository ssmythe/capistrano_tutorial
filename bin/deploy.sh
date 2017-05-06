#!/usr/bin/env bash

DEBUG=0

usage() {
    cat - <<END_OF_USAGE
Usage: $(basename $0): {module} {task} {arg1} [arg2] [arg3]

package:
package install <package>
package remove  <package>

template render  <template> <properties> <output>

service:
service enable  <service>
service disable <service>
service start   <service>
service stop    <service>

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

verify_perl_available() {
    if [[ ! -x /usr/bin/perl ]]; then
        error "$(basename $0): perl must be installed" 0 1
    fi
}


###########
# PACKAGE #
###########

is_package_name_valid() {
    if [[ ! -z ${arg1} ]]; then
        echo 0
    else
        echo 1
    fi
}

is_package_installed() {
    # 0=yes, 1=no
    case $(is_package_name_valid) in
        0)
            yum -q list installed ${arg1} 1>/dev/null 2>&1; echo $?
            ;;
        *)
            error "package_verify(): invalid package_name" 0 1
            ;;
    esac
}

package_install() {
    if [[ $(is_package_installed) -eq 0 ]]; then
        status "package ${verb} ${arg1}" "SKIP"
    else
        yum -y install ${arg1} 1>/dev/null 2>&1
        if [[ $(is_package_installed) -eq 1 ]]; then
            status "package ${verb} ${arg1}" "ERROR"
            error "unable to ${verb} package \"${arg1}\"" 0 1
        else
            status "package ${verb} ${arg1}" "OK"
        fi
    fi
}

package_removed() {
    if [[ $(is_package_installed) -eq 1 ]]; then
        status "package ${verb} ${arg1}" "SKIP"
    else
        yum -y remove ${arg1} 1>/dev/null 2>&1
        if [[ $(is_package_installed) -eq 0 ]]; then
            status "package ${verb} ${arg1}" "ERROR"
            error "unable to ${verb} package \"${arg1}\"" 0 1
        else
            status "package ${verb} ${arg1}" "OK"
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

############
# TEMPLATE #
############

is_template_name_valid() {
    if [[ ! -z ${arg1} ]]; then
        echo 0
    else
        echo 1
    fi
}

does_template_exist() {
    # 0=yes, 1=no
    test -f ${arg1}; echo $?
}

does_properties_exist() {
    # 0=yes, 1=no
    test -f ${arg2}; echo $?
}

does_output_exist() {
    # 0=yes, 1=no
    test -f ${arg3}; echo $?
}

template_pack_properties() {
    # "base64" to encode
    rm -f ${tmp_packed_props}
    cat ${arg2} | sed -e 's/=/ /' | while read k v
    do
         perl -e "print '${k}=' . unpack('H*', '${v}') . \"\n\"" >>${tmp_packed_props}
    done
}

template_cleanup_pack_properties() {
    rm -f ${tmp_packed_props}
}

template_render_actual() {
    output=$1

    # "base64 -d" to decode works as well
    template_pack_properties

    cp -f ${arg1} ${tmp_output}
    cat ${tmp_packed_props} | sed -e 's/=/ /' | while read k v
    do
        perl -pi -e "s{__${k}__}{pack('H*', '${v}')}eg" ${tmp_output}
    done

    template_cleanup_pack_properties
    mv -f ${tmp_output} ${output}
}

is_template_rendered() {
    # 0=yes, 1=no
    case $(is_template_name_valid) in
        0)
            template_render_actual ${tmp_compare_output}
            result=1
            if [[ -f ${arg3} ]]; then
                diff -q ${tmp_compare_output} ${arg3} 1>/dev/null 2>&1
                result=$?
            fi
            echo ${result}
            ;;
        *)
            error "is_template_rendered(): invalid template name: ${arg1}" 0 1
            ;;
    esac
}

template_render() {
    if [[ $(is_template_name_valid) -eq 0 && $(is_template_rendered) -eq 0 ]]; then
        status "service ${verb} ${arg1}" "SKIP"
    else
        mv -f ${tmp_compare_output} ${arg3}
        if [[ $(is_template_rendered) -eq 1 ]]; then
            status "template ${verb} ${arg1}" "ERROR"
            error "unable to ${verb} template \"${arg1}\"" 0 1
        else
            status "template ${verb} ${arg1}" "OK"
        fi
    fi
}

process_template() {
    case $verb in
        render)
            template_render
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
    if [[ ! -z ${arg1} ]]; then
        echo 0
    else
        echo 1
    fi
}

does_service_exist() {
    # 0=yes, 1=no
    case $(is_service_name_valid) in
        0)
            test -f /etc/init.d/${arg1}; echo $?
            ;;
        *)
            error "service_verify(): invalid service_name: ${arg1}" 0 1
            ;;
    esac
}

is_service_enabled() {
    # 0=yes, 1=no
    case $(is_service_name_valid) in
        0)
            chkconfig --list ${arg1} | grep ':on' | wc -l
            ;;
        *)
            error "service_verify(): invalid service_name: ${arg1}" 0 1
            ;;
    esac
}

is_service_running() {
    # 0=yes, 1=no
    case $(is_service_name_valid) in
        0)
            service ${arg1} status | grep -v running | wc -l
            ;;
        *)
            error "service_verify(): invalid service_name: ${arg1}" 0 1
            ;;
    esac
}

service_enable() {
    if [[ $(does_service_exist) -eq 0 && $(is_service_enabled) -eq 1 ]]; then
        status "service ${verb} ${arg1}" "SKIP"
    else
        chkconfig ${arg1} on 1>/dev/null 2>&1
        if [[ $(is_service_enabled) -eq 0 ]]; then
            status "service ${verb} ${arg1}" "ERROR"
            error "unable to ${verb} service \"${arg1}\"" 0 1
        else
            status "service ${verb} ${arg1}" "OK"
        fi
    fi
}

service_disable() {
    if [[ $(does_service_exist) -eq 0 && $(is_service_enabled) -eq 0 ]]; then
        status "service ${verb} ${arg1}" "SKIP"
    else
        chkconfig ${arg1} off 1>/dev/null 2>&1
        if [[ $(is_service_enabled) -eq 1 ]]; then
            status "service ${verb} ${arg1}" "ERROR"
            error "unable to ${verb} service \"${arg1}\"" 0 1
        else
            status "service ${verb} ${arg1}" "OK"
        fi
    fi
}

service_start() {
    if [[ $(does_service_exist) -eq 0 && $(is_service_running) -eq 0 ]]; then
        status "service ${verb} ${arg1}" "SKIP"
    else
        service ${arg1} start 1>/dev/null 2>&1
        if [[ $(is_service_running) -eq 1 ]]; then
            status "service ${verb} ${arg1}" "ERROR"
            error "unable to ${verb} service \"${arg1}\"" 0 1
        else
            status "service ${verb} ${arg1}" "OK"
        fi
    fi
}

service_stop() {
    if [[ $(does_service_exist) -eq 0 && $(is_service_running) -eq 1 ]]; then
        status "service ${verb} ${arg1}" "SKIP"
    else
        service ${arg1} stop 1>/dev/null 2>&1
        if [[ $(is_service_running) -eq 0 ]]; then
            status "service ${verb} ${arg1}" "ERROR"
            error "unable to ${verb} service \"${arg1}\"" 0 1
        else
            status "service ${verb} ${arg1}" "OK"
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
    arg1=$3
    arg2=$4
    arg3=$5

    tmp_packed_props=/tmp/$(basename $0).property.$$.tmp
    tmp_compare_output=/tmp/$(basename $0).compare_output.$$.tmp
    tmp_output=/tmp/$(basename $0).output.$$.tmp

    case $object in
        package)
            process_package
            ;;
        template)
            process_template
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
    verify_perl_available
    process "$@"
}

main "$@"
