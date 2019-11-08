FROM centos:centos6
LABEL maintainer="Claudio Ramirez <pub.claudio@gmail.com>"

ARG rakudo_release=2019.07.1
ENV LANG='en_US.UTF-8' \
ENV pkgs='git perl perl-core gcc make'

RUN ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime
RUN sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf
RUN yum -q -y upgrade && yum -q install -y ${pkgs} && yum -q clean all
RUN localedef -i en_US -c -f UTF-8 en_US.UTF-8
curl -sSL -o rakudo.tar.gz https://github.com/rakudo/rakudo/releases/download/${rakudo_release}/rakudo-${rakudo_release}.tar.gz && \
tar -xzf rakudo.tar.gz
RUN cd rakudo* && perl Configure.pl --gen-moar --gen-nqp --backends=moar --relocatable && \
make test && make install
RUN git clone https://github.com/ugexe/zef.git && cd zef && \
/rakudo-*/install/bin/perl6 -I. bin/zef install . && \
cd install/bin && ln -s perl6 rakudo && ln -s perl6 rakudo && \
cd .. && ln -s ../share/perl6/site/bin/zef .
RUN cd /rakudo* && mv install rakudo-2019.07.1 && \
tar -czf /rakudo-2019.07.1-linux-64bit.tar.gz rakudo-2019.07.1

COPY install-zef-as-user /
COPY fix-windows10 /
COPY add-rakudo-to-path /
COPY rakudo-pkg.sh /etc/profile.d/

ENTRYPOINT [ "/pkg_rakudo.pl" ]
