#!/bin/sh -e
set -xv

if [ -z "$DEBUG_BUILD" ]; then
    . config/pkginfo.sh
    . config/setup.sh
    curl -sSL -o nfpm.tar.gz \
https://github.com/goreleaser/nfpm/releases/download/v$NFPM_RELEASE/nfpm_${NFPM_RELEASE}_Linux_x86_64.tar.gz
fi

mkdir moarvm nqp rakudo zef

git clone --recurse-submodules https://github.com/MoarVM/MoarVM.git moarvm
cd moarvm 
if [ $MOARVM_VERSION != "HEAD" ]; then
    git checkout $MOARVM_VERSION
fi    
rm -rf moarvm/.git
cd ..
tar cvzf moarvm.tar.gz moarvm

git clone --recurse-submodules https://github.com/Raku/nqp.git nqp
cd nqp 
if [ $NQP_VERSION != "HEAD" ]; then
    git checkout $NQP_VERSION
fi    
rm -rf moarvm/.git
cd ..
tar cvzf nqp.tar.gz nqp

git clone --recurse-submodules https://github.com/rakudo/rakudo.git rakudo
cd rakudo
if [ $RAKUDO_VERSION != "HEAD" ]; then
    git checkout $RAKUDO_VERSION
fi    
rm -rf rakudo/.git
cd ..
tar cvzf rakudo.tar.gz rakudo

git clone --recurse-submodules https://github.com/ugexe/zef.git zef
cd zef
if [ $ZEF_VERSION != "HEAD" ]; then
    git checkout $ZEF_VERSION
fi    
rm -rf zef/.git
cd ..
tar cvzf zef.tar.gz zef

ls -laH *.tar.gz
