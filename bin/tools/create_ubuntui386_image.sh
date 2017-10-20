#!/bin/bash
# Create Ubuntu i386 Docker base images. Use sudo if appropiate.
set -euo pipefail
VERSION=$@
if [ -z "$VERSION" ]; then
    echo "Supply the Ubuntu version as a parameter"
    exit 1
fi
BASEURL="http://cdimage.ubuntu.com/ubuntu-base/releases/$VERSION/release"
FILE="ubuntu-base-${VERSION}-base-i386.tar.gz"
curl "$BASEURL/$FILE" | gunzip | docker import - nxadm/ubuntu-i386:$VERSION
if [ $? -eq 0 ]; then
    echo "Docker image imported (run \"docker images\")."
    else exit $?
fi

