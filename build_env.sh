#!/bin/sh -e
set -xv

if [ `grep ^ID=alpine /etc/os-release` ]; then
    OS=alpine
    OS_VERSION=`grep "PRETTY_NAME=" /etc/os-release | cut -dv -f2`
    apk update
    apk upgrade
	apk add build-base perl perl-utils gzip tar
fi

if [ `grep ^ID=debian /etc/os-release` ]; then
    OS=debian
fi

if [ `grep ^ID=ubuntu /etc/os-release` ]; then
    OS=ubuntu
fi

if [ $OS == "debian" ] || [ $OS == "ubuntu" ]; then
    OS_VERSION=`grep "VERSION_ID=" /etc/os-release | cut -d= -f2`
    OS_CODENAME=`grep "VERSION_CODENAME=" /etc/os-release | cut -d= -f2`
    apt-get update
    apt-get -u dist-upgrade -y -qq
    apt-get install -y build-essential
fi


echo "export OS=$OS" >> /etc/profile 
echo "export OS_VERSION=$OS_VERSION" >> /etc/profile 
if [ ! -z $OS_CODENAME ]; then
    echo "export OS_CODENAME=$OS_CODENAME" >> /etc/profile 
fi
cat versions.sh >> /etc/profile

