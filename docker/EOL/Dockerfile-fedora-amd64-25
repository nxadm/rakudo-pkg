FROM fedora:25
MAINTAINER Claudio Ramirez <pub.claudio@gmail.com>

ENV LANG='en_US.UTF-8' \
pkgs='git perl-core redhat-lsb-core redhat-rpm-config rpm-build ruby ruby-devel rubygems wget' \
pkggroup='Development Tools' \
pkgs_tmp='ruby-devel'

RUN set -xv ; \
dnf -q -y upgrade && \
ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
# Packages for compiling and pkg creation
dnf -q install -y ${pkgs} ${pkgs_tmp} && \
dnf -q groupinstall -y "${pkggroup}" && \
gem install fpm && \
# Cleanup
dnf -q remove -y ${pkgs_tmp} && dnf -q clean all

COPY pkg_rakudo.pl /
COPY install-zef-as-user /

ENTRYPOINT [ "/pkg_rakudo.pl" ]
