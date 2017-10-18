#!/usr/bin/perl
# Create pkgrakudo-<os>-<arch>:<os_release> docker images.
# Run with sudo if necessary.
# See create_container.pl -h for parameters.
# https://github.com/nxadm/rakudo-pkg

use warnings;
use strict;
use feature 'say';
use File::Basename qw/basename dirname/;
use Getopt::Long;

### Variables ###
our $VERSION = '0.1.0';
my $format_df    = 'Dockerfile-pkgrakudo-<os>-<arch>-<release>';
my $format_image = 'pkgrakudo-<os>-<arch>:<release>';
my ($file, $root, $release, $image);
my $id = 'rakudo'; # default

### CLI ###
my $help;
GetOptions(
    'dockerfile|d=s' => \$file,
    'id|i=s'         => \$id,
    'help|h'         => \$help,
) or die("Error in command line arguments\n");

help() and exit(0) if ($help || !$file || @ARGV);

my $basename = basename($file);
if (-f $file && $basename =~ /^Dockerfile-(pkgrakudo-(?:.+?-){2})(.+)$/) {
    ($image, $release) = ($1, $2);
    chop $image;
    $root = dirname($file);
} else {
    say "Dockerfile name is invalid.";
    exit 1;
}

### Build ###
my @cmd = qq@docker build --no-cache -f $file -t $id/$image:$release $root@ ;
exec(@cmd);

### Subroutines ###
sub help {
    say <<"EOM";
$0:
Create $format_image docker images, version $VERSION.
Run with sudo if necessary.

Usage:
-d|--dockerfile:
    Docker file for the OS, arch & release.
    Format :$format_df.
    The directory of the dockerfile is used as the docker root.
-i|--id:
    Docker ID (default: rakudo)
-h|--help:
    This help message.
EOM
}
