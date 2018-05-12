FROM alpine:3.7
LABEL maintainer="Claudio Ramirez <pub.claudio@gmail.com>"
# This build is on hold because an upstream bug resulting in bad pkgs:
# https://github.com/jordansissel/fpm/issues/1227

ENV apk="https://github.com/nxadm/rakudo-pkg/releases/download/v2018.04.1-01/rakudo-pkg-Alpine3.6_2018.04.1-01_x86_64.apk" \
    LANG='C.UTF-8' \
    PATH="/opt/rakudo-pkg/bin:/opt/rakudo-pkg/share/perl6/site/bin:${PATH}" \
    pkgs='ca-certificates linenoise wget'

RUN set -xv ; \
    apk update && apk upgrade && apk add --no-cache ${pkgs} ${pkg_tmp} && \
    update-ca-certificates && \
    wget $apk && apk add --allow-untrusted *.apk && rm -f *.apk \
    zef install Linenoise

ENTRYPOINT [ "perl6" ]
