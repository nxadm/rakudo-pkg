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
    apk add bash build-base gettext git gzip perl perl-utils tar zstd-dev
    set_os_vars x86_64 zstd-libs
    ;;
  debian)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -u dist-upgrade -y -qq
    apt-get install -y build-essential git gettext libzstd-dev
    set_os_vars amd64 libzstd1
    ;;
  el)
    microdnf update -y
    # el 7 does not have libatomic.h
    if [ `cat /etc/os-release | grep VERSION_ID= | cut -d\" -f2| cut -d. -f1` == "7" ]; then
      microdnf install -y yum-utils perl
      yum-config-manager --add-repo=https://copr.fedoraproject.org/coprs/rhscl/centos-release-scl/repo/epel-7/rhscl-centos-release-scl-epel-7.repo
      microdnf install centos-release-scl
      cp /etc/yum.repos.d/CentOS-SCLo-scl.repo /etc/yum.repos.d/CentOS-SCLo-rh.repo
      perl -pi -e 's/centos-sclo-sclo/centos-sclo-rh/; s@basearch/sclo@basearch/rh@g' /etc/yum.repos.d/CentOS-SCLo-rh.repo
      yum-config-manager --enable centos-sclo-sclo --enable centos-sclo-rh
      microdnf install devtoolset-8-gcc
      source /opt/rh/devtoolset-8/enable
    fi
    microdnf install -y gettext gcc git gzip make perl-core tar
    set_os_vars x86_64 ""
    ;;
  fedora)
    dnf -q -y upgrade
    dnf -q -y groupinstall 'Development Tools'
    dnf -q -y install gettext git libzstd-devel perl-core
    set_os_vars x86_64 libzstd
    ;;
  opensuse)
    zypper refresh
    zypper update -y
    zypper install -y findutils gcc gettext git gzip make libzstd-devel perl tar
    set_os_vars x86_64 libzstd1
    ;;
  ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -u dist-upgrade -y -qq
    apt-get install -y build-essential git gettext libzstd-dev
    set_os_vars amd64 libzstd1
    ;;
  *)
    echo "Sorry, distro not found. Send a PR. :)"
    exit 1
    ;;
esac
