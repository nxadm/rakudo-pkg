# Install the Zef Module Manager

Rakudo takes a different approach than many other languages (including Perl):
modules are by default installed in the home directory of the user.
Accordingly, a script is supplied to install zef this way.

```bash
/opt/rakudo-pkg/bin/install-zef
```

Zef will be installed to `~/.raku/bin/zef` and modules will reside in `~/.raku`.
These instructions are also applicable for the root user.

If you update the package, running the script again will upgrade zef if a
new version was available when the new package was released. Alternatively,
you can upgrade zef through zef:

```
zef upgrade zef
```

If you run a minimalistic system like a container, you can install modules
with the bundled zef installation in `/opt/rakudo-pkg/bin/zef-as-root`, e.g.:

```bash
/opt/rakudo-pkg/bin/zef-as-root install SuperMAIN
```
