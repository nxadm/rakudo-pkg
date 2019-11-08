#!/usr/bin/env bash -e

RELEASE=$1
ZEFVERSION=v$2
BITS=$3

# Build Rakudo
curl -sSL -o rakudo.tar.gz \
https://github.com/rakudo/rakudo/releases/download/$RELEASE/rakudo-$RELEASE.tar.gz
tar -xzf rakudo.tar.gz
cd rakudo* 
perl Configure.pl --gen-moar --gen-nqp --backends=moar --relocatable
make test
make install

# Build Zef
git clone https://github.com/ugexe/zef.git 
cd zef
git checkout tags/$ZEFVERSION
/rakudo-*/install/bin/perl6 -I. bin/zef install .

# Create links and add scripts
cd rakudo*/install/bin
ln -s perl6 rakudo 
ln -s perl6 rakudo
ln -s ../share/perl6/site/bin/zef .
cp /install-zef-as-user .
cp /fix-windows10 .
cp /add-rakudo-to-path .

# Package it in /mnt
cd /rakudo*
mv install rakudo-$RELEASE
tar -czf /mnt/rakudo-$RELEASE-linux-64${BITS}.tar.gz rakudo-$RELEASE

exit 0
