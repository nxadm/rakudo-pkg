# rakudo-pkg

## Table of Contents

* [Introduction](#introduction)
* [Relocatable Builds](#relocatable-builds)
* [OS Repositories](#os-repositories)
* [Direct Downloads](#direct-downloads)
* [Set the PATH](#set-the-path)
* [Zef Module Manager as a Regular User](#zef-module-manager-as-a-regular-user)
* [Windows Subsystem for Linux](#windows-subsystem-for-linux)
* [Using rakudo-pkg on Travis](#using-rakudo-pkg-on-travis)
* [Building Your Own Packages](#building-your-own-packages)
* [Other Rakudo Distributions](#other-rakudo-distributions)
* [Contributing](#contributing)

## Introduction

`rakudo-pkg` offers native packages (OS packages and relocatable builds) of
the [Rakudo compiler for Raku](https://raku.org/). The packages track the
upstream releases closely. Most of the time, the packages will be released on
the same day as the Rakudo sources. At the moment, packages are provided for
Alpine, CentOS, Debian, Fedora, openSUSE, RHEL and Ubuntu. The relocatable
builds (`tar xvzf` and use) work universally on all recent Linux distributions.

Feel free to [contribute](#contributing) or
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
running Docker can be used as a host, including Linux, MacOS and Windows
machines.

## Relocatable Builds

Relocatable builds can be uncompressed and used right away, e.g. in your home
directory. `rakudo-pkg` "\*.tar.gz" releases can be downloaded from the
[the Github tab](https://github.com/nxadm/rakudo-pkg/releases) and, as a
backup from
[the Bintray repo](https://dl.bintray.com/nxadm/rakudo-pkg-relocatable/).

The relocable builds work on distributions with a glibc at the same
level or newer than Ubuntu 16.04 (released in April 2016).

## OS Repositories

The easiest way to install the Rakudo on Debian, CentOS, Fedora, openSUSE and
Ubuntu (and their derivatives) is by using the `rakudo-pkg`
repositories. For Alpine, see [Direct Downloads](#direct-downloads).

**Optionally you can [install zef as a user](#zef-module-manager-as-a-regular-user).**

### Debian, Ubuntu, LMDE and Mint

To use the repos on Debian and Ubuntu, you need to add the applicable sources:

```bash
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61
$ echo "deb https://dl.bintray.com/nxadm/rakudo-pkg-debs `lsb_release -cs` main" | sudo tee -a /etc/apt/sources.list.d/rakudo-pkg.list
$ sudo apt-get update && sudo apt-get install rakudo-pkg
```

If you don't have `lsb_release` installed, you can use the OS codename (e.g.,
stretch, bionic, etc.) instead of the `lsb_release -cs` command.

### Centos and Fedora

To use the repos on CentOS, Fedora and openSUSE, you need to a repofile:

```
$ echo -e "[rakudo-pkg]\nname=rakudo-pkg\nbaseurl=https://dl.bintray.com/nxadm/rakudo-pkg-rpms/`lsb_release -is`/`lsb_release -rs| cut -d. -f1`/x86_64\ngpgcheck=0\nenabled=1" | sudo tee -a /etc/yum.repos.d/rakudo-pkg.repo
```

If you don't have `redhat-lsb-core` installed, you can use the OS name (e.g.,
CentOS, Fedora) instead of the `lsb_release -is` command and release (e.g. 7,
26, 27, 28) instead of the one with `-rs`.

Install the package on CentOS:
```
$ sudo yum install rakudo-pkg
```

Install the package on Fedora:
```
$ sudo dnf install rakudo-pkg
```

### openSUSE

To use the repos on openSUSE, you need to add a repo to zypper (accept the
key):

```
$ sudo zypper ar -f https://dl.bintray.com/nxadm/rakudo-pkg-rpms/openSUSE/`lsb_release -rs`/x86_64 rakudo-pkg
$ sudo zypper install rakudo-pkg
```

In case you don't have `lsb-release` installed, you can put the openSUSE
version (e.g. 42.3) instead of the `lsb_release -rs` command.

### Alpine

There is no Alpine repo at the moment. The apk packages can be downloaded from
the [releases tab](https://github.com/nxadm/rakudo-pkg/releases).

## Direct Downloads

Most modern computers have a *64-bit* Operating System, so regular users should
use 64-bit packages. The 32-bit are supplied for specific usages, like 32-bit
images on some cloud providers. **32-bit Rakudo is not JIT enabled (upstream)
and as a result a lot slower.**

See the [releases tab](https://github.com/nxadm/rakudo-pkg/releases) for the
latest packages. You can install the downloaded packages with the regular
package manager of your distribution:


- Alpine:

```
$ sudo apk add --allow-untrusted *.apk
```

- Debian and Ubuntu:

```
$ sudo dpkg -i *.deb
```

- CentOS, Fedora and openSUSE:

```
$ sudo rpm -Uvh *.rpm
```

## Set the PATH

The path is set by setting a rakudo-pkg.sh profile file in /etc/profile.d. If
raku/perl6 is in your path (type `raku -v`) you can stop reading this section
and enjoy raku.

Alternatively, a script is supplied to do this automatically for you. Run it
as your regular user:

```bash
$ /opt/rakudo-pkg/bin/add-rakudo-to-path
```

If you prefer, you can change the PATH manually. Be aware that environment
files start with a '.' and are hidden by convention on graphical file browsers:

- For bourne derivated shells (like bash), add this to your `.profile`,
`.bash_profile` or the corresponding environment init script for your shell:

```bash
PATH=~/.raku/bin:/opt/rakudo-pkg/bin:/opt/rakudo-pkg/share/perl6/site/bin:$PATH
export PATH
```

- For zsh, add this to ~/.zshenv or ~/.zprofile, depending on your
distribution:

```zsh
path=(~/.raku/bin /opt/rakudo-pkg/bin /opt/rakudo-pkg/share/perl6/site/bin $path[@])
```

## Zef Module Manager as a Regular User

The installation supplies a working *global* Zef installation
(`/opt/rakudo-pkg/bin/zef`). However, Rakudo takes a different
approach to many other languages (including Perl 5): modules are by default
installed the home directory of the user. A script is supplied to install
zef as a user. Zef will be installed to `~/.raku/bin/zef` and modules will
reside in `~/.raku`:

```bash
/opt/rakudo-pkg/bin/install-zef-as-user
```

## Windows Subsystem for Linux

If you're using the Windows Subsystem for Linux (aka Bash or Ubuntu on
Windows 10), use the repository or package for the installed Linux
distribution. You'll need to strip the moarvm library of (unused) kernel
functionalities that Windows does not implement yet:

```bash
$ /opt/rakudo-pkg/bin/fix-windows10
```

## Using rakudo-pkg on Travis

You can use rakudo-pkg to speed-up the continuous integration of your Raku
modules on [Travis](https://travis-ci.org) and other CI systems. Since this
package is going to be downloaded in the install phase, you don't
need to specify a language (by default, it will install Ruby). *Don't*
specify `perl6` since this will download and build it from source. Note
that rakudo-pkg does not exist for Precise Pangolin, so use trusty(default)
or newer.

A valid `.travis.yml` would be:

```
language: generic
env:
  global:
    - export PATH="/opt/rakudo-pkg/bin:/opt/rakudo-pkg/share/perl6/site/bin:$PATH"
addons:
  apt:
    sources:
      - sourceline: 'deb https://dl.bintray.com/nxadm/rakudo-pkg-debs $(lsb_release -cs) main'
        key_url: 'http://keyserver.ubuntu.com/pks/lookup?search=0x379CE192D401AB61&op=get'
    packages:
      - rakudo-pkg
install:
  - zef install .
```

After this line, you should do `zef install . && zef test .` or whatever else you need to test your package. In case you need an specific version, older
versions are kept in the repository.

## Building your Own Packages

If you prefer to build your own packages instead of the ones offered in the
[releases tab](https://github.com/nxadm/rakudo-pkg/releases), you can use the
images from the [DockerHub](https://hub.docker.com/r/nxadm/rakudo-pkg). The
image name is `nxadm/rakudo-pkg` while where every
[image tag](https://hub.docker.com/r/nxadm/rakudo-pkg/tags/) corresponds with
an specific OS-Release-Architecture combination. Alternatively, you can build
them with the Dockerfiles in the `docker` directory.

### Ubuntu 32-bit base images

Ubuntu does not release 32-bit base images. An script is supplied to build
them from official sources.

```bash
$ bin/create-baseimg.p6
$ bin/create-baseimg.p6 <Ubuntu release>
$ bin/create-baseimg.p6 18.04
```

### Create a Package:

You need to supply the necessary environment variables to Docker:

```bash
$ docker run -ti --rm -v /var/tmp:/staging -e RAKUDO_VERSION=$RAKUDO_VERSION -e NQP_VERSION=$NQP_VERSION -e MOARVM_VERSION=$MOARVM_VERSION -e ZEF_VERSION=$ZEF_VERSION -e REVISION=$REVISION -e OS=$OS -e RELEASE=$RELEASE -e ARCH=$ARCH -e MAINTAINER=$MAINTAINER nxadm/rakudo-pkg:$TAG
```

## Other Rakudo Distributions

### What about packages provided by Operating Systems?

Our packages do not interfere with the packages included in Linux
distributions and can be installed at the same time. Distribution packages
that integrate with the Operating System are often a good choice. That said,
Raku (previously Perl 6) reached language stability very recently. Packages
that date from sources before December 2015 should be considered beta (Rakudo
is a lot slower and some features where removed or added in the language).
Raku and Rakudo are evolving very fast, getting better and faster. So, often
you'll need a recent release to use these features.

This is the state of Rakudo packaged by the distribution themselves:
- Alpine 3.11:   -
- Alpine 3.10:   -
- Alpine 3.10:   -
- Alpine 3.9:    -
- Alpine 3.8:    -
- CentOS 8:      -
- CentOS 7:      -
- Debian 10:     2018.05
- Debian 9:      2016.12 (avoid, predates [the breaking IO changes](http://rakudo.org/2017/04/02/upgrade-information-for-changes-due-to-io-grant-work/))
- Debian 8:      2014.07 (avoid, predates [the Christmas release](https://perl6advent.wordpress.com/2015/12/25/christmas-is-here/))
- Fedora 32:     2020.02
- Fedora 31:     2019.03
- Fedora 30:     2019.03
- openSUSE 15.1: 2019.03
- Ubuntu 20.04:  2019.11
- Ubuntu 19.10:  2018.12
- Ubuntu 18.04:  2018.03
- Ubuntu 16.04:  2015.11 (avoid, predates [the Christmas release](https://perl6advent.wordpress.com/2015/12/25/christmas-is-here/))

### What about Rakudo Star?

[Rakudo Star for Linux](https://github.com/rakudo/star) is certainly a
distribution for end-users worth exploring. It has a very different use case
in mind than `rakudo-pkg`, however. While we concentrate on releasing
minimalistic, self-contained packages for every Rakudo release (monthly),
Rakudo Star releases quarterly and it includes a wide selection of third party
modules. On Linux, it does not provide binaries. Instead it locally compiles
the Rakudo compiler and the third party modules.

## Contributing

Issues (bugs and ideas) and PRs are always welcome. See
[CONTRIBUTING.md](CONTRIBUTING.md).
