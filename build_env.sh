#!/bin/sh
set -xv

if [ `grep -i alpine /etc/*release` ]; then
    echo "Alpine!"
	apk add build-base perl perl-utils gzip tar
fi
