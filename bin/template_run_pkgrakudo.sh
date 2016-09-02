#!/bin/bash -e

# Run with sudo if necessary.
# Parameters are the version strings of MOARVM, NQP, RAKUDO 
# and the REVISION number

VERSION_MOARVM=$1
VERSION_NQP=$2
VERSION_RAKUDO=$3
REVISION=$4

# Functions
function die { 
    echo "$1"
    exit 1
}

# Variables supplied to docker run
ERROR=""
[ -z "$VERSION_MOARVM" ] && ERROR+=$'MoarVM version not defined\n'
[ -z "$VERSION_NQP"    ] && ERROR+=$'NQP version not defined\n'
[ -z "$VERSION_RAKUDO" ] && ERROR+=$'Rakudo version not defined\n'
[ -z "$REVISION"       ] && ERROR+=$'Revision not defined\n'
if [ ! -z "$ERROR" ]; then die "$ERROR"; fi

IMAGE=$(echo $(basename -s .sh $0) |cut -d_ -f2-)

docker run -ti --rm \
-v $(pwd)/../pkgs:/pkgs \
-e VERSION_MOARVM=$VERSION_MOARVM \
-e VERSION_NQP=$VERSION_NQP \
-e VERSION_RAKUDO=$VERSION_RAKUDO \
-e REVISION=$REVISION \
rakudo/$IMAGE
