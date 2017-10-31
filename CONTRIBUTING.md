# Contribute

PRs or issues are always welcome!

If your favorite distribution is not yet supported, you can add it yourself:
- start from an existing and possibly related Dockerfile in the docker directory (this is the docker context) and name is as Dockerfile-\<os\>-\<arch\>-\<version\>, e.g: Dockerfile-centos-amd64-7.
- all the packages built by a docker container run the same docker/pkg_rakudo
script. It should stay as generic as possible and valid on all the target OS'es it run (Travis is a big help here). 
- add support for the new platform on .travis.yml (Travis CI).
