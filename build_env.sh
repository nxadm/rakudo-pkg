#!/bin/sh
set -xv

RELEASE=`cat /etc/*release`

if [ `grep -i alpine /etc/*release` ]; then
	apk add build-base perl perl-utils gzip tar
fi


