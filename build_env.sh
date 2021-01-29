#!/bin/sh
set -xv

if [ `grep alpine /etc/os-release | wc -l` > 0 ]; then
	apk add build-base perl perl-utils gzip tar
    export OS=alpine
    export OS_VERSIO=`grep "VERSION_ID=" /etc/os-release | cut -d= -f2`
fi
