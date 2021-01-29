#!/bin/sh -e
set -xv

# Build rakudo
for i in moarvm nqp rakudo; do
    mkdir $i
    tar xzf $i.tar.gz -C $i --strip-components=1
    CONFIGURE="perl ./Configure.pl --prefix=$INSTALL_ROOT"
    if [ $i != "moarvm" ]; then
        CONFIGURE=$CONFIGURE" --backends=moar"
    fi 

    cd $i
    $CONFIGURE
    make
    make test
    make install
    cd ..
done    

# Install zef
mkdir zef
tar xzf zef.tar.gz -C zef --strip-components=1
cd zef
$INSTALL_ROOT/bin/raku -I. bin/zef --install-to=core install .
ls -la $INSTALL_ROOT/bin


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
