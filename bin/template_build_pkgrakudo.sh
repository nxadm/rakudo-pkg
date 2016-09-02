#!/bin/bash -e

# Run with sudo if necessary.
# Supply the OS version as the first parameter.
# If you have a DockerID you can pass it as the first parameter, otherwise
# nxadm (mine) is the default.

VERSION=$1
if [ -z "$VERSION" ]; then
    echo "Supply the OS version as the first parameter."
    exit 1
fi
DOCKERID=$2
DOCKERID=${DOCKERID:-"rakudo"}

IMAGE=$( echo $(basename -s .sh $0) |cut -d_ -f2-)
cd ../docker
docker build -f Dockerfile-$IMAGE -t $DOCKERID/$IMAGE:$VERSION .
