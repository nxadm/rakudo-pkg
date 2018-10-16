FROM ubuntu:xenial
LABEL maintainer="Claudio Ramirez <pub.claudio@gmail.com>"

ENV LANG='C.UTF-8' \
DEBIAN_FRONTEND='noninteractive' \
TZ='Europe/Brussels' \
pkgs='build-essential git lsb-release ruby wget' \
pkgs_tmp='ruby-dev'

RUN set -xv ; \
apt-get -qq update && \
apt-get -qq dist-upgrade -y && \
# Packages for compiling and pkg creation
apt-get -qq install -y ${pkgs} ${pkgs_tmp} && \
gem install --no-doc --no-ri fpm && \
# Cleanup
apt-get remove -y --purge ${pkgs_tmp} && \
apt-get -qq autoremove -y && apt-get -qq clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /*.deb /MoarVM* /nqp* /rakudo*

COPY pkg_rakudo.pl /
COPY install-zef-as-user /
COPY fix_windows10 /
COPY add-perl6-to-path /
COPY rakudo-pkg.sh /etc/profile.d/

ENTRYPOINT [ "/pkg_rakudo.pl" ]
