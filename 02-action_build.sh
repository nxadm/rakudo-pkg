#!/bin/sh -e
set -xv

. ./versions.sh
PATH=$PATH:$INSTALL_ROOT/bin

# Build rakudo
for i in moarvm nqp rakudo; do
    mkdir $i
    tar xzf $i.tar.gz -C $i --strip-components=1
    CONFIGURE="perl ./Configure.pl --prefix=$INSTALL_ROOT --relocatable"
    if [ $i != "moarvm" ]; then
        CONFIGURE=$CONFIGURE" --backends=moar"
    fi 

    cd $i
    find .
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

ls -la $INSTALL_ROOT/bin

find $INSTALL_ROOT

# Create links and add scripts
#cd $INSTALL_ROOT/bin
#rm raku raku-debug
#ln -s rakudo raku
#ln -s rakudo-debug raku-debug
#ln -s ../share/perl6/site/bin/zef .
#cp /install-zef-as-user .
#cp /fix-windows10 .
#cp /add-rakudo-to-path .
#
## Package it in /mnt
#cd /
#mv $INSTALL_ROOT rakudo-pkg-$RAKUDO_VERSION
#mkdir -p /staging
#TARGZ="rakudo-pkg-mooarvm-${RAKUDO_VERSION}-${REVISION}-linux-${ARCH}.tar.gz"
#tar -czf /staging/$TARGZ rakudo-pkg-$RAKUDO_VERSION
#
## Checksum it
#cd /staging
#sha1sum $TARGZ > "${TARGZ}.sha1"
#echo "Package checksum:"
#cat "${TARGZ}.sha1"
#
#exit 0
