#!/bin/sh -e
set -xv

. config/setup.sh
export ARCH PKG_MAINTAINER PKG_REVISION RAKUDO_VERSION

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
        INSTALL_CMD='apk add --no-cache --allow-untrusted *.apk'
        PKG_NAME="rakudo-pkg-Alpine${OS_VERSION}_${RAKUDO_VERSION}-${PKG_REVISION}_x86_64.apk"
        PKG_CMD="cloudsmith push alpine $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    centos)
        PACKAGER=rpm
        INSTALL_CMD='rpm -Uvh *.rpm'
        PKG_NAME=rakudo-pkg-CentOS${OS_VERSION}-${RAKUDO_VERSION}-${PKG_REVISION}.x86_64.rpm
        PKG_CMD="cloudsmith push rpm $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    debian)
        PACKAGER=deb
        INSTALL_CMD='dpkg -i *.deb'
        PKG_NAME=rakudo-pkg-Debian${OS_VERSION}_${RAKUDO_VERSION}-${PKG_REVISION}_amd64.deb
        PKG_CMD="cloudsmith push deb $CLOUDSMITH_REPOSITORY/$OS/$OS_OS_CODENAME $PKG_NAME"
        ;;
    fedora)
        PACKAGER=rpm
        INSTALL_CMD='rpm -Uvh *.rpm'
        PKG_NAME=rakudo-pkg-Fedora${OS_VERSION}-${RAKUDO_VERSION}-${PKG_REVISION}.x86_64.rpm
        PKG_CMD="cloudsmith push rpm $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    opensuse)
        PACKAGER=rpm
        INSTALL_CMD='rpm -Uvh *.rpm'
        PKG_NAME=rakudo-pkg-openSUSE${OS_VERSION}-${RAKUDO_VERSION}-${PKG_REVISION}.x86_64.rpm
        PKG_CMD="cloudsmith push rpm $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    rhel)
        PACKAGER=rpm
        INSTALL_CMD='rpm -Uvh *.rpm'
        PKG_NAME=rakudo-pkg-RHEL${OS_VERSION}-${RAKUDO_VERSION}-${PKG_REVISION}.x86_64.rpm
        PKG_CMD="cloudsmith push rpm $CLOUDSMITH_REPOSITORY/$OS/$OS_VERSION $PKG_NAME"
        ;;
    ubuntu)
        PACKAGER=deb
        INSTALL_CMD='dpkg -i *.deb'
        PKG_NAME=rakudo-pkg-Ubuntu${OS_VERSION}_${RAKUDO_VERSION}-${PKG_REVISION}_amd64.deb
        PKG_CMD="cloudsmith push deb $CLOUDSMITH_REPOSITORY/$OS/$OS_OS_CODENAME $PKG_NAME"
        ;;
    *)
        echo "Sorry, distro not found. Send a PR. :)"
        exit 1
        ;;
esac

mkdir -p /staging $GITHUB_WORKSPACE/packages
nfpm pkg -f config/nfpm.yaml --packager $PACKAGER --target /staging/
cd /staging
mv *.$PACKAGER $PKG_NAME
sha512sum $PKG_NAME > $PKG_NAME.sha512
echo "Package sha512:"
cat $PKG_NAME.sha512

# Test the package
mv /opt/rakudo-pkg /rakudo-pkg-${RAKUDO_VERSION}
$INSTALL_CMD
. /etc/profile.d/rakudo-pkg.sh
raku -v
zef --version

# Move to workspace
mv /staging/* $GITHUB_WORKSPACE/packages/

# tar the relocable build oldest distro
if [ "${OS}${OS_VERSION}" = $PKG_TARGZ ]; then
    TARGZ=rakudo-pkg-linux-relocable-${RAKUDO_VERSION}-${PKG_REVISION}_${ARCH}.tar.gz
    cd /
    tar cvzf /staging/$TARGZ rakudo-pkg-${RAKUDO_VERSION}
    cd /staging
    sha512sum $TARGZ > $TARGZ.sha512sum
    echo "Package sha512sum:"
    cat $TARGZ.sha512sum
    mv /staging/* $GITHUB_WORKSPACE/packages/
fi

# Write the upload URL for publishing the packages
echo "$PKG_CMD" > $GITHUB_WORKSPACE/packages/$PKG_NAME.sh