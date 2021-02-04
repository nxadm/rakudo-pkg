# Relocatable Builds
Relocatable builds can be uncompressed and used right away, e.g. in your home
directory. No administrator privileges are needed. `rakudo-pkg` "\*.tar.gz"
releases can be downloaded from
[Github releases](https://github.com/nxadm/rakudo-pkg/releases).

The relocable builds work on distributions with a glibc at the same
level or newer than Ubuntu 16.04 (released in April 2016).

```
tar xvzf *.tar.gz
cd rakudo-pkg
raku -v
```