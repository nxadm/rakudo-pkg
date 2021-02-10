# Zef Module Manager as a Regular User

The installation supplies a working *global* Zef installation
(`/opt/rakudo-pkg/bin/zef`). However, Rakudo takes a different approach than
many other languages (including Perl): modules are by default installed in the
home directory of the user.

A script is supplied to install zef as a user. Zef will be installed to
`~/.raku/bin/zef` and modules will reside in `~/.raku`:

```bash
/opt/rakudo-pkg/bin/install-zef-as-user
```