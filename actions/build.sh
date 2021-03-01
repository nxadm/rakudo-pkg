#!/bin/sh -e
set -xv

CONFIG_SHELL=/bin/bash
INSTALL_ROOT=/opt/rakudo-pkg
PATH=$PATH:$INSTALL_ROOT/bin
export CONFIG_SHELL INSTALL_ROOT

if [ -z "$DEVBUILD" ]; then
    . config/setup.sh
    MOARVM_CONFIGURE="perl ./Configure.pl --relocatable --prefix=$INSTALL_ROOT"
    NQP_CONFIGURE="perl ./Configure.pl --relocatable --backends=moar --prefix=$INSTALL_ROOT"
    RAKUDO_CONFIGURE="perl ./Configure.pl --relocatable --backends=moar --prefix=$INSTALL_ROOT"
fi

if [ ! -z "$SEARCH_REPLACE" ]; then
    $SEARCH_REPLACE
fi

if [ ! -z "$EXTRA_ENV" ]; then
    OIFS="$IFS"
    IFS=";"
    for i in $EXTRA_ENV; do
        export $i
    done
    IFS="$OIFS"
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

# Install zef source
mkdir -p $INSTALL_ROOT/var/zef
tar xzf zef.tar.gz -C $INSTALL_ROOT/var/zef --strip-components=1

# Workaround ugly rakudo/zef bug
# https://github.com/nxadm/rakudo-pkg/issues/78
mkdir -p $INSTALL_ROOT/share/perl6/site/short $INSTALL_ROOT/share/perl6/vendor/short

# Add extra scripts and directories
cd include
chmod +x *
for i in *; do
    cp $i $INSTALL_ROOT/bin
done
