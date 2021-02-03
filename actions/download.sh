#!/bin/sh -e
set -xv

DIR=`pwd`
if [ -z "$DEVBUILD" ]; then
    . config/pkginfo.sh
    . config/setup.sh
    curl -sSL -o nfpm.tar.gz \
https://github.com/goreleaser/nfpm/releases/download/v$NFPM_RELEASE/nfpm_${NFPM_RELEASE}_Linux_x86_64.tar.gz
fi

git clone --recurse-submodules https://github.com/moarvm/moarvm.git
if [ $MOARVM_VERSION != "HEAD" ]; then
    cd moarvm 
    git checkout $MOARVM_VERSION
    cd ..
fi    

git clone --recurse-submodules https://github.com/raku/nqp.git
if [ $NQP_VERSION != "HEAD" ]; then
    cd nqp 
    git checkout $NQP_VERSION
    cd ..
fi

git clone --recurse-submodules https://github.com/rakudo/rakudo.git
if [ $RAKUDO_VERSION != "HEAD" ]; then
    cd rakudo
    git checkout $RAKUDO_VERSION
    cd ..
fi

git clone --recurse-submodules https://github.com/ugexe/zef.git zef
if [ $ZEF_VERSION != "HEAD" ]; then
    cd zef
    git checkout $ZEF_VERSION
    cd ..
fi

cd $DIR
ls -laH
for i in $DIR/moarvm nqp rakudo zef; do
    find $i -name ".git" -exec rm -rf {} \;
    tar czf $i.tar.gz $i
done

ls -laH *.tar.gz
