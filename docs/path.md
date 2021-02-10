# Add rakudo to the PATH
The path is set by setting a rakudo-pkg.sh profile file in `/etc/profile.d`
and will be active once you log in again. Source the package if you want to
activate the changes in your running session:
```
. /etc/profile.d/rakudo-pkg.sh
```

Alternatively, a script is supplied to do this automatically for you in the
user profile. Run it as your regular user:
```bash
$ /opt/rakudo-pkg/bin/add-rakudo-to-path
```

See the PATH in the (short) script if you prefer to set the PATH manually.