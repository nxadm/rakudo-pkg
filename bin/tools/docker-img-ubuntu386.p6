#!/usr/bin/env perl6

my $base-url = 'http://cdimage.ubuntu.com/ubuntu-base/releases/';

sub MAIN($release) {
    my $file-url = $base-url ~ $release ~ 
        '/release/ubuntu-base-' ~ $release ~ '-base-i386.tar.gz';
    my $cmd = 'curl ' ~ $file-url ~ 
        '| gunzip | docker import - nxadm/ubuntu-i386:' ~ $release;
    my $exit-code = shell $cmd;
    if $exit-code == 0 {
        say 'Docker image imported (run "docker images").';
    }
}

sub USAGE {
    say qq:to/END/;
    Create an Ubuntu i386 Docker base images.
    Docker, curl and gunzip are needed. Use sudo if appropiate.
    
    Usage:
      $*PROGRAM-NAME <release>
    
    A list of releases can be fout at $base-url.
    END
}
