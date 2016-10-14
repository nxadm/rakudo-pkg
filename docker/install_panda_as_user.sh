#!/bin/bash

# Perl6 Module Management (https://github.com/tadzik/panda)
# You need Git in order to install and use Panda.

cd /var/tmp
git clone --recursive git://github.com/tadzik/panda.git
cd panda
/opt/rakudo/bin/perl6 bootstrap.pl
rm -rf /var/tmp/panda

echo "panda has been installed to ~/.perl6/bin."
echo "Add ~/.perl6/bin to your PATH."

exit 0
