#!/bin/sh -e
set -xv

. config/versions.sh

# Install nfpm
tar xzf nfpm.tar.gz nfpm
mv nfpm /usr/bin

# Fill the config
envsubst 
envsubst < config/nfpm.yaml > config/nfpm.yaml_tmp
mv config/nfpm.yaml_tmp config/nfpm.yaml

# Package
case "$OS" in 
    alpine)
		PACKAGER=apk
        ;;
    centos)
		PACKAGER=rpm
        ;;
    debian)
		PACKAGER=deb
        ;;
    fedora)
		PACKAGER=rpm
        ;;
    opensuse)
		PACKAGER=rpm
        ;;
    rhel)
		PACKAGER=rpm
        ;;
    ubuntu)
		PACKAGER=deb
        ;;
    *)
        echo "Sorry, distro not found. Send a PR. :)"
        exit 1
        ;;
esac    

nfpm -f config/nfpm.yaml --packager $PACKAGER /tmp/.font-unix
ls -la /tmp
