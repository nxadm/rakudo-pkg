#!/bin/bash -e

# Perl6 Module Management (https://github.com/ugexe/zef)
# You need Git in order to install and use Zef.

cd /var/tmp
rm -rf /var/tmp/zef_root
git clone https://github.com/ugexe/zef.git zef_root
cd zef_root
/opt/rakudo/bin/perl6 -Ilib bin/zef --install-to=perl install .
rm -f /opt/rakudo/bin/zef
ln -s /opt/rakudo/share/perl6/bin/zef /opt/rakudo/bin/zef
rm -rf /var/tmp/zef_root

echo "zef has been installed to /opt/rakudo/bin."
echo "Add /opt/rakudo/bin to your PATH, e.g.:"
echo "echo 'export PATH=/opt/rakudo/bin:\$PATH' >> /root/.profile"

exit 0
