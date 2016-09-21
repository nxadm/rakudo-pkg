#!/usr/bin/perl
# Create packages with a docker image.
# Run with sudo if necessary.
# See run_pkgrakudo.pl -h for parameters.
# https://github.com/nxadm/rakudo-pkg

use warnings;
use strict;
use feature 'say';
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use Getopt::Long;

### Variables ###
our $VERSION = '0.1';
my $id = 'rakudo'; # default

### CLI ###
help() and exit(0) unless (@ARGV);
my @required = qw/arch os os-version moar nqp rakudo pkg-rev dir/;
my ($arch, $os, $version, $moar, $nqp, $rakudo, $rev, $dir, $help, $error);
GetOptions(
    'arch|a=s'       => \$arch,
    'os|o=s'         => \$os,
    'os-version|v=s' => \$version,
    'moar|m=s'       => \$moar,
    'nqp|n=s'        => \$nqp,
    'rakudo|r=s'     => \$rakudo,
    'pkg-rev|p=s'    => \$rev,
    'id|i=s'         => \$id,
    'dir|d=s'        => \$dir,
    'help|h'         => \$help,
) or die("Error in command line arguments\n");

help() and exit(0) if ($help || @ARGV);
my %dispatch = (
    help         => sub { help() && exit(0) if defined $help},
    dir          => sub { missing_mandatory('dir') unless defined $dir },
    arch         => sub { missing_mandatory('arch') unless defined $arch },
    os           => sub { missing_mandatory('os') unless defined $os },
    moar         => sub { missing_mandatory('moar') unless defined $moar },
    nqp          => sub { missing_mandatory('nqp') unless defined $nqp },
    rakudo       => sub { missing_mandatory('rakudo') unless defined $rakudo },
    'os-version' =>
        sub { missing_mandatory('os-version') unless defined $version },
    'pkg-rev'    =>
        sub { missing_mandatory('pkg-rev') unless defined $rev },
);

for my $k (keys %dispatch) {
    &{ $dispatch{$k} };
}
exit(1) if $error;

### Run ###
my $image = "$id/pkgrakudo-$os-$arch:$version";
chdir(dirname(abs_path($0))) or die($!);
chdir('..') or die($!);
my @cmd = (
    'docker', 'run', '-ti', '--rm',
    '-v', "$dir:/staging",
    '-e', "VERSION_MOARVM=$moar",
    '-e', "VERSION_NQP=$nqp",
    '-e', "VERSION_RAKUDO=$rakudo",
    '-e', "REVISION=$rev",
    lc($image)
);
exec(@cmd);

### Subroutines ###
sub help {
	say <<"EOM";
$0:
Create packages with pkgrakudo docker images, version $VERSION.
Run with sudo if necessary.

Usage:
-a|--arch:
    CPU architecture (mandatory).
-o|--os:
    Operating System (mandatory).
-v|--os-version:
    Operating System release (mandatory).
-m|--moar:
    Version of MoarVM to build (mandatory).
-n|--nqp:
    Version of NQP to build (mandatory).
-r|--rakudo:
    Version of Rakudo to build (mandatory).
-p|--pkg-rev:
    Package revision (mandatory).
-d|--dir:
    Directory where to store the created packages.
-i|--id:
    Docker ID (default: rakudo)
-h|--help:
	This help message.
EOM
}

sub missing_mandatory {
    my $param = shift;
    say STDERR "Mandatory param missing: $param.";
    $error = 1;
}
