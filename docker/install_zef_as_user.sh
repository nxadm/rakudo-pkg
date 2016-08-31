#!/bin/bash -e

# Perl6 Module Management (https://github.com/ugexe/zef)
# You need Git in order to install and use Zef.

cd /var/tmp
git clone https://github.com/ugexe/zef.git
cd zef
perl6 -Ilib bin/zef install .
rm -rf /var/tmp/zef

exit 0
