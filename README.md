# rakudo-pkg

`rakudo-pkg` offers native Linux 64-bit packages of the
[Rakudo compiler/runtime for Raku](https://raku.org/) and the
[zef module installer](https://github.com/ugexe/zef). The packages track the
upstream releases closely. Most of the time, the packages will be released on
the same day as the Rakudo sources. At the moment, packages are provided for
Alpine, Debian, EL (RHEL/CentOS/Amazon/Oracle Linux), Fedora, openSUSE,
Ubuntu and their derivatives. Additionally, a relocatable build is also
provided that works universally on all recent Linux distributions without the
need of installation or root privileges.

## Downloads
### OS Repositories
The easiest way to install and update Rakudo is by using the `rakudo-pkg`
repositories (hosted at [CloudSmith](https://cloudsmith.io/)):
- [instructions for Alpine](https://cloudsmith.io/~nxadm-pkgs/repos/rakudo-pkg/setup/#formats-alpine).
- [instructions for Debian/Ubuntu and derivatives](https://cloudsmith.io/~nxadm-pkgs/repos/rakudo-pkg/setup/#formats-deb).
- [instructions for EL (RHEL/CentOS/Amazon/Oracle Linux) and derivatives] and openSUSE (https://cloudsmith.io/~nxadm-pkgs/repos/rakudo-pkg/setup/#formats-rpm).

### Relocatable Builds and direct downloads
- See the [relocatable packages documentation](docs/relocatable.md).
- See the [direct downloads documentation](docs/direct-downloads.md).

## Zef Module Manager
See the [zef documentation](docs/zef.md).

## Add rakudo to the PATH
See the [PATH documentation](docs/path.md).

## Windows Subsystem for Linux (WSL)
See the [WSL documentation](docs/wsl.md).

## Security
See the [security documentation](docs/security.md).

## Using rakudo-pkg for testing upstream Rakudo
See the [devbuild action documentation](docs/devbuild.md).
