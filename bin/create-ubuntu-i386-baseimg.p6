#!/usr/bin/env perl6

my $version        = '0.3.0';
my $base-url       = 'http://cdimage.ubuntu.com/ubuntu-base/releases/';
my %*SUB-MAIN-OPTS = :named-anywhere; #allow free order of cli args

sub MAIN($release, :$id = 'nxadm' ) {
    my $file-url = $base-url ~ $release ~
        '/release/ubuntu-base-' ~ $release ~ '-base-i386.tar.gz';
    my $cmd = 'curl ' ~ $file-url ~
        '| gunzip | podman import - ' ~ $id ~ '/ubuntu-i386:' ~ $release;
    my $exit-code = shell $cmd;
    if $exit-code == 0 {
        say 'Docker image imported (run "podman images").';
    } else {
        note 'Failure creating the base image.';
        exit 1;
    }
}

sub USAGE {
    say qq:to/END/;
    docker-img-ubuntu386, version $version.
    Create an Ubuntu i386 Docker base images.
    Docker, curl and gunzip are needed. Use sudo if appropiate.

    Usage:
      $*PROGRAM-NAME <release>

    A list of releases can be found at $base-url.
    END
}
