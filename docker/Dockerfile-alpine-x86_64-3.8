FROM alpine:3.8
LABEL maintainer="Claudio Ramirez <pub.claudio@gmail.com>"

ENV LANG='C.UTF-8' \
    TZ='Europe/Brussels' \
    pkgs='build-base ca-certificates git libc-dev libffi linux-headers openssl perl perl-utils ruby wget zlib gzip tar git' \
    pkg_tmp='libffi-dev ruby-dev ruby-irb ruby-rdoc tzdata' \
    to_patch='/usr/lib/ruby/gems/2.5.0/gems/fpm-*/lib/fpm/package/apk.rb'

RUN set -xv ; \
    apk update && apk upgrade && \
    # pkgs for compiling and pkg creation
    apk add --no-cache ${pkgs} ${pkg_tmp} && \
    update-ca-certificates && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    gem install --no-doc --no-ri fpm json etc && \
    # Workaround bug https://github.com/jordansissel/fpm/issues/1227
    APKCODE=`ls -1 $to_patch` && \
    perl -pi -e \
    's/^\s+(full_record_path\s+=\s+add_paxstring\(full_record_path\))/#$1/' \
    $APKCODE && \
    # Cleanup
    apk del ${pkg_tmp} && \
    rm -rf /tmp/* /var/tmp/* /MoarVM* /nqp* /rakudo*

COPY pkg_rakudo.pl /
COPY install-zef-as-user /
COPY fix_windows10 /
COPY add-perl6-to-path /
COPY rakudo-pkg.sh /etc/profile.d/

ENTRYPOINT [ "/pkg_rakudo.pl" ]
