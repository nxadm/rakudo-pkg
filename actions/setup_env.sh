#!/bin/sh -e
# Prepare the images to compile and package Rakudo
# https://github.com/nxadm/rakudo-pkg
set -xv

OS=`grep ^ID= /etc/os-release | cut -d= -f2 | cut -d\" -f2| cut -d- -f1`

set_os_vars() {
    ARCH=$1
    OS_VERSION=`echo $IMAGE| perl -lwp -e 's/^.+[:\/](?:ubi)*([.\w+\d+]+).*/$1/'`
    OS_CODENAME=`perl -lwn -e 'if (/^VERSION_CODENAME=/) { s/^.+=(.+)/$1/; print }' /etc/os-release`
    if [ -z "$OS_CODENAME" ]; then
        OS_CODENAME=$OS_VERSION
    fi   

    echo ARCH=$ARCH >> config/versions.sh 
    echo OS=$OS >> config/versions.sh 
    echo OS_VERSION=$OS_VERSION >> config/versions.sh
    echo OS_CODENAME=$OS_CODENAME >> config/versions.sh
}

case "$OS" in 
    alpine)
        apk update
        apk upgrade
	    apk add bash build-base gettext gzip perl perl-utils tar zstd-dev
        set_os_vars x86_64
        ;;
    centos)
        yum -q -y upgrade
        yum -q -y groupinstall 'Development Tools'
        yum -q -y install libzstd-devel perl-core
        set_os_vars x86_64
        ;;
    debian)
        apt-get update
        apt-get -u dist-upgrade -y -qq
        apt-get install -y build-essential gettext libzstd-dev
        ;;
    fedora)
        dnf -q -y upgrade
        dnf -q -y groupinstall 'Development Tools'
        dnf -q -y install gettext libzstd-devel perl-core
        set_os_vars x86_64
        ;;
    opensuse)
        zypper refresh
        zypper update -y
        zypper install -y gcc gettext gzip make libzstd-devel perl tar
        set_os_vars x86_64
        ;;
    rhel)
        microdnf update
        microdnf install gettext gcc gzip make perl-core tar
        if [ $OS_VERSION = "8" ]; then
            microdnf install libzstd
        fi
        set_os_vars x86_64
        ;;
    ubuntu)
        apt-get update
        apt-get -u dist-upgrade -y -qq
        apt-get install -y build-essential gettext git libzstd-dev
        set_os_vars amd64
        ;;
    *)
        echo "Sorry, distro not found. Send a PR. :)"
        exit 1
        ;;
esac    

