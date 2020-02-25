#!/bin/bash -e
git clone https://github.com/MoarVM/MoarVM.git moarvm
cd moarvm
git checkout tags/2020.02
perl -pi -e 's/(my \@cflags;)/$1\npush \@cflags, "-DDL_USE_GLIBC_ITER_PHDR";/' Configure.pl
./Configure.pl
make
make install
git clone https://github.com/perl6/nqp.git
cd nqp
git checkout tags/2020.02
./Configure.pl --backends=moar
make
make test
make install
git clone https://github.com/rakudo/rakudo.git
cd rakudo
git checkout tags/2020.02
./Configure.pl --backends=moar
make
make test
make install

exit 0
