#!/bin/sh -e
set -xv

CONFIG_SHELL=/bin/bash
INSTALL_ROOT=/opt/rakudo-pkg
PATH=$PATH:$INSTALL_ROOT/bin
export CONFIG_SHELL INSTALL_ROOT

if [ -z "$DEBUG_BUILD" ]; then
    . config/setup.sh
    MOARVM_CONFIGURE="perl ./Configure.pl --prefix=$INSTALL_ROOT --relocatable"
    NQP_CONFIGURE="perl ./Configure.pl --prefix=$INSTALL_ROOT --relocatable --backends=moar"
    RAKUDO_CONFIGURE="perl ./Configure.pl --prefix=$INSTALL_ROOT --relocatable --backends=moar"
    elif [ ! -z $SEARCH_REPLACE ]; then
        $SEARCH_REPLACE
fi

# Build rakudo
for i in moarvm nqp rakudo; do
    case $i in
    moarvm)
        CONFIGURE=$MOARVM_CONFIGURE
        ;;
    nqp)
        CONFIGURE=$NQP_CONFIGURE
        ;;
    rakudo)
        CONFIGURE=$RAKUDO_CONFIGURE
        ;;
    esac

    mkdir $i
    tar xzf $i.tar.gz -C $i --strip-components=1
    cd $i
    $CONFIGURE
    make
    make test
    make install
    cd ..
done

raku -v

# Install zef
mkdir zef
tar xzf zef.tar.gz -C zef --strip-components=1
cd zef
$INSTALL_ROOT/bin/raku -I. bin/zef --install-to=core install .
ln -s $INSTALL_ROOT/share/perl6/core/bin/zef $INSTALL_ROOT/bin/zef
zef --version
cd ..

# Add extra scripts
cd include
for i in *; do
    cp $i $INSTALL_ROOT/bin
done
