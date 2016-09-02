# rakudo-pkg
Create OS packages for Rakudo using Docker. Work in progress.

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
execute the run_*.sh commands. In this case there is no need to locally build
the Docker images. See below (Supplied scripts).

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
rakudo/pkgrakudo-ubuntu16.04-amd64
```

-v provides an external volume were the packages will be created. Look in the
pkgs directory for the generated native packages.
-e are the versions and revision mentioned above.
The last line sets the image you want to use for the creation of packages.
At the moment, the following packaging images are available:
- rakudo/pkgrakudo-ubuntu16.04-amd64
- rakudo/pkgrakudo-ubuntu16.04-i386
- rakudo/pkgrakudo-centos7-amd64

## Suplied scripts
In bin you'll find easy wrapper scripts for the above commands, e.g.
```
./run_pkgrakudo-ubuntu16.04-amd64.sh 2016.08 2016.08.1 2016.08.1 01
./run_pkgrakudo-ubuntu16.04-i386.sh 2016.08 2016.08.1 2016.08.1 01
./run_pkgrakudo-centos7-amd64.sh 2016.08 2016.08.1 2016.08.1 01
```

There are also build scripts for recreating the images locally in case you
prefer not to use the images on Docker Hub, e.g.:
```
./build_pkgrakudo-ubuntu16.04-amd64.sh
./build_pkgrakudo-ubuntu16.04-i386.sh
./build_pkgrakudo-centos7-amd64.sh
```
This will create an nxadm/pkgrakudo-ubuntu16.04-amd64 image locallyi, by
default under the rakudo docker id. If you have a Docker ID, you can supply it:

```
./build_pkgrakudo-ubuntu16.04-amd64.sh your_docker_id
./build_pkgrakudo-ubuntu16.04-i386.sh your_docker_id
./build_pkgrakudo-centos7-amd64.sh your_docker_id
```

## Contribute
PRs are always welcome! Please add support for your favorite OS packages if
not yet available on this repo.

To add new packagin images, you'll need to:
- start from an existing Dockerfile in bin.
- the dockerfile should be named as:
    Dockerfile-pkgrakudo-<OS and Major Version>-arch, e.g:
    Dockerfile-pkgrakudo-centos7-amd64
- add a symlink in bin to the templates files, e.g:
    ```
    ln -s template_build_pkgrudo.sh build_pkgrakudo-centos7-amd64.sh
    ln -s template_run_pkgrudo.sh run_pkgrakudo-centos7-amd64.sh
    ```
My personal Docker Hub repo (nxadm/* ) is the transition repo for new images.
Once feature complete, new images move to the rakudo/* Docker Hub namespace.
