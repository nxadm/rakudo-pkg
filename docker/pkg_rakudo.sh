#!/bin/bash -e

# Functions
function die { 
    echo "$1"
    exit 1
}

# Variables supplied by docker run
ERROR=""
[ -z "$VERSION_MOARVM" ] && ERROR+=$'VERSION_MOARVM not defined\n'
[ -z "$VERSION_NQP"    ] && ERROR+=$'VERSION_NQP not defined\n'
[ -z "$VERSION_RAKUDO" ] && ERROR+=$'VERSION_RAKUDO not defined\n'
[ -z "$REVISION"       ] && ERROR+=$'REVISION not defined\n'
if [ ! -z "$ERROR" ]; then die "$ERROR"; fi

MAINTAINER=${MAINTAINER:-"Claudio Ramirez <pub.claudio@gmail.com>"}

# Internal variables
VERSION_PKG=$(perl -lwe "@part=split(/\D/, \"$VERSION_RAKUDO\"); printf('%d%02d%02d_%d', @part, $REVISION)")
URL_MOARVM=http://moarvm.org/releases/MoarVM-${VERSION_MOARVM}.tar.gz
URL_NQP=http://rakudo.org/downloads/nqp/nqp-${VERSION_NQP}.tar.gz
URL_RAKUDO=http://rakudo.org/downloads/rakudo/rakudo-${VERSION_RAKUDO}.tar.gz
PREFIX=/opt/rakudo
if [ -f "/etc/debian_version" ]; then
    TARGET=deb
elif [ -f "/etc/redhat-release" ]; then 
    TARGET="rpm"
else
    TARGET="UNKNOWN"
fi

# Download and compile sources
# TODO: get the source on a https connection
# (see https://rt.perl.org/Ticket/Display.html?id=128423)
for i in $URL_MOARVM $URL_NQP $URL_RAKUDO; do wget $i; done 
for i in *.tar.gz; do tar xvzf $i; done
cd /MoarVM*; perl Configure.pl --prefix=$PREFIX
make && make install
cd /nqp-*; perl Configure.pl --backends=moar --prefix=$PREFIX
make && make test && make install
cd /rakudo-*; perl Configure.pl --backends=moar --prefix=$PREFIX
make && make test && make install
mv /install_*.sh $PREFIX/bin
cd /
rm -rf /MoarVM* /nqp* /rakudo* 
echo "Rakudo was succesfully compiled."

# Packaging
OS=$(lsb_release -is)
RELEASE=$(lsb_release -rs)
PKGDIR="/pkgs/$OS/$RELEASE"
if [ ! -d "$PKGDIR" ]; then mkdir -p "$PKGDIR"; fi
fpm \
--deb-no-default-config-files \
--license "Artistic License 2.0" \
--description "Rakudo is a compiler for the Perl 6 programming language" \
-s dir \
-t $TARGET \
-p $PKGDIR \
-n perl6-rakudo-moarvm \
-m "$MAINTAINER" \
-v $VERSION_PKG \
/opt/rakudo

