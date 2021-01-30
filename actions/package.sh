#!/bin/sh -e
set -xv

. ./versions.sh

# Install nfpm
tar xzf nfpm.tar.gz nfpm
mv nfpm /usr/bin


