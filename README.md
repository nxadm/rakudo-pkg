# rakudo-pkg

## Table of Contents

* [Introduction](#introduction)
* [Relocatable Builds](#relocatable-builds)
* [OS Repositories](#os-repositories)
* [Direct Downloads](#direct-downloads)
* [Set the PATH](#set-the-path)
* [Zef Module Manager as a Regular User](#zef-module-manager-as-a-regular-user)
* [Windows Subsystem for Linux](#windows-subsystem-for-linux)
* [Using rakudo-pkg for module CI](#using-rakudo-pkg-for-module-CI)
* [Using rakudo-pkg for testing upstream Rakudo](#using-rakudo-pkg-for-testing-upstream-rakudo)
* [Contributing](#contributing)

## Introduction

`rakudo-pkg` offers native packages (OS packages and relocatable builds) of
the [Rakudo compiler for Raku](https://raku.org/) and the
[zef nodule installer](https://github.com/ugexe/zef). The packages track the
upstream releases closely. Most of the time, the packages will be released on
the same day as the Rakudo sources. At the moment, packages are provided for
Alpine, CentOS, Debian, Fedora, openSUSE, RHEL and Ubuntu. The relocatable
builds (`tar xvzf` and use) work universally on all recent Linux distributions.

From a security point of view, the packages are created, checksummed and
automatically uploaded from the code in this repository by
[Github Actions](https://github.com/nxadm/rakudo-pkg/actions) to
[Github Releases](https://github.com/nxadm/rakudo-pkg/releases) and
[Bintray Repositories](https://bintray.com/nxadm/).

## Relocatable Builds

Relocatable builds can be uncompressed and used right away, e.g. in your home
directory. `rakudo-pkg` "\*.tar.gz" releases can be downloaded from the
[the Github tab](https://github.com/nxadm/rakudo-pkg/releases).

The relocable builds work on distributions with a glibc at the same
level or newer than Ubuntu 16.04 (released in April 2016).

## OS Repositories

The easiest way to install the Rakudo on Debian, CentOS, Fedora, openSUSE, RHEL
and Ubuntu (and their derivatives) is by using the `rakudo-pkg`
repositories. For Alpine and manual downloads, see
[Direct Downloads](#direct-downloads).

### Debian, Ubuntu, LMDE and Mint

To use the repos on Debian and Ubuntu, you need to add the applicable sources:

```bash
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61
$ echo "deb https://dl.bintray.com/nxadm/rakudo-pkg-debs `lsb_release -cs` main" | sudo tee -a /etc/apt/sources.list.d/rakudo-pkg.list
$ sudo apt-get update && sudo apt-get install rakudo-pkg
```

If you don't have `lsb_release` installed, you can use the OS codename (e.g.,
stretch, bionic, etc.) instead of the `lsb_release -cs` command.

### Centos, Fedora and RHEL

To use the repos on CentOS, Fedora and RHEL, you need to a repofile:

```
$ echo -e "[rakudo-pkg]\nname=rakudo-pkg\nbaseurl=https://dl.bintray.com/nxadm/rakudo-pkg-rpms/`lsb_release -is`/`lsb_release -rs| cut -d. -f1`/x86_64\ngpgcheck=0\nenabled=1" | sudo tee -a /etc/yum.repos.d/rakudo-pkg.repo
```

If you don't have `redhat-lsb-core` installed, you can use the OS name (e.g.,
CentOS, Fedora) instead of the `lsb_release -is` command and release (e.g. 7,
26, 27, 28) instead of the one with `-rs`.

Install the package on CentOS 7:
```
$ sudo yum install rakudo-pkg
```

Install the package on recent CentOS, Fedora and RHEL:
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
version (e.g. 15.2) instead of the `lsb_release -rs` command.

### Alpine

There is no Alpine repo at the moment. The apk packages can be downloaded from
the [releases tab](https://github.com/nxadm/rakudo-pkg/releases).

## Direct Downloads

You can install the downloaded packages from the
[releases tab](https://github.com/nxadm/rakudo-pkg/releases) by using the
regular package installer of your distribution:
ackage manager of your distribution:


- Alpine:

```
$ sudo apk add --allow-untrusted *.apk
```

- Debian and Ubuntu:

```
$ sudo dpkg -i *.deb
```

- CentOS, Fedora, openSUSE and RHEL:

```
$ sudo rpm -Uvh *.rpm
```

## Set the PATH

The path is set by setting a rakudo-pkg.sh profile file in `/etc/profile.d` and
will be active once you log in again. Source the package if you want to
activate the changes in your running session;

```
. /etc/profile.d/rakudo-pkg.sh
```

Alternatively, a script is supplied to do this automatically for you in the
user profile. Run it as your regular user:

```bash
$ /opt/rakudo-pkg/bin/add-rakudo-to-path
```

See the PATH in the short script if you prefer to set the PATH manually.

## Zef Module Manager as a Regular User

The installation supplies a working *global* Zef installation
(`/opt/rakudo-pkg/bin/zef`). However, Rakudo takes a different approach than
many other languages (including Perl): modules are by default installed in the
home directory of the user.

A script is supplied to install zef as a user. Zef will be installed to
`~/.raku/bin/zef` and modules will reside in `~/.raku`:

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

## Using rakudo-pkg for CI

You can use rakudo-pkg to speed-up the continuous integration of your Raku
modules on Github Actions and other CI systems.

An example step using the action
[add-deb-repo](https://github.com/marketplace/actions/add-debian-repository):

```
- name: install rakudo-pkg
  env:
  PATH: "/opt/rakudo-pkg/bin:/opt/rakudo-pkg/share/perl6/site/bin:$PATH"
  uses: myci-actions/add-deb-repo@4
  with:
    # Beware: soon bionic will be replace by focal on Github Actions
    repo: deb https://dl.bintray.com/nxadm/rakudo-pkg-debs $(lsb_release -cs) main
    repo-name: rakudo-pkg
    keys: 0x379CE192D401AB61
    key-server: keyserver.ubuntu.com
```

After this step you should run `zef install . && zef test .` or whatever else
is needed to install and test your package.

## Using rakudo-pkg for testing upstream Rakudo
This repo does not only build and package Rakudo releases but works also for
specific commits on all the included components. Just fork this repo, and
change the [config/versions.sh](config/versions.sh) to what you want to test:

```sh
$ cat config/versions.sh
# The versions set in this file are used to download, build and package rakudo.
# By prepending a commit with "@", you can build specific commit of each
# component, e.g. RAKUDO_VERSION=@0c8d238a8c8dd2a22c5c23530fdc198be60ed63d
RAKUDO_VERSION=2020.12
NQP_VERSION=2020.12
MOARVM_VERSION=2020.12
ZEF_VERSION=0.11.2
PKG_REVISION=01
NFPM_VERSION=2.2.3
```

## Contributing

Issues (bugs and ideas) and PRs are always welcome. See
[CONTRIBUTING.md](CONTRIBUTING.md).
