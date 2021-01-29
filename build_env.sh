#!/bin/sh
set -xv

if [ `grep alpine /etc/os-release | wc -l` > 0 ]; then
	apk add build-base perl perl-utils gzip tar
    export OS=alpine
    export OS_VERSION=`grep "PRETTY_NAME=" /etc/os-release | cut -dv -f2`
fi

cat versions.sh >> /etc/profile
