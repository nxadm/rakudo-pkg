#!/bin/sh -e 
set -xv

. config/versions.sh

if [ `echo $NFPM_VERSION | grep '^@'` ]; then
    COMMIT=`echo $NFPM_VERSION | cut -c2-`
    curl -sSL -o nfpm.tar.gz \
    https://github.com/goreleaser/nfpm/tarball/$COMMIT
    else
        curl -sSL -o nfpm.tar.gz \
https://github.com/goreleaser/nfpm/releases/download/v$NFPM_VERSION/nfpm_${NFPM_VERSION}_Linux_x86_64.tar.gz
fi

if [ `echo $MOARVM_VERSION | grep '^@'` ]; then
    COMMIT=`echo $MOARVM_VERSION | cut -c2-`
    curl -sSL -o moarvm.tar.gz \
    https://github.com/MoarVM/MoarVM/tarball/$COMMIT
    else
        curl -sSL -o moarvm.tar.gz \
https://github.com/MoarVM/MoarVM/releases/download/$MOARVM_VERSION/MoarVM-${MOARVM_VERSION}.tar.gz
fi

if [ `echo $NQP_VERSION | grep '^@'` ]; then
    COMMIT=`echo $NQP_VERSION | cut -c2-`
    curl -sSL -o nqp.tar.gz \
    https://github.com/Raku/nqp/tarball/$COMMIT
    else
        curl -sSL -o nqp.tar.gz \
https://github.com/Raku/nqp/releases/download/$NQP_VERSION/nqp-${NQP_VERSION}.tar.gz
fi

if [ `echo $RAKUDO_VERSION | grep '^@'` ]; then
    COMMIT=`echro $RAKUDO_VERSION | cut -c2-`
    curl -sSL -o rakudo.tar.gz \
    https://github.com/rakudo/rakudo/tarball/$COMMIT
    else
        curl -sSL -o rakudo.tar.gz \
https://github.com/rakudo/rakudo/releases/download/$RAKUDO_VERSION/rakudo-${RAKUDO_VERSION}.tar.gz
fi

if [ `echo $ZEF_VERSION | grep '^@'` ]; then
    COMMIT=`echro $ZEF_VERSION | cut -c2-`
    curl -sSL -o zef.tar.gz \
    https://github.com/ugexe/zef/tarball/$COMMIT
    else
        curl -sSL -o zef.tar.gz \
https://github.com/ugexe/zef/archive/v${ZEF_VERSION}.tar.gz
fi

ls -laH *.tar.gz
