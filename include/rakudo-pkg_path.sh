# To be run in /etc/profile.d/
RAKUDO_PATHS=/opt/rakudo-pkg/bin:/opt/rakudo-pkg/share/perl6/bin
if ! echo "$PATH" | /bin/grep -Eq "(^|:)$RAKUDO_PATHS($|:)" ; then
    export PATH="$PATH:$RAKUDO_PATHS"
fi
