#!/usr/bin/env perl6

### Variables ###
my $version        = '0.2.0';
my $id             = 'pkg-rakudo';
my %*SUB-MAIN-OPTS = :named-anywhere; #allow free order of cli args

### Functions ###
sub MAIN(
    $img!, :$rakudo-version!,
    :$nqp-version = $rakudo-version, :$moarvm-version = $rakudo-version,
    :$rev = '01', :$dir = '/var/tmp/rakudo-pkg',
    :$maintainer = 'Claudio Ramirez <pub.claudio@gmail.com>'
) {

    my @cmd = (
        'docker', 'run', '-ti', '--rm',
        '-v', "$dir:/staging",
        '-e', "RAKUDO_VERSION=$rakudo-version",
        '-e', "NQP_VERSION=$nqp-version",
        '-e', "MOARVM_VERSION=$moarvm-version",
        '-e', "REVISION=$rev",
        '-e', "MAINTAINER=\"$maintainer\"",
        $img
    );
    say "Creating the rakudo package...";
    say (@cmd);
    my $exit_code = run(@cmd);
    if $exit_code == 0 {
        say "Package and checksum created in $dir.";
    } else {
        note "Package creation failed.";
        exit 1;
    }
}

sub USAGE {
    say qq:to/END/;
    create-pkg.p6, version $version.
    Create Rakudo packages with pkg-rakudo. Use sudo if appropiate.

    Usage:
      $*PROGRAM-NAME <docker image> --rakudo-version=<version>
        [--nqp-version=<version> --moarvm-version=<version>
         --rev=<revision> --dir=<directory> --maintainer=<info>]

    --nqp- and --moarvm-version default to the value of rakudo-version,
    --rev to 01 and --dir to /var/tmp/pkg-rakudo. --maintainer refers
    to you (optional).

    END
}

