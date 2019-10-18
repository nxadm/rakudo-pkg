#!/usr/bin/env perl
use warnings;
use strict;
use feature 'say';
use File::Copy;
use File::Path qw/remove_tree/;

### Variables ###
my $install_root = '/opt/rakudo-pkg';
my $pkg_dir      = '/staging';
my $fpm          = '/usr/bin/fpm';
my %repos = (
    zef    => "https://github.com/ugexe/zef.git",
    rakudo => "https://github.com/rakudo/rakudo.git",
    nqp    => "https://github.com/perl6/nqp.git",
    moarvm => "https://github.com/MoarVM/MoarVM.git",
);
my %distro_info = (
    # distro => [ pkg format, install command ]
    Alpine   => { format=>'apk', cmd => ['apk', 'add', '--allow-untrusted'] },
    CentOS   => { format=>'rpm', cmd => ['rpm', '-Uvh'                    ] },
    Debian   => { format=>'deb', cmd => ['dpkg', '-i'                     ] },
    Fedora   => { format=>'rpm', cmd => ['rpm', '-Uvh'                    ] },
    openSUSE => { format=>'rpm', cmd => ['rpm', '-Uvh'                    ] },
    Ubuntu   => { format=>'deb', cmd => ['dpkg', '-i'                     ] },
);
my $pkg_name = ''; # to be filled at runtime

### Check required environment ###
check_env(
    'ZEF_VERSION', 'RAKUDO_VERSION', 'NQP_VERSION', 'MOARVM_VERSION',
    'MAINTAINER', 'REVISION', 'ARCH', 'OS', 'RELEASE'
) or exit 1;
my %versions = (
    rakudo => $ENV{RAKUDO_VERSION},
    nqp    => $ENV{NQP_VERSION},
    moarvm => $ENV{MOARVM_VERSION},
    zef    => $ENV{ZEF_VERSION},
);
my $maintainer = $ENV{MAINTAINER};
my $revision   = $ENV{REVISION};
my $os         = $ENV{OS};
my $os_release = $ENV{RELEASE};
my $arch       = $ENV{ARCH};
$arch = 'native' if $os ne 'Alpine';

### Download & compile Rakudo ###
for my $soft ('moarvm', 'nqp', 'rakudo') { #keep order
    build($soft) or exit 1;
}
say "Rakudo was succesfully compiled.";

### Instal zef as a test ###
install_global_zef() or exit 1;

### Package ###
move('/install-zef-as-user', "$install_root/bin/") or die($!);
move('/fix_windows10', "$install_root/bin/") or die($!);
move('/add-perl6-to-path', "$install_root/bin/") or die($!);
symlink("$install_root/bin/perl6", "$install_root/bin/rakudo") or die($!);
symlink("$install_root/bin/perl6", "$install_root/bin/raku") or die($!);
pkg_fpm() or exit 1;
say "Rakudo was succesfully packaged.";

### Create checksum ###
checksum() or exit 1;
say "Rakudo package was succesfully checksummed.";

### Test by installing and running perl6 and zef ###
my @cmd = ( @{ $distro_info{$os}{cmd} }, $pkg_dir . '/' . $pkg_name);
system(@cmd) == 0 or die($!);
$ENV{PATH} = $install_root . '/bin:' . $ENV{PATH};
system('perl6', '-v') == 0 or die($!);
system('cat', '/etc/profile.d/rakudo-pkg.sh') == 0 or die($!);
system('zef')         == 0 or die($!);


exit 0;

### Functions ###
sub build {
    my $soft = shift;
    mkdir $soft or die($!);
    # Download and unpack
    system('git', 'clone', $repos{$soft}, $soft) == 0 or return 0;
    chdir($soft) or die($!);
    system('git', 'checkout', "tags/" . $versions{$soft}) == 0 or return 0;
    chdir($soft) == 0 or return 0;
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
    say "Package checksum: $sum";
    open(my $fh, '>', $pkg_name . '.sha1') or die($!);
    print $fh $sum;
    close($fh) or die($!);
    chdir('/') or die($!);
    return 1;
}

sub install_global_zef {
    # Install zef as root
    chdir('/var/tmp') or die($!);
    system('git', 'clone', $repos{"zef"}) == 0 or return 0;
    chdir('zef') or die($!);
    system('git', 'checkout', "tags/" . $versions{zef}) == 0 or return 0;
    my @cmd = ("$install_root/bin/perl6", '-Ilib', 'bin/zef',
        '--install-to=core', 'install', '.');
    system(@cmd) == 0 or return 0;
    symlink("$install_root/share/perl6/core/bin/zef", "$install_root/bin/zef")
        or die($!);
    chdir('/') or die($!);
    remove_tree('/var/tmp/zef') or warn($!);
    return 1;
}

sub pkg_fpm {
    my @cmd = (
        $fpm,
        '--deb-no-default-config-files',
        '--license', 'Artistic License 2.0',
        '--description', 'Rakudo runtime (Raku)',
        '--input-type', 'dir',
        '--output-type', $distro_info{$os}{format},
        '--package', $pkg_dir,
        '--name', 'rakudo-pkg',
        '--maintainer', $maintainer,
        '--version', $versions{rakudo},
        '--iteration', $revision,
        '--url', 'https://raku.org',
        '--architecture', $arch,
        $install_root, '/etc/profile.d/rakudo-pkg.sh'
    );
    say "@cmd";
    system(@cmd) == 0 or return 0;
    # Add OS info to filename
    chdir($pkg_dir) or die($!);
    my $old_name = glob('*.' . $distro_info{$os}{format});
    my $new_name = $old_name;
    $new_name =~ s/^(rakudo-pkg)/$1-${os}${os_release}/;
    move($old_name, $new_name) or die($!);
    $pkg_name = $new_name;
    chdir('/') or die($!);
    return 1;
}
