FROM fedora:29
LABEL maintainer="Claudio Ramirez <pub.claudio@gmail.com>"

ENV LANG='en_US.UTF-8' \
    pkgs='git perl-core redhat-lsb-core redhat-rpm-config rpm-build ruby rubygems ruby-devel wget' \
    pkggroup='Development Tools' \
    pkgs_tmp='ruby-devel'

RUN set -xv ; \
    dnf -q -y upgrade && \
    ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
    # Packages for compiling and pkg creation
    dnf -q install -y ${pkgs} ${pkgs_tmp} && \
    dnf -q groupinstall -y "${pkggroup}" && \
    gem install --no-doc --no-ri fpm && \
    # Cleanup
    dnf -q remove -y ${pkgs_tmp} && dnf -q clean all

COPY pkg_rakudo.pl /
COPY install-zef-as-user /
COPY fix_windows10 /
COPY add-perl6-to-path /
COPY rakudo-pkg.sh /etc/profile.d/

ENTRYPOINT [ "/pkg_rakudo.pl" ]
