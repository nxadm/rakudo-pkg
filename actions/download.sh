#!/bin/sh -e
set -xv

if [ -z "$DEVBUILD" ]; then
    . config/pkginfo.sh
    . config/setup.sh
    curl -sSL -o nfpm.tar.gz \
https://github.com/goreleaser/nfpm/releases/download/v$NFPM_RELEASE/nfpm_${NFPM_RELEASE}_Linux_x86_64.tar.gz
fi

git clone --recurse-submodules https://github.com/moarvm/moarvm.git
if [ $MOARVM_VERSION != "HEAD" ]; then
    cd moarvm 
    git clean -f -d
    git checkout $MOARVM_VERSION
    cd ..
fi

git clone --recurse-submodules https://github.com/raku/nqp.git
if [ $NQP_VERSION != "HEAD" ]; then
    cd nqp 
    git clean -f -d
    git checkout $NQP_VERSION
    cd ..
fi

git clone --recurse-submodules https://github.com/rakudo/rakudo.git
if [ $RAKUDO_VERSION != "HEAD" ]; then
    cd rakudo
    git clean -f -d
    git checkout $RAKUDO_VERSION
    cd ..
fi

git clone --recurse-submodules https://github.com/ugexe/zef.git zef
if [ $ZEF_VERSION != "HEAD" ]; then
    cd zef
    git clean -f -d
    git checkout $ZEF_VERSION
    cd ..
fi

for i in moarvm nqp rakudo zef; do
    tar czf $i.tar.gz --exclude-vcs $i 
done

ls -laH *.tar.gz
