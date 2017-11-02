# Contribute

PRs or issues are always welcome!

If your favorite distribution is not yet supported, you can add it yourself:
- start from an existing and possibly related Dockerfile in the docker
directory (this is the docker context) and name is as
_Dockerfile-\<os\>-\<arch\>-\<version\>_, e.g: _Dockerfile-centos-amd64-7_.
- add support to the distribution in _docker/pkg_rakudo.pl_. This script is
run inside the different containers and should be generic.
- add support for the new platform on .travis.yml (Travis CI).
