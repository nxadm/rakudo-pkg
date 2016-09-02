#!/usr/bin/perl
# Create pkgrakudo-<os>-<arch>:<os_release> docker images.
# Run with sudo if necessary.
# See build_pkgrakudo.pl -h for parameters.
# https://github.com/nxadm/rakudo-pkg

use warnings;
use strict;
use feature 'say';
use File::Basename qw/dirname/;
use Getopt::Long;

### Variables ###
our $VERSION = '0.1';
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

help() if ($help || !$file || @ARGV);

if ($file =~ /^Dockerfile-(pkgrakudo-(?:.+?-){2})(.+)$/) {
	$image = $1;
	chop $image;
	$release = $2;
	$root    = dirname($file);
} else {
	say "Dockerfile name is invalid.";
	exit 1;
}

### Build ###
my @cmd = qw@docker build -f $file -t $id/$image:$release $root@ ;

exec();


### Subroutines ###
sub help {
	say <<"EOM";
$0:
Create $format_image docker images.
Run with sudo if necessary.
Version $VERSION.
Usage:
-d|--dockerfile:
	Docker file for the OS, arch & release.
	Format :$format_df.
	The directory of the dockerfile is used as the docker root.
-h|--help:
	This help message.
EOM
}
