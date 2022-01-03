#!/bin/sh -e
# Prepare the images to compile and package Rakudo
# https://github.com/nxadm/rakudo-pkg
set -xv

. config/pkginfo.sh
OS=`grep ^ID= /etc/os-release | cut -d= -f2 | cut -d\" -f2| cut -d- -f1`
if [ "$OS" = "rhel" ]; then
  OS="el"
fi

set_os_vars() {
  ARCH=$1
  RUN_DEPS=$2
  OS_CODENAME=`perl -lwn -e 'if (/^VERSION_CODENAME=/) { s/^.+=(.+)/$1/; print }' /etc/os-release`
  OS_VERSION=`echo $IMAGE| perl -lwp -e 's/^.+[:\/](?:ubi)*([.\w+\d+]+).*/$1/'`

  if [ "$IMAGE" = "fedora:rawhide" ]; then
    OS_VERSION=$FEDORA_RAWHIDE_VERSION
  fi
  if [ "$IMAGE" = "debian:testing-slim" ]; then
    OS_CODENAME=$DEBIAN_TESTING_CODENAME
  fi
  if [ -z "$OS_CODENAME" ]; then
    OS_CODENAME=$OS_VERSION
  fi

  echo ARCH=$ARCH >> config/setup.sh
  echo OS=$OS >> config/setup.sh
  if [ ! -z "$RUN_DEPS" ]; then
    echo INSTALL_DEPS=$RUN_DEPS >> config/setup.sh
    echo RUN_DEPS="\"      - $RUN_DEPS\"" >> config/setup.sh
  fi
  echo OS_VERSION=$OS_VERSION >> config/setup.sh
  echo OS_CODENAME=$OS_CODENAME >> config/setup.sh
  cat config/pkginfo.sh >> config/setup.sh
}

case "$OS" in 
  alpine)
    apk update
    apk upgrade
    PKGS="bash build-base gettext git gzip perl perl-utils tar zstd-dev"
    if [ ! -z "$CIRRUS_CI" ]; then PKGS="$PKGS curl"; fi
    apk add $PKGS
    set_os_vars x86_64 zstd-libs
    ;;
  debian)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -u dist-upgrade -y -qq
    PKGS="build-essential git gettext libzstd-dev"
    if [ ! -z "$CIRRUS_CI" ]; then PKGS="$PKGS curl"; fi
    apt-get install -y $PKGS
    set_os_vars amd64 libzstd1
    ;;
  el)
    microdnf update
    PKGS="gettext gcc git gzip make perl-core tar"
    if [ ! -z "$CIRRUS_CI" ]; then PKGS="$PKGS curl"; fi
    microdnf install $PKGS
    # ubi 8 bug: https://bugzilla.redhat.com/show_bug.cgi?id=1963049
    #if [ `cat /etc/os-release | grep VERSION_ID= | cut -d\" -f2| cut -d. -f1` == "8" ]; then
    #   microdnf install curl dnf
    #   curl -sSL https://cdn-ubi.redhat.com/content/public/ubi/dist/ubi8/8/x86_64/appstream/os/Packages/p/perl-libnetcfg-5.26.3-419.el8.noarch.rpm -O
    #   dnf install -y ./perl-libnetcfg-5.26.3-419.el8.noarch.rpm
    #   rm -rf *rpm
    #   dnf install -y gettext gcc git gzip make perl-core tar
    #   else
    #    microdnf update
    #    microdnf install gettext gcc git gzip make perl-core tar
    #fi
    set_os_vars x86_64 ""
    ;;
  fedora)
    dnf -q -y upgrade
    dnf -q -y groupinstall 'Development Tools'
    PKGS="gettext git libzstd-devel perl-core"
    if [ ! -z "$CIRRUS_CI" ]; then PKGS="$PKGS curl"; fi
    dnf -q -y install $PKGS
    set_os_vars x86_64 libzstd
    ;;
  opensuse)
    zypper refresh
    zypper update -y
    PKGS="findutils gcc gettext git gzip make libzstd-devel perl tar"
    if [ ! -z "$CIRRUS_CI" ]; then PKGS="$PKGS curl"; fi
    zypper install -y $PKGS
    set_os_vars x86_64 libzstd1
    ;;
  ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -u dist-upgrade -y -qq
    PKGS="build-essential git gettext git libzstd-dev"
    if [ ! -z "$CIRRUS_CI" ]; then PKGS="$PKGS curl"; fi
    apt-get install -y $PKGS
    set_os_vars amd64 libzstd1
    ;;
  *)
    echo "Sorry, distro not found. Send a PR. :)"
    exit 1
    ;;
esac
