#!/bin/sh -e
set -xv

CONFIG_SHELL=/bin/bash
INSTALL_ROOT=/opt/rakudo-pkg
export CONFIG_SHELL INSTALL_ROOT

. config/setup.sh
PATH=$PATH:$INSTALL_ROOT/bin

if [ ! -z "$DEBUG_BUILD" ]; then
    echo "DEBUG_BUILD=true" >> $GITHUB_ENV
fi

# Build rakudo
for i in moarvm nqp rakudo; do
    mkdir $i
    tar xzf $i.tar.gz -C $i --strip-components=1
    CONFIGURE="perl ./Configure.pl --prefix=$INSTALL_ROOT --relocatable"
    if [ $i != "moarvm" ]; then
        CONFIGURE=$CONFIGURE" --backends=moar"
        elif [ ! -z "$DEBUG_BUILD"]; then
            CONFIGURE=$CONFIGURE" --debug --optimize=0"
            export HARNESS_VERBOSE=1
    fi 

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
