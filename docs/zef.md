# Zef Module Manager as a Regular User

Rakudo takes a different approach than many other languages (including Perl):
modules are by default installed in the home directory of the user.
Accordingly, a script is supplied to install zef this way. 

```bash
/opt/rakudo-pkg/bin/install-zef-as-user
```

Zef will be installed to `~/.raku/bin/zef` and modules will reside in `~/.raku`.