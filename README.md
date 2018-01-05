# rakudo-pkg

[![Build Status](https://travis-ci.org/nxadm/rakudo-pkg.svg?branch=master)](https://travis-ci.org/nxadm/rakudo-pkg)
<br>

## Table of Contents

* [Introduction](#introduction)
* [About the packages (and links to downloads)](#about-the-packages-and-links-to-downloads)
* [Install the Zef Module Manager as a non-root user](#install-the-zef-module-manager-as-a-non-root-user)
* [Building your own packages](#building-your-own-packages)
* [Contributing](#contributing)
* [What about Rakudo Star?](#what-about-rakudo-star)
* [What about packages provided by Operating Systems?](#what-about-packages-provided-by-operating-systems)

## Introduction
rakudo-pkg offers native packages of [Rakudo Perl 6](https://perl6.org/). We
follow upstream closely, so packages are built for every Rakudo release. Most
of the time, they should arrive on the same day the Rakudo sources are released.

For those users (and System Administrators) that prefer to build their own
Rakudo packages, rakudo-pkg can be used as a build framework. Because Docker
containers are used when creating native Linux packages, any platform running
Docker can be used a host, including MacOS and Windows machines.

rakudo-pkg aims to provide small self-contained (no dependencies, no files
outside /opt/rakudo-pkg), pre-compiled native OS packages that can be used on
user's computers, servers and --very importantly-- containers. Therefor, only
Rakudo and the Zef package manager are provided. From a security point of view,
we like to create the builds in the open: the packages are created and
automatically uploaded by [Travis CI](https://travis-ci.org/nxadm/rakudo-pkg)
from the code in this repository. Feel free to inspect the build and contribute
enhancements.

## About the packages (and links to downloads)

"rakudo-pkg" is the name used for the Rakudo installation by the package-manager
in the Linux distributions. At the moment the following packages are provided
(see the full listing in the [releases tab](https://github.com/nxadm/rakudo-pkg/releases)):
- Alpine 3.6 x86_64:
[apk](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=alpine&version=3.6&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=alpine&version=3.6&arch=amd64)).
- Centos 7 x86_64:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=centos&version=7&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=centos&version=7&arch=amd64)).
- Debian 8 amd64:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=debian&version=8&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=debian&version=8&arch=amd64)).
- Debian 9 amd64:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=debian&version=9&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=debian&version=9&arch=amd64)).
- Fedora 25 x86_64:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=fedora&version=25&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=fedora&version=25&arch=amd64)).
- Fedora 26 x86_64:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=fedora&version=26&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=fedora&version=26&arch=amd64)).
- Fedora 27 x86_64:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=fedora&version=27&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=fedora&version=27&arch=amd64)).
- Ubuntu 14.04 amd64*:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=14.04&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=14.04&arch=amd64)).
- Ubuntu 16.04 amd64*:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=16.04&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=16.04&arch=amd64)).
- Ubuntu 17.04 amd64:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=17.04&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=17.04&arch=amd64)).
- Ubuntu 17.10 amd64:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=17.10&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=17.10&arch=amd64)).
- Ubuntu 16.04 i386*:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=16.04&arch=i386)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=16.04&arch=i386)).
- Ubuntu 17.04 i386:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=17.04&arch=i386)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=17.04&arch=i386)).
- Ubuntu 17.10 i386:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=17.10&arch=i386)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=17.10&arch=i386)).

  Beware that 32-bit rakudo binaries (i386) are not JIT enabled (upstream).

**You can install the package with the regular package manager of your
distribution.**

Debian and Ubuntu:
```
$ sudo dpkg -i *.deb
```
Centos and Fedora:
```
$ sudo rpm -Uvh *rpm
```
Alpine:
```
$ sudo apk add --allow-untrusted *.apk
```

**You'll have to add ~/.perl6/bin and /opt/rakudo-pkg/bin to your PATH.
Add this to your .profile, .bash_profile or the corresponding environment
script for other shells)**:

```
PATH=$PATH:~/.perl6/bin:/opt/rakudo-pkg/bin
export PATH
```

*: **If you're using the Windows Subsystem for Linux (aka Bash or Ubuntu on
Windows 10), use the Ubuntu 16.04 package (or the 14.04 one if running an
older release) and run /opt/rakudo-pkg/bin/fix_windows10 after the
installation. The script is needed to strip the moarvm library of (unused)
functionalities that Windows does not implement yet.**

**Older releases (before 2017.10-02) were installed into /opt/rakudo instead of
/opt/rakudo-pkg. Adapt the PATH instructions accordingly.**

## Install the Zef Module Manager as a non-root user
The installation supplies a working Zef *global* installation
(/opt/rakudo-pkg/bin/zef). Rakudo, however, takes a different
approach to many other languages (including Perl 5): modules are by default
installed the home diretory of the user. A script is supplied to install
zef as a user, so you can choose to use the local or the global zef setup
to install modules:

```
install_zef_as_user: install Zef as ~/.perl6/bin/zef
```

## Building your own packages

If you prefer to build your own packages instead of the ones offered in the
[releases tab](https://github.com/nxadm/rakudo-pkg/releases), you can use
the wrapper scripts supplied in bin.

### Create a build image for the desired distribution:

```
bin/create-img.p6
bin/create-img.p6 <docker-file>
bin/create-img.p6 docker/Dockerfile-ubuntu-amd64-16.04
```

Distributions do not provide i386 images by default. The Ubuntu Dockerfiles
use the nxadm/ubuntu-i386:<version> base images. If you want to build your
own locally, you can use the supplied script:

```
bin/create-baseimg.p6
bin/create-baseimg.p6 <Ubuntu release>
bin/create-baseimg.p6 17.10
```

### Create a package:

```
bin/create-pkg.p6
bin/create-pkg.p6 <docker image> --rakudo-version=<version>
bin/create-pkg.p6 rakudo-pkg/ubuntu-amd64:16.04 --rakudo-version=2017.09 --moarvm-version=2017.09.1
```

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md).

## What about Rakudo Star?

[Rakudo Star for Linux](https://github.com/rakudo/star) is certainly a
distribution for end-users worth exploring. It has a very different
use case in mind than rakudo-pkg, however.

While we concentrate on releasing minimalistic, self-contained packages
for every Rakudo release, Rakudo Star does release quarterly and it
includes a wide selection of third pary modules. On Linux, it uses
the development tool [rakudobrew](https://github.com/tadzik/rakudobrew)
to locally compile the Rakudo compiler and the modules.

## What about packages provided by Operating Systems?

Our packages do not interfere with the packages included in Linux
distributions and can be installed at the same time. Distribution packages
that integrate with the Operating System are often a good choice. That said,
Perl 6 reached language stability very recently. Packages that date from
sources before December 2015 should be considered beta (Rakudo is a lot
slower and some features where removed or added in the language). Perl 6 and
Rakudo are evolving very fast, getting better and faster. So, often you'll
need a recent release to use these features.

This is the state of Rakudo packaged by the distribrution themselves:
- Alpine 3.6:    -
- Centos 7:      -
- Fedora 25:     2017.08
- Fedora 26:     2017.08
- Fedora 27:     2017.08
- Debian 8:      2014.07 (avoid, pre [Christmas release](https://perl6advent.wordpress.com/2015/12/25/christmas-is-here/))
- Debian 9:      2016.12 (use with care, pre breaking [IO changes](http://rakudo.org/2017/04/02/upgrade-information-for-changes-due-to-io-grant-work/))
- Ubuntu 14.04: 2013.12 (avoid, pre [Christmas release](https://perl6advent.wordpress.com/2015/12/25/christmas-is-here/))
- Ubuntu 16.04: 2015.11 (avoid, pre [Christmas release](https://perl6advent.wordpress.com/2015/12/25/christmas-is-here/))
- Ubuntu 17.04: 2016.12 (use with care, pre breaking [IO changes](http://rakudo.org/2017/04/02/upgrade-information-for-changes-due-to-io-grant-work/))
- Ubuntu 17.10: 2017.06
