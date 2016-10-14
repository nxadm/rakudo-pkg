#!/bin/bash -e

# Perl6 Module Management (https://github.com/ugexe/zef)
# You need Git in order to install and use Zef.

cd /var/tmp
git clone https://github.com/ugexe/zef.git
cd zef
/opt/rakudo/bin/perl6 -Ilib bin/zef --install-to=home install .
rm -rf /var/tmp/zef

echo "zef has been installed to ~/.perl6/bin."
echo "Add ~/.perl6/bin to your PATH."

exit 0
