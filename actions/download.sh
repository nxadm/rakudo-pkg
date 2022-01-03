#!/bin/sh -e
set -xv

if [ ! -z "$CIRRUS_CI" ]; then
  OS=`grep ^ID= /etc/os-release | cut -d= -f2 | cut -d\" -f2| cut -d- -f1`
  if [ "$OS" = "rhel" ]; then
    OS="el"
  fi

  case "$OS" in
    alpine)
      PKGS="ca-certificates git curl"
      apk add $PKGS
      ;;
    debian)
      export DEBIAN_FRONTEND=noninteractive
      PKGS="ca-certificates git curl"
      apt-get install -y $PKGS
      ;;
    el)
      PKGS="ca-certificates git curl"
      microdnf install $PKGS
      ;;
    fedora)
      PKGS="ca-certificates git curl"
      dnf -q -y install $PKGS
      ;;
    opensuse)
      PKGS="gettext git libzstd-devel perl-core"
      zypper install -y $PKGS
      ;;
    ubuntu)
      export DEBIAN_FRONTEND=noninteractive
      PKGS="ca-certificates git curl"
      apt-get install -y $PKGS
      ;;
    *)
      echo "Sorry, distro not found. Send a PR. :)"
      exit 1
      ;;
  esac
fi

if [ -z "$DEVBUILD" ]; then
    . config/pkginfo.sh
    . config/setup.sh
    NFPM_URL=https://github.com/goreleaser/nfpm/releases/download/v$NFPM_RELEASE/nfpm_${NFPM_RELEASE}_Linux_x86_64.tar.gz
    if [ ! -z "$CIRRUS_CI" ]; then
      NFPM_URL=https://github.com/goreleaser/nfpm/releases/download/v$NFPM_RELEASE/nfpm_${NFPM_RELEASE}_Linux_arm64.tar.gz
    fi
    curl -sSL -o nfpm.tar.gz $NFPM_URL
fi

git clone --recurse-submodules https://github.com/moarvm/moarvm.git
if [ $MOARVM_VERSION != "HEAD" ]; then
    cd moarvm 
    git checkout $MOARVM_VERSION
    cd ..
fi

git clone --recurse-submodules https://github.com/raku/nqp.git
if [ $NQP_VERSION != "HEAD" ]; then
    cd nqp 
    git checkout $NQP_VERSION
    cd ..
fi

git clone --recurse-submodules https://github.com/rakudo/rakudo.git
if [ $RAKUDO_VERSION != "HEAD" ]; then
    cd rakudo
    git checkout $RAKUDO_VERSION
    cd ..
fi

git clone --recurse-submodules https://github.com/ugexe/zef.git zef
if [ $ZEF_VERSION != "HEAD" ]; then
    cd zef
    git checkout $ZEF_VERSION
    cd ..
fi

for i in moarvm nqp rakudo zef; do
    tar czf $i.tar.gz --exclude-vcs $i
    rm -rf $i
done

ls -laH *.tar.gz