#!/bin/sh -e
set -xv

set_os_vars() {
    OS=$1
    OS_VERSION=`perl -lwn -e 'if (/PRETTY_NAME/) { s/^.+\sv*([\w\d.]+)\b.+/$1/; print }' /etc/os-release`
    OS_CODENAME=`perl -lwn -e 'if (/VERSION_CODENAME/) { s/^.+=(.+)/$1/; print }' /etc/os-release`
    echo export OS=$OS >> versions.sh 
    echo export OS_VERSION=$OS_VERSION >> versions.sh
    echo export OS_CODENAME=$OS_CODENAME >> versions.sh
}

if [ `grep ^ID=alpine /etc/os-release` ]; then
    apk update
    apk upgrade
	apk add build-base perl perl-utils gzip tar
    set_os_vars alpine
fi

if [ `grep ^ID=debian /etc/os-release` ]; then
    OS=debian
fi

if [ `grep ^ID=ubuntu /etc/os-release` ]; then
    OS=ubuntu
fi

if [ "$OS" = "debian" ] || [ "$OS" = "ubuntu" ]; then
    apt-get update
    apt-get -u dist-upgrade -y -qq
    apt-get install -y build-essential
    OS_VERSION=`grep ^VERSION_ID= /etc/os-release | cut -d= -f2 | cut -d\" -f2`
    OS_CODENAME=`grep ^VERSION_CODENAME= /etc/os-release | cut -d= -f2`
fi


cat versions.sh >> /etc/profile

