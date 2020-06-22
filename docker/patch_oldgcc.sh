perl -pi -e "s/\bccmiscflags\w+=>\w+'-Wextra\b/ccmiscflags  => '-std=gnu99 -Wextra/" build/setup.pm
