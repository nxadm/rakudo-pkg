perl -pi -e "s/ccmiscflags  => '-Wextra/ccmiscflags  => '-std=gnu99 -Wextra/" /moarvm/build/setup.pm
grep gnu99 /moarvm/build/setup.pm
