# rakudo-pkg
Create OS packages for Rakudo using Docker. Work in progress.

The packages are by design minimalisticr: they don't run any pre/post scripts and all the files are installed in /opt/rakudo. You'll have to add /opt/rakudo/bin to your PATH. Add this to your .bashrc (or corresponding environment script for other shells):
```
export PATH=/opt/rakudo/bin:$PATH
```

Look in bin of this repo for the docker commands to generate packages. So far:
- Ubuntu 16.04 amd64
- Ubuntu 16.04 i386
