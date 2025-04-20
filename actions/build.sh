#!/bin/sh -e
set -xv

CONFIG_SHELL=/bin/bash
INSTALL_ROOT=/opt/rakudo-pkg
PATH=$PATH:$INSTALL_ROOT/bin
export CONFIG_SHELL INSTALL_ROOT

# Workaround for ubi 7
if [ -f "/opt/rh/devtoolset-8/enable" ]; then
    source /opt/rh/devtoolset-8/enable
fi  

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

    # temporary workaround for broken mimalloc upgrade in moarvm
    if [ $i == "moarvm" ] && [ "$OS" == "alpine" ]; then
	rm -rf 3rdparty/mimalloc*    
    fi

    # temporary workaround for old perls
    if [ -f "3rdparty/nqp-configure/lib/NQP/Config.pm" ]; then
        echo "patching NQP/Config.pm..."
        perl -pi -e 's/my (sub on_)/$1/' 3rdparty/nqp-configure/lib/NQP/Config.pm
    fi
    $CONFIGURE
    make
    make test
    make install
    cd ..
done

raku -v

# Workaround for https://github.com/rakudo/rakudo/issues/1515
mkdir -p $INSTALL_ROOT/share/perl6/site/short $INSTALL_ROOT/share/perl6/vendor/short
touch $INSTALL_ROOT/share/perl6/site/short/.keep $INSTALL_ROOT/share/perl6/vendor/short/.keep

# Install zef source
mkdir -p $INSTALL_ROOT/var/zef
tar xzf zef.tar.gz -C $INSTALL_ROOT/var/zef --strip-components=1

# Add extra scripts and directories
cd include
chmod +x *
for i in *; do
    cp $i $INSTALL_ROOT/bin
done
