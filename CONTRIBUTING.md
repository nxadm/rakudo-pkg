# Contribute

PRs are always welcome! Please add support for your favorite OS packages if
not yet available on this repo.

To add new packaging images, you'll need to:
- start from an existing Dockerfile in the docker directory (this is the docker
root for all the images).
- the dockerfile should be named as
Dockerfile-pkgrakudo-\<os\>-\<arch\>-\<version\>, e.g:
Dockerfile-pkgrakudo-centos-amd64-7
- the docker/pkg_rakudo script is a short and straight-forward script run
by all containers. This script must stay generic and valid on all the target OSes it runs.
- add support for the new platform on .travis.yml (Travis CI)
