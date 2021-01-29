#!/bin/sh
set -xv

if [ `grep -i alpine /etc/*release | wc -l` > 0 ]; then
    echo "Alpine!"
	apk add build-base perl perl-utils gzip tar
fi
