FROM centos:centos7
LABEL maintainer="Claudio Ramirez <pub.claudio@gmail.com>"

ENV LANG='en_US.UTF-8' \
pkgs='git perl-autodie perl-Digest-SHA redhat-lsb-core wget' \
pkggroup='Development Tools' \
pkgs_tmp='ruby-devel'

RUN set -xv ; \
sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf && \
yum -q -y upgrade && \
ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
# Packages for compiling and pkg creation
yum -q install -y ${pkgs} ${pkgs_tmp} && \
yum -q groupinstall -y "${pkggroup}" && \
gem install --no-doc --no-ri fpm && \
# Cleanup
yum -q remove -y ${pkgs_tmp} && yum -q clean all && \
rm -rf /usr/lib/locale/locale-archive /usr/share/locale/* && \
localedef -i en_US -c -f UTF-8 en_US.UTF-8

COPY pkg_rakudo.pl /
COPY install-zef-as-user /
COPY fix_windows10 /
COPY add-perl6-to-path /
COPY rakudo-pkg.sh /etc/profile.d/

ENTRYPOINT [ "/pkg_rakudo.pl" ]
