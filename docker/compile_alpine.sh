#!/usr/bin/env bash -e
git clone https://github.com/MoarVM/MoarVM.git moarvm
cd moarvm
git checkout tags/2020.02
CFLAGS='-fPIC -DDL_USE_GLIBC_ITER_PHDR' ./Configure.pl --backends=moar
CFLAGS='-fPIC -DDL_USE_GLIBC_ITER_PHDR' make
CFLAGS='-fPIC -DDL_USE_GLIBC_ITER_PHDR' make install
git clone https://github.com/perl6/nqp.git
cd nqp
git checkout tags/2020.02
CFLAGS='-fPIC -DDL_USE_GLIBC_ITER_PHDR' ./Configure.pl
CFLAGS='-fPIC -DDL_USE_GLIBC_ITER_PHDR' make
CFLAGS='-fPIC -DDL_USE_GLIBC_ITER_PHDR' make test
CFLAGS='-fPIC -DDL_USE_GLIBC_ITER_PHDR' make install
git clone https://github.com/rakudo/rakudo.git
cd rakudo
git checkout tags/2020.02
CFLAGS='-fPIC -DDL_USE_GLIBC_ITER_PHDR' ./Configure.pl
CFLAGS='-fPIC -DDL_USE_GLIBC_ITER_PHDR' make
CFLAGS='-fPIC -DDL_USE_GLIBC_ITER_PHDR' make install

exit 0
