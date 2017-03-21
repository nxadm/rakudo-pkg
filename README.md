# rakudo-pkg
Create OS packages for Rakudo Perl 6 using Docker.

[![Build Status](https://travis-ci.org/nxadm/rakudo-pkg.svg?branch=master)](https://travis-ci.org/nxadm/rakudo-pkg)

**If you're an end-user looking for native Rakudo Linux packages, you'll find them here: https://github.com/nxadm/rakudo-pkg/releases**
**In constrast with Rakudo Star, these Rakudo Perl 6 Linux packages are _small_ and _precompiled_ and -by design (e.g. for containers)- don't provide any pre-installed modules. A script to install zef (Perl 6 module package manager) as root and as a user is provided.**

**See the "About the packages" info below for more information**

## About the packages
The packages are minimalistic by design: they don't run any pre/post scripts
and all the files are installed in /opt/rakudo. You'll have to add
/opt/rakudo/bin to your PATH. Add this to your .bashrc (or corresponding
environment script for other shells):
```
export PATH=/opt/rakudo/bin:$PATH
```
## Install the Zef Module Manager and modules
In /opt/rakudo/bin you'll find two additional scripts to install the Zef Perl 6 module
manager:
```
install_zef_as_user.sh: install it in ~/.perl6
install_zef_as_root.sh: install it in /opt/rakudo as root (use sudo)
```
You'll need to add the bin directories to your PATH (as the scripts will print).

You can also install all the modules of the Rakudo::Star distribution by typing:
```
zef install Task::Star
```
## Creating packages locally
If you just want to create native packages, just go to the bin directory and
execute the run_pkgrakudo.pl command. In this case there is no need to
locally build the Docker images: you'll automatically retrieve the image from
the rakudo namespace on Docker Hub. See below (Supplied scripts).

## Creating packages with images on Docker Hub
The docker run command needs 4 environment values (-e) in order to create a
package:
- the moarvm version (e.g. 2016.08)
- the nqp version (e.g. 2016.08.1)
- the rakudo version (e.g. 2016.08.1)
- the package revision (e.g. 01)

A full command looks like this:
```
docker run -ti --rm \
-v <directory for the packages>:/staging \
-e VERSION_MOARVM=2016.08 \
-e VERSION_NQP=2016.08.1 \
-e VERSION_RAKUDO=2016.08.1 \
-e REVISION=01 \
rakudo/pkgrakudo-ubuntu-amd64:16.04
```

-v provides an external volume were the packages will be created. Look in the
staging directory for the generated native packages.
-e are the versions and revision mentioned above.
The last line sets the image you want to use for the creation of packages.
At the moment, the following packaging images are available:
- rakudo/pkgrakudo-ubuntu-amd64:16.04
- rakudo/pkgrakudo-ubuntu-i386:16.04
- rakudo/pkgrakudo-centos-amd64:7

## Suplied scripts
In bin you'll find a wrapper script for the above docker run command, e.g.
```
./run_pkgrakudo.pl -h
./run_pkgrakudo.pl --arch amd64 --os ubuntu --os-version 16.04 --moar 2016.08
--nqp 2016.08.1 --rakudo 2016.08.1 --pkg-rev 01 --dir /var/tmp
```

There is also a build script for recreating the images locally in case you
prefer not to use the images on Docker Hub, e.g.:
```
./build_pkgrakudo.pl -h
./build_pkgrakudo.pl --dockerfile ../docker/Dockerfile-ubuntu-amd64-16.04
```

Both script accept and '--id' parameter in case you prefer to use your own
Docker ID.
