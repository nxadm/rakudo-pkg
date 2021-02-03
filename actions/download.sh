#!/bin/sh -e
set -xv

if [ -z "$DEBUG_BUILD" ]; then
    . config/pkginfo.sh
    . config/setup.sh
    curl -sSL -o nfpm.tar.gz \
https://github.com/goreleaser/nfpm/releases/download/v$NFPM_RELEASE/nfpm_${NFPM_RELEASE}_Linux_x86_64.tar.gz
fi


curl -sSL -o moarvm.tar.gz https://github.com/MoarVM/MoarVM/tarball/$MOARVM_VERSION
curl -sSL -o nqp.tar.gz https://github.com/Raku/nqp/tarball/$NQP_VERSION
curl -sSL -o rakudo.tar.gz https://github.com/rakudo/rakudo/tarball/$RAKUDO_VERSION
curl -sSL -o rakudo.tar.gz https://github.com/ugexe/zef/tarball/$ZEF_VERSION
ls -laH *.tar.gz
