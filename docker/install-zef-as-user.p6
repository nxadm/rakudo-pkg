#!/bin/bash -e

# Perl6 Module Management (https://github.com/ugexe/zef)
# You need Git in order to install and use Zef.

cd /var/tmp
rm -rf /var/tmp/zef_$USER
git clone https://github.com/ugexe/zef.git zef_$USER
cd zef_$USER
$PREFIX/bin/perl6 -Ilib bin/zef --install-to=home install .
rm -rf /var/tmp/zef_$USER

echo "zef has been installed to ~/.perl6/bin."
echo "Add ~/.perl6/bin and $PREFIX/bin to your PATH, e.g.:"
echo "echo 'export PATH=~/.perl6/bin:i$PREFIX/bin:\$PATH' >> ~/.bash_profile"

exit 0
#!/opt/rakudo-pkg/bin/perl6

my $version        = '0.4.0';

sub MAIN() {
    my $file-url = $base-url ~ $release ~
        '/release/ubuntu-base-' ~ $release ~ '-base-i386.tar.gz';
    my $cmd = 'curl ' ~ $file-url ~
        '| gunzip | docker import - ' ~ $id ~ '/ubuntu-i386:' ~ $release;
    my $exit-code = shell $cmd;
    if $exit-code == 0 {
        say 'Docker image imported (run "docker images").';
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

    A list of releases can be fout at $base-url.
    END
}
