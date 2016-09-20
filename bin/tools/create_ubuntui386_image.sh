#!/bin/bash
# Image to be pushed to docker hub as a base image for Ubuntu 16.04 i386 
# packages.
# Use sudo if appropiate

VERSION=$1
if [ -z "$VERSION" ]; then
    echo "Supply the Ubuntu version as a parameter"
    exit 1
fi
BASEURL="http://cdimage.ubuntu.com/ubuntu-base/releases/$VERSION/release"
FILE="ubuntu-base-${VERSION}-core-i386.tar.gz"
curl "$BASEURL/$FILE" | gunzip | docker import - nxadm/ubuntu-i386:$VERSION
