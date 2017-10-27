# rakudo-pkg

[![Build Status](https://travis-ci.org/nxadm/rakudo-pkg.svg?branch=master)](https://travis-ci.org/nxadm/rakudo-pkg)
<br>

**If you're an end-user looking for native Rakudo Linux packages (debs and
rpms), you can use the direct links to the latest package for your Operating
System [below](#about-the-packages) or get the full listing in the
[releases tab](https://github.com/nxadm/rakudo-pkg/releases).**

rakudo-pkg offers native packages of [Rakudo Perl 6](https://perl6.org/) for
end users. At the same time it's a framework that allows end-users and system
administrators to create their own OS-native Rakudo Perl 6 packages in case
they prefer not to use the precompiled binaries. Because Docker containers are
used, all the packages can created on any recent Linux environment.

The main difference with [Rakudo Star for Linux](https://github.com/rakudo/star)
is that rakudo-pkg provides pre-compiled packages of the Rakudo runtime only.
Rakudo Star is a collection of Rakudo and popular modules, both compiled
locally at installation time.

The objective of our approach is to create small self-contained, native OS
packages that can be used on user's computers, servers and
--very importantly-- containers. A script is included to install
zef, the Perl 6 module package manager.

## About the packages
The packages are minimalistic by design: they don't run any pre/post scripts
and all the files are installed in /opt/rakudo.

At the moment the following packages are provided (also available in the ([releases tab](https://github.com/nxadm/rakudo-pkg/releases)):
- Centos 7 amd64:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=centos&version=7&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=centos&version=7&arch=amd64)).
- Debian 8 amd64:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=debian&version=8&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=debian&version=8&arch=amd64)).
- Debian 9 amd64:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=debian&version=9&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=debian&version=9&arch=amd64)).
- Fedora 25 amd64:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=fedora&version=25&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=fedora&version=25&arch=amd64)).
- Fedora 26 amd64:
[rpm](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=fedora&version=26&arch=x86_64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=fedora&version=26&arch=amd64)).
- Ubuntu 14.04 amd64:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=14.04&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=14.04&arch=amd64)).
- Ubuntu 16.04 amd64:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=16.04&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=16.04&arch=amd64)).
- Ubuntu 17.04 amd64:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=17.04&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=17.04&arch=amd64)).
- Ubuntu 17.10 amd64:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=17.10&arch=amd64)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=17.10&arch=amd64)).
- Ubuntu 16.04 i386:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=16.04&arch=i386)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=16.04&arch=i386)).
- Ubuntu 17.04 i386:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=17.04&arch=i386)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=17.04&arch=i386)).
- Ubuntu 17.10 i386:
[deb](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=ubuntu&version=17.10&arch=i386)
([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=ubuntu&version=17.10&arch=i386)).

  <br>Beware that 32-bit rakudo binaries (i386) are not JIT enabled (upstream).

You'll have to add /opt/rakudo/bin to your PATH. Add this to your .bashrc
(or corresponding environment script for other shells):

```
export PATH=/opt/rakudo/bin:$PATH
```

## Install the Zef Module Manager and modules
In /opt/rakudo/bin you'll find two additional scripts to install the Zef Perl 6 module
manager:

```
install_zef_as_user: install it in ~/.perl6
install_zef_as_root: install it in /opt/rakudo as root (use sudo)
```

You'll need to add the bin directories to your PATH (as the scripts will print).

## Support for the Windows Subsystem for Linux
If you're using the Windows Subsystem for Linux (aka Ubuntu on Windows 10), you
need to strip the moarvm library of (unused) functionalities that Windows does
not implement yet. The script is only present on the Ubuntu 16.04 packages:

```
/opt/rakudo/bin/fix_windows10
```

## Building your own packages

If you prefer to build your own packages instead the ones offered in the
[releases tab](https://github.com/nxadm/rakudo-pkg/releases), you can use
the wrapper scripts supplied in bin.

### Create an image for the desired distribution:

```
bin/create-img.p6 <docker-file>
bin/create-img.p6 docker/Dockerfile-ubuntu-amd64-16.04
```

### Create a package:

```
./create-pkg.p6 <docker image> --rakudo-version=<version>
./create-pkg.p6 rakudo-pkg/ubuntu-amd64:16.04 --rakudo-version=2017.09 --moarvm-version=2017.09.1
```

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md).
