#!/usr/bin/env perl
use warnings;
use strict;
use feature 'say';
use File::Copy;
use File::Path qw/remove_tree/;

### Variables ###
my $install_root = '/opt/rakudo-pkg';
my $pkg_dir      = '/staging';
my %urls         = ( # templates for now
    rakudo =>
        'https://rakudo.perl6.org/downloads/rakudo/rakudo-__VERSION__.tar.gz',
    nqp    =>
        'https://rakudo.perl6.org/downloads/nqp/nqp-__VERSION__.tar.gz',
    moarvm =>
        "https://moarvm.org/releases/MoarVM-__VERSION__.tar.gz",
);
my %distro_info = (
    # distro => [ pkg format, install command ]
    Alpine => { format => 'apk', cmd => ['apk', 'add', '--allow-untrusted'] },
    CentOS => { format => 'rpm', cmd => ['rpm', '-Uvh'                    ] },
    Debian => { format => 'deb', cmd => ['dpkg', '-i'                     ] },
    Fedora => { format => 'rpm', cmd => ['rpm', '-Uvh'                    ] },
    Ubuntu => { format => 'deb', cmd => ['dpkg', '-i'                     ] },
);
my ($pkg_name, $os, $os_release) = ('','',''); # to be filled at runtime

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
    $urls{$soft} =~ s/__VERSION__/$versions{$soft}/; # create the download URLs
    build($soft) or exit 1;
}
say "Rakudo was succesfully compiled.";

### Get OS information ###
if (-f '/etc/alpine-release') {
    $os = 'Alpine';
    open(my $fh, '<', '/etc/alpine-release') or die($!);
    $/ = undef;
    $os_release = <$fh>;
    $os_release =~ s/^(\d+\.\d+)/$1/; # Ignore dot releases
    close $fh;
} else {
    $os         = `lsb_release -is`;
    $os_release = `lsb_release -rs`;
}
chomp $os;
chomp $os_release;
$os_release =~ s/^(\d+\.\d+).+/$1/; # Short OS release (7.2.1234 -> 7.2)

### Package ###
move('/install-zef-as-user.p6', "$install_root/bin/") or die($!);
if (-f '/fix-windows10') { # WSL fix
    move('/fix-windows10', "$install_root/bin/") or die($!);
}

if ($os eq 'alpine') {
    pkg_alpine() or exit 1;
} else {
    pkg_fpm() or exit 1;
}
say "Rakudo was succesfully packaged.";

### Create checksum ###
checksum() or exit 1;
say "Rakudo package was succesfully checksummed.";

### Test by installing and running it ###
my @cmd = ( @{ $distro_info{$os}{cmd} }, $pkg_dir . '/' . $pkg_name);
system(@cmd) == 0 or die($!);
system($install_root . '/bin/perl6', '-v') == 0 or die($!);

exit 0;

### Functions ###
sub build {
    my $soft = shift;
    mkdir $soft or die($!);
    # Download and unpack
    system('wget', $urls{$soft}, '-O', $soft . '.tar.gz') == 0 or return 0;
    system('tar', 'xzf', $soft . '.tar.gz', '-C', $soft, '--strip=1') == 0
        or return 0;
    unlink($soft . '.tar.gz') or warn($!);
    chdir($soft) or die($!);
    # Configure
    my @configure  = ('perl', './Configure.pl', "--prefix=$install_root");
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
    chdir('/') or die($!);
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
    return 1;
}

sub checksum {
    chdir($pkg_dir) or die($!);
    my $sum = `sha1sum $pkg_name`;
    open(my $fh, '>', $pkg_name . '.sha1') or die($!);
    print $fh $sum;
    close($fh) or die($!);
    chdir('/') or die($!);
    return 1;
}


sub pkg_alpine { return 0; }

sub pkg_fpm {
    my $pkg_dir_tmp = $pkg_dir . rand();
    mkdir($pkg_dir_tmp) or die($!);
    my @cmd = (
        'fpm',
        '--deb-no-default-config-files',
        '--license', 'Artistic License 2.0',
        '--description', 'Rakudo Perl 6 runtime',
        '-s', 'dir',
        '-t', $distro_info{$os}{format},
        '-p', $pkg_dir_tmp,
        '-n', 'rakudo-pkg',
        '-m', $maintainer,
        '-v', $versions{rakudo},
        '--iteration', $revision,
        '--url', 'https://perl6.org',
        $install_root
    );
    say "@cmd";
    system(@cmd) == 0 or return 0;
    # Add OS info to filename
    chdir($pkg_dir_tmp) or die($!);
    my $old_name = glob('*.' . $distro_info{$os}{format});
    my $new_name = $old_name;
    $new_name =~ s/^(rakudo-pkg)/$1-${os}${os_release}/;
    move($old_name, $pkg_dir . '/' . $new_name) or die($!);
    $pkg_name = $new_name;
    chdir('/') or die($!);
    return 1;
}
