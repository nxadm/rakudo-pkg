# rakudo-pkg
Create OS packages for Rakudo Perl 6 using Docker.

[![Build Status](https://travis-ci.org/nxadm/rakudo-pkg.svg?branch=master)](https://travis-ci.org/nxadm/rakudo-pkg)

## About the packages
The packages are minimalistic by design: they don't run any pre/post scripts
and all the files are installed in /opt/rakudo. You'll have to add
/opt/rakudo/bin to your PATH. Add this to your .bashrc (or corresponding
environment script for other shells):
```
export PATH=/opt/rakudo/bin:$PATH
```

In /opt/rakudo/bin you'll find two additional scripts to install Perl 6 module
managers (both have similar functionalities):
```
install_panda_as_user.sh
install_zef_as_user.sh
```

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
-v $(pwd)/../pkgs:/pkgs \
-e VERSION_MOARVM=2016.08 \
-e VERSION_NQP=2016.08.1 \
-e VERSION_RAKUDO=2016.08.1 \
-e REVISION=01 \
rakudo/pkgrakudo-ubuntu-amd64:16.04
```

-v provides an external volume were the packages will be created. Look in the
pkgs directory for the generated native packages.
-e are the versions and revision mentioned above.
The last line sets the image you want to use for the creation of packages.
At the moment, the following packaging images are available:
- rakudo/pkgrakudo-ubuntu-amd64:16.04
- rakudo/pkgrakudo-ubuntu-i386:16.04
- rakudo/pkgrakudo-centos-amd64:7

## Suplied scripts
In bin you'll find a wrapper scripts for the above commands, e.g.
```
./run_pkgrakudo.pl -h
./run_pkgrakudo --arch amd64 --os ubuntu --os-version 16.04 --moar 2016.08
--nqp 2016.08.1 --rakudo 2016.08.1 --pkg-rev 01
```

There is also a build script for recreating the images locally in case you
prefer not to use the images on Docker Hub, e.g.:
```
./build_pkgrakudo.pl -h
./build_pkgrakudo.pl --dockerfile ../docker/Dockerfile-ubuntu-amd64-16.04
```

Both script accept and ```--id``` parameter in case you prefer to use your own
Docker ID.

## Contribute
PRs are always welcome! Please add support for your favorite OS packages if
not yet available on this repo.

To add new packaging images, you'll need to:
- start from an existing Dockerfile in the docker directory (this is the docker 
root for all the images).
- the dockerfile should be named as:
    ```Dockerfile-pkgrakudo-<os>-<arch>-<version>```, e.g:
    Dockerfile-pkgrakudo-centos-amd64-7
- add support for the new platform on .travis.yml (Travis CI)

My personal Docker Hub repo (https://hub.docker.com/r/nxadm/) is the
transition repo for new images. Once feature complete, new images move to the
(https://hub.docker.com/r/rakudo/) Docker Hub namespace.
