#!/usr/bin/env perl6

### Variables ###
my $version        = '0.2.0';
my $id             = 'rakudo-pkg';
my %*SUB-MAIN-OPTS = :named-anywhere; #allow free order of cli args

### Functions ###
sub MAIN($docker-file!) {
    if ! $docker-file.IO.f || ! $docker-file.IO.r {
        note "$docker-file does not exist or is not readable.";
        exit 1;
    }

    my ($os, $arch, $release) = $docker-file.split('-').tail(3);
    my $img  = "$id/$os-$arch:$release";
    my $root = $docker-file.IO.dirname;
    my @cmd  = ('docker', 'build', '--no-cache',
                '-f', $docker-file, '-t', $img, $root);
    say "Creating the image...";
    my $exit_code = run(@cmd);
    if $exit_code == 0 {
        say "Image $img created.";
    } else {
        note "Image creation failed.";
        exit 1;
    }
}

sub USAGE {
    say qq:to/END/;
    create-image.p6, version $version.
    Create docker images used by rakudo-pkg. Use sudo if appropiate.

    Usage:
      $*PROGRAM-NAME <docker-file>

    END
}

