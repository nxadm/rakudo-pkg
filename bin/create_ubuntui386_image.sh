# Image to be pushed to docker hub as a base image for Ubuntu 16.04 i386 packages
curl http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/ubuntu-base-16.04-core-i386.tar.gz | gunzip | sudo docker import - nxadm/ubuntu16.04-i386
