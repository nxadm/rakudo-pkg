# rakudo-pkg
Create OS packages for Rakudo using Docker. Work in progress.

The packages are by design minimalisticr: they don't run any pre/post scripts and all the files are installed in /opt/rakudo. You'll have to add /opt/rakudo/bin to your PATH. Add this to your .bashrc (or corresponding environment script for other shells):
```
export PATH=/opt/rakudo/bin:$PATH
```

In /opt/rakudo/bin you'll find two additional scripts to install Perl 6 module managers (both have similar functionalities):
```
install_panda_as_user.sh
install_zef_as_user.sh
```

Look in the bin of this repo for the docker commands to generate packages. At the moment packages for the following distributions can be created:
- Ubuntu 16.04 amd64
- Ubuntu 16.04 i386
