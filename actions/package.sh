#!/bin/sh -e
set -xv

. config/setup.sh
export ARCH PKG_MAINTAINER PKG_REVISION RAKUDO_VERSION RUN_DEPS

# Install nfpm
tar xzf nfpm.tar.gz nfpm
mv nfpm /usr/bin

# Fill the config
envsubst < config/nfpm.yaml > config/nfpm.yaml_tmp
mv config/nfpm.yaml_tmp config/nfpm.yaml

DISTRO_ARCH=$ARCH
if [ "$OS" = "alpine" -o "$OS" = "el" -o "$OS" = "fedora" -o "$OS" = "opensuse" ]; then
  if [ $ARCH = "amd64" ]; then
    DISTRO_ARCH=x86_64
  else
    DISTRO_ARCH=aarch64
  fi
fi

# Package
case "$OS" in
    alpine)
        PACKAGER=apk
        INSTALL_CMD="if [ ! -z "$INSTALL_DEPS" ]; then apk add $INSTALL_DEPS; fi; apk add --no-cache --allow-untrusted *.apk"
        PKG_NAME="rakudo-pkg-Alpine${OS_VERSION}_${RAKUDO_VERSION}-${PKG_REVISION}_${DISTRO_ARCH}.apk"
        PKG_CMD="cloudsmith push alpine $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    debian)
        PACKAGER=deb
        PKG_NAME=rakudo-pkg-Debian${OS_VERSION}_${RAKUDO_VERSION}-${PKG_REVISION}_${DISTRO_ARCH}.deb
        INSTALL_CMD="apt-get update; apt install -y ./$PKG_NAME"
        PKG_CMD="cloudsmith push deb $CLOUDSMITH_REPOSITORY/$OS/$OS_CODENAME $PKG_NAME"
        ;;
    el)
        PACKAGER=rpm
        INSTALL_CMD="if [ ! -z "$INSTALL_DEPS" ]; then microdnf install $INSTALL_DEPS; fi; rpm -Uvh *.rpm"
        PKG_NAME=rakudo-pkg-EL${OS_VERSION}-${RAKUDO_VERSION}-${PKG_REVISION}.${DISTRO_ARCH}.rpm
        PKG_CMD="cloudsmith push rpm $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    fedora)
        PACKAGER=rpm
        INSTALL_CMD='dnf -y install *.rpm'
        PKG_NAME=rakudo-pkg-Fedora${OS_VERSION}-${RAKUDO_VERSION}-${PKG_REVISION}.${DISTRO_ARCH}.rpm
        PKG_CMD="cloudsmith push rpm $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    opensuse)
        PACKAGER=rpm
        PKG_NAME=rakudo-pkg-openSUSE${OS_VERSION}-${RAKUDO_VERSION}-${PKG_REVISION}.${DISTRO_ARCH}.rpm
        INSTALL_CMD="if [ ! -z "$INSTALL_DEPS" ]; then zypper install -y $INSTALL_DEPS; fi; rpm -Uvh *.rpm"
        PKG_CMD="cloudsmith push rpm $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    ubuntu)
        if [ "${OS}${OS_VERSION}" = "$PKG_TARGZ" ]; then
            PACKAGER=targz
            PKG_NAME=rakudo-pkg-linux-relocable-${RAKUDO_VERSION}-${PKG_REVISION}_${DISTRO_ARCH}.tar.gz
            INSTALL_CMD="tar xvzf /staging/$PKG_NAME"
            PKG_CMD="true"
        else
            PACKAGER=deb
            PKG_NAME=rakudo-pkg-Ubuntu${OS_VERSION}_${RAKUDO_VERSION}-${PKG_REVISION}_${DISTRO_ARCH}.deb
            INSTALL_CMD="apt-get update; apt install -y ./$PKG_NAME"
            PKG_CMD="cloudsmith push deb $CLOUDSMITH_REPOSITORY/$OS/$OS_CODENAME $PKG_NAME"
        fi
        ;;
    *)
        echo "Sorry, distro not found. Send a PR. :)"
        exit 1
        ;;
esac

mkdir -p /staging $GITHUB_WORKSPACE/packages

if [ "$PACKAGER" = "targz" ]; then
    cd /opt
    tar cvzf /staging/$PKG_NAME rakudo-pkg
    cd /staging
else
    echo "DEBUG config/nfpm.yaml:"
    cat config/nfpm.yaml
    echo "DEBUG END"
    nfpm pkg -f config/nfpm.yaml --packager $PACKAGER --target /staging/
    cd /staging
    mv *.$PACKAGER $PKG_NAME
fi


sha512sum $PKG_NAME > $PKG_NAME.sha512
echo "Package sha512:"
cat $PKG_NAME.sha512

# Test the package
mv /opt/rakudo-pkg /rakudo-pkg-${RAKUDO_VERSION}
eval $INSTALL_CMD
if [ -f /etc/profile.d/rakudo-pkg.sh ]; then
    . /etc/profile.d/rakudo-pkg.sh
    raku -v
    /opt/rakudo-pkg/bin/install-zef
    ~/.raku/bin/zef --version
else
   /staging/rakudo-pkg/bin/raku -v
fi
rm -rf /staging/rakudo-pkg

# Move to workspace
mv /staging/* $GITHUB_WORKSPACE/packages/

# Write the upload URL for publishing the packages
echo "$PKG_CMD" > $GITHUB_WORKSPACE/packages/$PKG_NAME.sh
