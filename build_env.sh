#!/bin/sh -e
set -xv

if [ `grep ID=alpine /etc/os-release | wc -l` > 0 ]; then
    OS=alpine
    OS_VERSION=`grep "PRETTY_NAME=" /etc/os-release | cut -dv -f2`
    apk update
    apk upgrade
	apk add build-base perl perl-utils gzip tar
fi

if [ `grep ID=debian /etc/os-release | wc -l` > 0 ]; then
    OS=debian
    OS_VERSION=`grep "VERSION_ID=" /etc/os-release | cut -d= -f2`
    apt-get update
    apt-get -u dist-upgrade -y -qq
    apt-get install -y build-essential
fi

cat "export OS=$OS" >> /etc/profile 
cat "export OS_VERSION=$OS_VERSION" >> /etc/profile 
cat versions.sh >> /etc/profile

