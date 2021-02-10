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

# Package
case "$OS" in
    alpine)
        PACKAGER=apk
        INSTALL_CMD="if [ ! -z "$INSTALL_DEPS" ]; then apk add $INSTALL_DEPS; fi; apk add --no-cache --allow-untrusted *.apk"
        PKG_NAME="rakudo-pkg-Alpine${OS_VERSION}_${RAKUDO_VERSION}-${PKG_REVISION}_x86_64.apk"
        PKG_CMD="cloudsmith push alpine $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    debian)
        PACKAGER=deb
        PKG_NAME=rakudo-pkg-Debian${OS_VERSION}_${RAKUDO_VERSION}-${PKG_REVISION}_amd64.deb
        INSTALL_CMD="apt-get update; apt install ./$PKG_NAME"
        PKG_CMD="cloudsmith push deb $CLOUDSMITH_REPOSITORY/$OS/$OS_CODENAME $PKG_NAME"
        ;;
    el)
        PACKAGER=rpm
        INSTALL_CMD="if [ ! -z "$INSTALL_DEPS" ]; then microdnf install $INSTALL_DEPS; fi; rpm -Uvh *.rpm"
        PKG_NAME=rakudo-pkg-EL${OS_VERSION}-${RAKUDO_VERSION}-${PKG_REVISION}.x86_64.rpm
        PKG_CMD="cloudsmith push rpm $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    fedora)
        PACKAGER=rpm
        INSTALL_CMD='dnf -y install *.rpm'
        PKG_NAME=rakudo-pkg-Fedora${OS_VERSION}-${RAKUDO_VERSION}-${PKG_REVISION}.x86_64.rpm
        PKG_CMD="cloudsmith push rpm $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    opensuse)
        PACKAGER=rpm
        PKG_NAME=rakudo-pkg-openSUSE${OS_VERSION}-${RAKUDO_VERSION}-${PKG_REVISION}.x86_64.rpm
        INSTALL_CMD="if [ ! -z "$INSTALL_DEPS" ]; then zypper install -y $INSTALL_DEPS; fi; rpm -Uvh *.rpm"
        PKG_CMD="cloudsmith push rpm $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    ubuntu)
        PACKAGER=deb
        PKG_NAME=rakudo-pkg-Ubuntu${OS_VERSION}_${RAKUDO_VERSION}-${PKG_REVISION}_amd64.deb
        INSTALL_CMD="apt-get update; apt install ./$PKG_NAME"
        PKG_CMD="cloudsmith push deb $CLOUDSMITH_REPOSITORY/$OS/$OS_CODENAME $PKG_NAME"
        ;;
    *)
        echo "Sorry, distro not found. Send a PR. :)"
        exit 1
        ;;
esac

mkdir -p /staging $GITHUB_WORKSPACE/packages
echo "DEBUG config/nfpm.yaml:"
cat config/nfpm.yaml
echo "DEBUG END"
nfpm pkg -f config/nfpm.yaml --packager $PACKAGER --target /staging/
cd /staging
mv *.$PACKAGER $PKG_NAME
sha512sum $PKG_NAME > $PKG_NAME.sha512
echo "Package sha512:"
cat $PKG_NAME.sha512

# Test the package
mv /opt/rakudo-pkg /rakudo-pkg-${RAKUDO_VERSION}
eval $INSTALL_CMD
. /etc/profile.d/rakudo-pkg.sh
raku -v
zef --version

# Move to workspace
mv /staging/* $GITHUB_WORKSPACE/packages/

# tar the relocable build oldest distro
if [ "${OS}${OS_VERSION}" = $PKG_TARGZ ]; then
    TARGZ=rakudo-pkg-linux-relocable-${RAKUDO_VERSION}-${PKG_REVISION}_${ARCH}.tar.gz
    cd /opt
    tar cvzf /staging/$TARGZ rakudo-pkg
    cd /staging
    sha512sum $TARGZ > $TARGZ.sha512sum
    echo "Package sha512sum:"
    cat $TARGZ.sha512sum
    mv /staging/* $GITHUB_WORKSPACE/packages/
fi

# Write the upload URL for publishing the packages
echo "$PKG_CMD" > $GITHUB_WORKSPACE/packages/$PKG_NAME.sh