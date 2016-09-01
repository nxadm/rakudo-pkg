#!/bin/bash -e

# Run with sudo if necessary.
# If you have a DockerID you can pass it as the first parameter, otherwise
# nxadm (mine) is the default.

DOCKERID=${DOCKERID:-"nxadm"}
IMAGE=$( echo $(basename -s .sh $0) |cut -d_ -f2-)
cd ../docker
docker build -f Dockerfile-$IMAGE -t $DOCKERID/$IMAGE .
