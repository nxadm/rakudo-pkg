#!/bin/sh -e
# Prepare the images to compile and package Rakudo
# https://github.com/nxadm/rakudo-pkg
set -xv

OS=`grep ^ID= /etc/os-release | cut -d= -f2 | cut -d\" -f2| cut -d- -f1`

set_os_vars() {
    OS_VERSION=`echo $IMAGE| perl -lwp -e 's/^.+[:\/](?:ubi)*([.\w+\d+]+).*/$1/'`
    OS_CODENAME=`perl -lwn -e 'if (/^VERSION_CODENAME=/) { s/^.+=(.+)/$1/; print }' /etc/os-release`
    if [ -z "$OS_CODENAME" ]; then
        OS_CODENAME=$OS_VERSION
    fi   

    echo export OS=$OS >> versions.sh 
    echo export OS_VERSION=$OS_VERSION >> versions.sh
    echo export OS_CODENAME=$OS_CODENAME >> versions.sh
}

case "$OS" in 
    alpine)
        apk update
        apk upgrade
	    apk add bash build-base gzip perl perl-utils tar zstd-dev
        ;;
    centos)
        yum -q -y upgrade
        yum -q -y groupinstall 'Development Tools'
        yum -q -y install libzstd-devel perl-core
        ;;
    debian)
        apt-get update
        apt-get -u dist-upgrade -y -qq
        apt-get install -y build-essential libzstd-dev
        ;;
    fedora)
        dnf -q -y upgrade
        dnf -q -y groupinstall 'Development Tools'
        dnf -q -y install libzstd-devel perl-core
        ;;
    opensuse)
       zypper refresh
       zypper update -y
       zypper install -y gcc gzip make libzstd-devel perl tar
        ;;
    rhel)
        microdnf update
        microdnf install gcc gzip libzstd-devel make perl-core tar
        ;;
    ubuntu)
        apt-get update
        apt-get -u dist-upgrade -y -qq
        apt-get install -y build-essential git libzstd-dev
        ;;
    *)
        echo "Sorry, distro not found. Send a PR. :)"
        exit 1
        ;;
esac    

set_os_vars
