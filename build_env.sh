#!/bin/sh -e
set -xv

OS=`grep ^ID= /etc/os-release | cut -d= -f2`

set_os_vars() {
    OS_VERSION=`perl -lwn -e 'if (/PRETTY_NAME/) { s/^.+\sv*([\w\d.]+)\b.+/$1/; print }' /etc/os-release`
    OS_CODENAME=`perl -lwn -e 'if (/VERSION_CODENAME/) { s/^.+=(.+)/$1/; print }' /etc/os-release`
    echo export OS=$OS >> versions.sh 
    echo export OS_VERSION=$OS_VERSION >> versions.sh
    echo export OS_CODENAME=$OS_CODENAME >> versions.sh
}
case "$OS" in 
    alpine)
        apk update
        apk upgrade
	    apk add build-base perl perl-utils gzip tar
    ;;
    centos)
    yum -q -y upgrade
    yum -q -y groupinstall 'Development Tools'
    yum -q -y install perl perl-autodie perl-Digest-SHA perl-ExtUtils-Command perl-IPC-Cmd
    ;;
    debian)
        apt-get update
        apt-get -u dist-upgrade -y -qq
        apt-get install -y build-essential
    ;;
    fedora)
    ;;
    opensuse)
    ;;
    rhel)
    ;;
    ubuntu)
        apt-get update
        apt-get -u dist-upgrade -y -qq
        apt-get install -y build-essential
    ;;
    *)
        echo "Sorry, distro not found. Send a PR. :)"
        exit 1
    ;;
esac    

set_os_vars
cat versions.sh >> /etc/profile

