# rakudo-pkg

[![Build Status](https://travis-ci.org/nxadm/rakudo-pkg.svg?branch=master)](https://travis-ci.org/nxadm/rakudo-pkg)
<br>

rakudo-pkg is a framework for easily creating OS-native packages for Rakudo
Perl 6. Because Docker containers are used, all the packages can created on
any recent Linux envrionment.

If you're an end-user looking for native Rakudo Linux packages (debs and
rpms), you'll find them in the [releases tab](https://github.com/nxadm/rakudo-pkg/releases).
The difference with [Rakudo Star for Linux](https://github.com/rakudo/star) is
that that distribution does not provide pre-compiled packages (it compiles
Rakudo at install time) and that it contains a selection of modules. The objective
of our packages it to be small by design (e.g. usable in Docker). In consequence,
they don't provide any pre-installed modules. A script is included
to install zef, the Perl 6 module package manager.

## About the packages
The packages are minimalistic by design: they don't run any pre/post scripts
and all the files are installed in /opt/rakudo.

At the moment the following packages are provided:
- Centos (amd64): 7
- Debian (amd64): 8, 9
- Fedora (amd64): 25, 26
- Ubuntu (amd64): 16.04, 16.10 (EOL), 17.04, 17.10
- Ubuntu (i386) : 16.04, 16.10 (EOL), 17.04, 17.10<br>
  Beware that 32-bit rakudo binaries are not JIT enabled (upstream).

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

If you're using the Windows Subsystem for Linux (aka Ubuntu on Windows 10), you
need to strip the moarvm library of (unused) functionalities that Windows does
not implement yet. The script is only present on the Ubuntu 16.04 packages:

```
/opt/rakudo/bin/fix_windows10
```

You'll need to add the bin directories to your PATH (as the scripts will print).

## Building your own packages

If you prefer to build your own packages instead the ones offered in the
[releases tab](https://github.com/nxadm/rakudo-pkg/releases), you can use
the wrapper scripts supplied in bin.

### Create an image for the desired distribution:

```
./create_container.pl -h
./create_container.pl --dockerfile ../docker/Dockerfile-ubuntu-amd64-16.04
```

### Create a package:

```
./pkg_rakudo.pl -h
./pkg_rakudo.pl --os ubuntu --os-version 16.04 --rakudo 2016.07 --pkg-rev 01 --dir /var/tmp
```
## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md).
