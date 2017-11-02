#!/opt/rakudo-pkg/bin/perl6
# Perl6 Module Management (https://github.com/ugexe/zef)
# You need Git in your path in order to install and use Zef.

my $version = '0.4.0';
my $repo    = 'https://github.com/ugexe/zef.git';

say "Installing zef for user %*ENV<USER>...";
my $tmp_dir =
    $*TMPDIR ~ IO::Path.new($*TMPDIR).SPEC.dir-sep ~ 'rakudo-pkg_' ~ rand;
my @cmd  = ('git', 'clone', '--depth=1', $repo, $tmp_dir);
my $proc = run(@cmd);
if $proc.exitcode != 0 {
    note "Cloning $repo failed. Failing out...";
    note 'Is "git" in your PATH?';
    exit 1;
}
my $cwd = $*CWD;
chdir($tmp_dir) or die($!);
@cmd =
    (~$*EXECUTABLE, '-Ilib', 'bin/zef',
    '--install-to=home', 'install', '.');
$proc = run(@cmd);
if $proc.exitcode != 0 {
    note 'Installing Zef failed. Failing out...';
    exit 1;
}
chdir($cwd) or warn($!);

if $*DISTRO.is-win {
    run('deltree', $tmp_dir, '/s', '/q') or warn($!)
} else {
    run('rm', '-rf', $tmp_dir) or warn($!)
}

say qq:to/END/;
zef has been installed to ~/.perl6/bin.
Add ~/.perl6/bin and /opt/rakudo-pkg/bin to your PATH, e.g.:"
echo 'export PATH=~/.perl6/bin:/opt/rakudo-pkg/bin:\$PATH' >> ~/.bash_profile
END

