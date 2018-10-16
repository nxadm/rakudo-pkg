FROM opensuse/leap:15.0
LABEL maintainer="Claudio Ramirez <pub.claudio@gmail.com>"

ENV LANG='en_US.UTF-8' \
    pkgs='git gcc lsb-release make rpm-build ruby wget' \
    pkgs_tmp='ruby-devel'

RUN set -xv ; \
    zypper refresh && \
    zypper update -y && \
    zypper install --replacefiles -y ${pkgs} ${pkgs_tmp} && \
    ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
    gem install --no-doc --no-ri fpm && \
    zypper remove -y --clean-deps ${pkgs_tmp}

COPY pkg_rakudo.pl /
COPY install-zef-as-user /
COPY fix_windows10 /
COPY add-perl6-to-path /
COPY rakudo-pkg.sh /etc/profile.d/

ENTRYPOINT [ "/pkg_rakudo.pl" ]
