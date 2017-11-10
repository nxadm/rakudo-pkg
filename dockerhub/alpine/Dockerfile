# Rakudo image based on alpine with every needed to run Rakudo programs
# (perl6) and install modules with the Zef module manager (zef). If you need
# a more minimalistic image (e.g. without Zef and a C compiler for modules
# using C-bindings), just use the official Alpine image and add the Rakudo
# apk from https://githum.com/nxadm/rakudo-pkg.
FROM alpine:3.6
LABEL maintainer="Claudio Ramirez <pub.claudio@gmail.com>"
ENV rakudo='https://github.com/nxadm/rakudo-pkg/releases/download/v2017.10-02/rakudo-pkg-Alpine3.6_2017.10-01_x86_64.apk'
ENV LANG='C.UTF-8'
ENV TZ='Europe/Brussels'
ENV pkgs='build-base ca-certificates git openssl readline wget'
ENV pkgs_tmp='tzdata'
ENV PATH=~/.perl6/bin:/opt/rakudo-pkg/bin:$PATH
RUN set -xv ; \
apk update && apk upgrade && \
# pkgs for compiling and pkg creation
apk add --no-cache ${pkgs} ${pkgs_tmp} && \
update-ca-certificates && \
cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
echo "${TZ}" > /etc/timezone && \
wget ${rakudo} && apk add --allow-untrusted *.apk && rm -rf *.apk && \
zef install Readline && \
# Cleanup
apk del ${pkg_tmp} && \
rm -rf /tmp/* /var/tmp/* /MoarVM* /nqp* /rakudo*
ENTRYPOINT [ "perl6" ]
ONBUILD ENTRYPOINT []
