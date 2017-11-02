#!/usr/bin/env perl
use warnings;
use strict;
use feature 'say';
use File::Copy;
use File::Path;

### Variables ###
my $install_root    = '/opt/rakudo';
my $pkg_dir         = '/staging';
my $rakudo_url_base = 'https://rakudo.perl6.org/downloads';
my $moarvm_url_base = 'https://moarvm.org/releases/MoarVM-';
my %urls            = ( # templates for now
    rakudo =>
        'https://rakudo.perl6.org/download/rakudo/rakudo-__VERSION__.tar.gz',
    nqp    =>
        'https://rakudo.perl6.org/download/nqp/nqp-__VERSION__.tar.gz',
    moarvm =>
        "https://moarvm.org/releases/MoarVM-__VERSION__.tar.gz",
);
my %distro_info = (
    # distro => [ pkg format, install command ]
    alpine => [ 'apk', 'apk add --allow-untrusted' ],
    centos => [ 'rpm', 'rpm -Ubh' ],
    debian => [ 'deb', 'dpkg -i' ],
    fedora => [ 'rpm', 'rpm -Ubh' ],
    ubuntu => [ 'deb', 'dpkg -i' ],
);
my ($pkg_name, $os, $os_release); # to be filled after renaming

### Check required environment ###
check_env(
    'RAKUDO_VERSION', 'NQP_VERSION', 'MOARVM_VERSION',
    'MAINTAINER', 'REVISION'
) or exit 1;
my %versions = (
    rakudo => $ENV{RAKUDO_VERSION},
    nqp    => $ENV{NQP_VERSION},
    moarvm => $ENV{MOARVM_VERSION},
);
my $maintainer = $ENV{MAINTAINER};
my $revision   = $ENV{REVISION};

### Download & compile Rakudo ###
for my $soft ('moarvm', 'nqp', 'rakudo') {
    urls{$soft} =~ s/__VERSION__/$versions{$soft}/; # create the download URLs
    build($soft) or exit 1;
}
say "Rakudo was succesfully compiled.";

### Get OS information ###
if (-f '/etc/alpine-release') {
    $os = 'alpine';
    open(my $fh, '<', '/etc/alpine-release') or die($!);
    $/ = undef;
    $os_release = <$fh>;
    $os_release =~ s/^(\d+\.\d+)/$1/; # Ignore dot releases
    close $fh;
} else {
    $os         = `lsb_release -is`;
    $os_release = `lsb_release -rs`;
}
$os_release =~ s/^(\d+\.\d+).+/$1/; # Short OS release (7.2 instead of 7.2.1234)

### Package ###
sub pkg {
    if (-f '/fix_windows10') {
        move('/fix_windows10', "$install_root/bin/") or die($!);
    }

    if ($os eq 'alpine') {
        pkg_alpine() or exit 1;
    } else {
        pkg_fpm() or exit 1;
    }
}
say "Rakudo was succesfully packaged.";

### Create checksum ###
checksum() or exit 1;
say "Rakudo package was succesfully checksummed.";

### Test by installing and running it ###
my @cmd = ( $distro_info{$os}[1], $pkg_name);
system(@cmd) == 0 or die($!);
system('/opt/rakudo/bin/perl6', '-v') == 0 or die($!);

exit 0;

### Functions ###
sub build {
    my $soft = shift;
    # Download and unpack
    system('wget', $urls{$soft}, '-O', $soft . '.tar.gz') == 0 or return 0;
    system('tar', 'xzf', $soft . '.tar.gz', '-C', $soft)  == 0 or return 0;
    chdir($soft) or die($!);
    # Configure
    my @configure  = ('perl', 'Configure.pl', "--prefix=$install_root");
    my $skip_tests = 1;
    if ($soft ne 'moarvm') {
        push(@configure, '--backends=moar') if ($soft ne 'moarvm');
        $skip_tests = 0;
    }
    system(@configure) == 0 or return 0;
    system('make')     == 0 or return 0;
    # make test
    if (!$skip_tests) {
        system('make', 'test') == 0 or return 0;
    }
    # make install
    system('make', 'install') == 0 or return 0;
    # Clean up
    remove_tree($soft) or warn($!);
    return 1;
}

sub check_env {
    my @keys = @_;
    my $error;
    for my $key (@keys) {
        if (! exists $ENV{$key}) {
            say STDERR "Environment variable $key not set.";
            $error = 1;
        }
    }
    return 0 if $error;
}

sub checksum {
    my $sum = `sha1sum $pkg_name`;
    open(my $fh, '>', $pkg_name . '.sha1') or die($!);
    print $fh $sum;
    close($fh) or die($!);
    return 1;
}


sub pkg_alpine {}

sub pkg_fpm {
    my @cmd = (
        'fpm',
        '--deb-no-default-config-files',
        '--license', 'Artistic License 2.0',
        '--description', 'Rakudo Perl 6 runtime',
        '-s', 'dir',
        '-t', $distro_info{$os}[0],
        '-p', $pkg_dir,
        '-n', 'rakudo',
        '-m', $maintainer,
        '-v', $versions{pkg},
        '--iteration', $revision,
        '--url', 'https://perl6.org',
        '/opt/rakudo'
    );
    system(@cmd) == 0 or return 0;
    # Add OS info to filename
    my $old_name = glob('*.' .$distro_info{$os});
    my $new_name = $old_name;
    $new_name =~ s/^(rakudo-pkg)/$1-${os}${os_release}/;
    move($old_name, $new_name) or die($!);
    $pkg_name = $new_name;
    return 1;
}
