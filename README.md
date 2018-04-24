# rakudo-pkg

[![Build Status](https://travis-ci.org/nxadm/rakudo-pkg.svg?branch=master)](https://travis-ci.org/nxadm/rakudo-pkg)
<br>

## Table of Contents

* [Introduction](#introduction)
* [OS Repositories](#os-repositories)
* [Direct Downloads](#direct-downloads)
* [Set the PATH](#set-the-path)
* [Zef Module Manager as a Regular User](#zef-module-manager-as-a-regular-user)
* [Windows Subsystem for Linux](#windows-subsystem-for-linux)
* [Using rakudo-pkg on Travis](#using-rakudo-pkg-on-travis)
* [Building Your Own Packages](#building-your-own-packages)
* [Contributing](#contributing)
* [Other Rakudo Distributions](#other-rakudo-distributions)

## Introduction

`rakudo-pkg` offers native packages of [Rakudo Perl 6](https://perl6.org/) that
closely follow upstream development. Most of the time, the packages will be
released on the same day as the Rakudo sources. At the moment, packages are
provided for Alpine, CentOS, Debian, Fedora, openSUSE and Ubuntu. Feel free to
[contribute](#contributing) or
[request new packages](https://github.com/nxadm/rakudo-pkg/issues).

`rakudo-pkg` aims to provide small self-contained (no dependencies, no files
outside `/opt/rakudo-pkg`), pre-compiled native OS packages that can be used
on user's computers, servers and --very importantly-- containers. Therefor,
only the Rakudo compiler and the
[Zef package manager](https://github.com/ugexe/zef) are provided. Third
party modules can be easily installed if desired.

From a security point of view, we like to create the builds in the open: the
packages are created, checksummed and automatically uploaded from the code in
this repository by [Travis CI](https://travis-ci.org/nxadm/rakudo-pkg) to
[Github Releases](https://github.com/nxadm/rakudo-pkg/releases) and
[Bintray Repositories](https://bintray.com/nxadm/).

For those users, or rather System Administrators, that prefer to build their
own Rakudo packages, `rakudo-pkg` can be used as a build framework. Because
Docker containers are used when creating native Linux packages, any platform
running Docker can be used as a host, including Linux, MacOS and Windows machines.


## OS Repositories

The easiest way to install the Rakudo on Debian, Centos, Fedora, openSUSE and
Ubuntu is by using the `rakudo-pkg` repositories. For Alpine, see
[Direct Downloads](#direct-downloads).

**You still need to [adjust the PATH](#set-the-path) and optionally
[install zef as a user](#zef-module-manager-as-a-regular-user).**

Repositories:

- To use the repos on Debian and Ubuntu, you need to add the applicable sources:

```bash
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61
$ echo "deb https://dl.bintray.com/nxadm/rakudo-pkg-debs {distribution} main | sudo tee -a /etc/apt/sources.list
```

Replace {distribution} by:
- `jessie` in Debian 8.
- `stretch` in Debian 9.
- `trusty` in Ubuntu 14.04.
- `xenial` in Ubuntu 16.04.
- `artful` in Ubuntu 17.10.

- To use the repos on CentOS, Fedora and openSUSE, you need to add a repofile
(e.g. as `/etc/yum.repositories.d/rakudo-pkg.repo`) with these contents:

```
[rakudo-pkg]
name=rakudo-pkg
baseurl=https://dl.bintray.com/nxadm/rakudo-pkg-rpms/{os}/{release}/x86_64
gpgcheck=0
enabled=1
```

Replace {os} and {release} by:
- `centos` and `7` for CentOS 7.
- `fedora` and `26` for Fedora 26.
- `fedora` and `27` for Fedora 27.
- `opensuse` and `42.3` for openSUSE 42.3.


## Direct Downloads

**You still need to [adjust the PATH](#set-the-path) and optionally
[install zef as a user](#zef-module-manager-as-a-regular-user).**

Most modern computer have a *64-bit* Operating System, so regular users should
use 64-bit packages. The 32-bit are supplied for specific usages, like 32-bit
images on some cloud providers. **32-bit Rakudo is not JIT enabled (upstream)
and as a result a lot slower.**


At the moment the following packages are provided (see the full listing
including older versions in the [releases tab](https://github.com/nxadm/rakudo-pkg/releases)):

- Alpine 3.6 64-bit:
[apk](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=alpine&version=3.6&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=alpine&version=3.6&arch=amd64)).
- Alpine 3.7 64-bit:
[apk](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=alpine&version=3.7&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=alpine&version=3.7&arch=amd64)).
- CentOS 7 64-bit:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=centos&version=7&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=centos&version=7&arch=amd64)).
- Debian 8 64-bit:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=debian&version=8&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=debian&version=8&arch=amd64)).
- Debian 9 64-bit:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=debian&version=9&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=debian&version=9&arch=amd64)).
- Fedora 26 64-bit:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=fedora&version=26&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=fedora&version=26&arch=amd64)).
- Fedora 27 64-bit:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=fedora&version=27&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=fedora&version=27&arch=amd64)).
- openSUSE 42.3 64-bit:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=opensuse&version=42.3&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=opensuse&version=42.3&arch=x86_64)).
- Ubuntu 14.04 64-bit:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=14.04&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=14.04&arch=amd64)).
- Ubuntu 16.04 64-bit:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=16.04&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=16.04&arch=amd64)).
- Ubuntu 17.10 64-bit:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=17.10&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=17.10&arch=amd64)).
- Ubuntu 16.04 32-bit:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=16.04&arch=i386)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=16.04&arch=i386)).
- Ubuntu 17.10 32-bit:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=17.10&arch=i386)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=17.10&arch=i386)).


You can install these package with the regular package manager of your
distribution:

- Alpine:
```
$ sudo apk add --allow-untrusted *.apk
```

- Debian and Ubuntu:

```
$ sudo dpkg -i *.deb
```

- CentOS and Fedora:

```
$ sudo rpm -Uvh *.rpm
```

## Set the PATH

In order to run perl6 by typing `perl6` instead of the full path
`/opt/rakudo-pkg/bin/perl6` you'll have to add the `rakudo-pkg` bin
directories to your `PATH`:

- For bourne derivated shells (like bash), add this to your `.profile`,
`.bash_profile` or the corresponding environment init script for your shell:

```bash
PATH=~/.perl6/bin:/opt/rakudo-pkg/bin:/opt/rakudo-pkg/share/perl6/site/bin:$PATH
export PATH
```

- For zsh, add this to ~/.zshenv or ~/.zprofile, depending on your
distribution:

```zsh
typeset -U path
path=(~/.perl6/bin /opt/rakudo-pkg/bin /opt/rakudo-pkg/share/perl6/site/bin $path[@])
```

## Zef Module Manager as a Regular User

The installation supplies a working *global* Zef installation
(`/opt/rakudo-pkg/bin/zef`). However, Rakudo takes a different
approach to many other languages (including Perl 5): modules are by default
installed the home directory of the user. A script is supplied to install
zef as a user. Zef will be installed to `~/.perl6/bin/zef` and modules will
reside in `~/.perl6`:

```bash
/opt/rakudo-pkg/bin/install-zef-as-user
```

## Windows Subsystem for Linux

If you're using the Windows Subsystem for Linux (aka Bash or Ubuntu on
Windows 10), use the repository or package for the installed Linux
distribution. You'll need to strip the moarvm library of (unused) kernel
functionalities that Windows does not implement yet:

```bash
$ /opt/rakudo-pkg/bin/fix_windows10
```

## Using rakudo-pkg on Travis

You can use rakudo-pkg to speed-up the continuous integration of your Perl 6
module on [Travis](https://travis-ci.org) and other CI systems. Since this
package is going to be downloaded in the install phase, you don't
need to specify a language (by default, it will install Ruby). *Don't*
specify `perl6` since this will download and build perl6 from
source. A valid `.travis.yml` would include:

```
dist: trusty
sudo: required
env:
  global:
    - export PATH="/opt/rakudo-pkg/bin:/opt/rakudo-pkg/share/perl6/site/bin:$PATH"
before_install:
  - set -e
  - sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61
  - echo "deb https://dl.bintray.com/nxadm/rakudo-pkg-debs trusty main | sudo tee -a /etc/apt/sources.list
  - sudo apt-get update && sudo apt-get install rakudo-pkg
```

After this line, you should do `zef install . && zef test .` or whatever else you need to test your package. In case you need an specific version, older
versions are kept in the repository.

## Building your Own Packages

If you prefer to build your own packages instead of the ones offered in the
[releases tab](https://github.com/nxadm/rakudo-pkg/releases), you can use
the wrapper scripts supplied in bin.

### Create a Build Image for the Desired distribution:

```bash
$ bin/create-img.p6
$ bin/create-img.p6 <docker-file>
$ bin/create-img.p6 docker/Dockerfile-ubuntu-amd64-16.04
```

Distributions do not provide i386 images by default. The Ubuntu Dockerfiles
use the nxadm/ubuntu-i386:<version> base images. If you want to build your
own locally, you can use the supplied script:

```bash
$ bin/create-baseimg.p6
$ bin/create-baseimg.p6 <Ubuntu release>
$ bin/create-baseimg.p6 17.10
```

### Create a Package:

```bash
$ bin/create-pkg.p6
$ bin/create-pkg.p6 <docker image> --rakudo-version=<version>
$ bin/create-pkg.p6 rakudo-pkg/ubuntu-amd64:16.04 --rakudo-version=2017.09 --moarvm-version=2017.09.1
```

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md).

## Other Rakudo Distributions

### What about packages provided by Operating Systems?

Our packages do not interfere with the packages included in Linux
distributions and can be installed at the same time. Distribution packages
that integrate with the Operating System are often a good choice. That said,
Perl 6 reached language stability very recently. Packages that date from
sources before December 2015 should be considered beta (Rakudo is a lot
slower and some features where removed or added in the language). Perl 6 and
Rakudo are evolving very fast, getting better and faster. So, often you'll
need a recent release to use these features.

This is the state of Rakudo packaged by the distribution themselves:
- Alpine 3.6:    -
- Alpine 3.7:    -
- CentOS 7:      -
- Debian 8:      2014.07 (avoid, pre [Christmas release](https://perl6advent.wordpress.com/2015/12/25/christmas-is-here/))
- Debian 9:      2016.12 (use with care, pre breaking [IO changes](http://rakudo.org/2017/04/02/upgrade-information-for-changes-due-to-io-grant-work/))
- Fedora 26:     2017.08
- Fedora 27:     2017.08
- openSUSE 42.3: -
- Ubuntu 14.04: 2013.12 (avoid, pre [Christmas release](https://perl6advent.wordpress.com/2015/12/25/christmas-is-here/))
- Ubuntu 16.04: 2015.11 (avoid, pre [Christmas release](https://perl6advent.wordpress.com/2015/12/25/christmas-is-here/))
- Ubuntu 17.10: 2017.06

## What about Rakudo Star?

[Rakudo Star for Linux](https://github.com/rakudo/star) is certainly a
distribution for end-users worth exploring. It has a very different
use case in mind than `rakudo-pkg`, however.

While we concentrate on releasing minimalistic, self-contained packages
for every Rakudo release, Rakudo Star does release quarterly and it
includes a wide selection of third party modules. On Linux, it uses
the development tool [rakudobrew](https://github.com/tadzik/rakudobrew)
to locally compile the Rakudo compiler and the modules.

