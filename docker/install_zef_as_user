#!/bin/bash -e

# Perl6 Module Management (https://github.com/ugexe/zef)
# You need Git in order to install and use Zef.

cd /var/tmp
rm -rf /var/tmp/zef_$USER
git clone https://github.com/ugexe/zef.git zef_$USER
cd zef_$USER
/opt/rakudo/bin/perl6 -Ilib bin/zef --install-to=home install .
rm -rf /var/tmp/zef_$USER

echo "zef has been installed to ~/.perl6/bin."
echo "Add /opt/rakudo/bin and ~/.perl6/bin to your PATH, e.g.:"
echo "echo 'export PATH=/opt/rakudo/bin:~/.perl6/bin:\$PATH' >> ~/.bash_profile"

exit 0
