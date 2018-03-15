#!/usr/bin/env perl6

=begin pod

=head1 NAME

get_rakudo_pkg_latest - make a markdown list of the latest rakudo-pkg downloads

=head1 SYNOPSIS

	$ perl6 get_rakudo_pkg_latest.p6

=head1 DESCRIPTION

There's a repository of pre-built Rakudo compiler packages:

	https://github.com/nxadm/rakudo-pkg

In the F<releases/> directory there are downloaded files of packages
for several Linux releases. This program fetches the release files data
through the GitHub data and converts it to a Markdown list suitable for the
F<README> file.

=head1 LICENSE

This code is available under the Artistic License 2.0.

=head1 COPYRIGHT

Copyright © 2018 brian d foy, bdfoy@cpan.org

=end pod

need HTTP::UserAgent;
use JSON::Fast;

my $repo-url = 'https://api.github.com/repos/nxadm/rakudo-pkg/releases/latest';
my $response = get-ua().get: $repo-url;
die "Could not fetch <$repo-url>: { $response.status-line }"
	unless $response.is-success;

my @releases = try from-json( $response.content ).<assets>.List;
die "Could not convert JSON: $!" if $!;

#`(
	The filenames aren't consistent. Some use different separators
	between the different parts. I'd rather see that fixed but maybe
	there are reasons for them
	)
#`(
	The entries for the checksum files ".sha1" have everything we
	need to know. It's the same filename with an additional extension.
	From that we can make the package download url.
		rakudo-pkg-openSUSE42.3-2018.02.1-01.x86_64.rpm.sha1
	)
my $pattern = rx/
	'rakudo-pkg-'
	$<os>      = (<-[_-]>+?)
	<[_-]>
	$<rakudo>  = (\d\d\d\d '.' \d\d [ '.' \d+ [ '-' \d+ ]? ]?)
	<[_.]>
	$<arch>    = (<-[.]>+)
	'.'
	$<ext>     = ( rpm | deb | apk )
	$<sha1>    = ('.sha1')?
	/;

#`(
	Since I anticipate using this in an automated fashion, set the
	exit status so a shell script knows if we had problems
	)
my $exit-status = 0; # Add to this for every error
END exit( $exit-status );

#`(
	A double level hash of <OS-NAME><OS-VERSION>
	)
my %releases;

for @releases -> $release {
	next unless $release<name> ~~ / '.sha1' $ /;

	my $sha1-url = $release<browser_download_url>;
	my $pkg-url  = $sha1-url.subst: / '.sha1' $ /, '';

	if $release<name> ~~ $pattern {
		my ( $os, $rakudo, $arch, $ext, $sha1 )
			= $/<os rakudo arch ext sha1>.map: ~*;

		$os .= subst: /(\d+ ['.' \d+]?) $/, '';
		my $os-version = $0;

		%releases{$os}{$os-version}<arch ext sha1-url pkg-url> =
			( $arch, $ext, $sha1-url, $pkg-url );

		}
	else {
		warn "Did not match <$release<name>>";
		$exit-status++;
		}
	}

# The README format looks like this:
# - Alpine 3.6 x86_64:
# [apk](https://nxadm.github.io/rakudo-pkg/latest-release.html?os=alpine&version=3.6&arch=x86_64)
# ([checksum](https://nxadm.github.io/rakudo-pkg/latest-release-checksum.html?os=alpine&version=3.6&arch=amd64)).
for %releases.keys.sort -> $os {
	for %releases{$os}.keys.sort -> $os-version {
		my $urls-ok = check-urls( |%releases{$os}{$os-version}<pkg-url sha1-url> );
		warn "URLs for $os $os-version had problems" unless $urls-ok;
		printf "- %s %s %s [%s](%s) ([checksum])(%s)).\n",
			$os, $os-version, %releases{$os}{$os-version}<arch ext pkg-url sha1-url>
		}
	}

# This takes awhile so maybe you want it off. I like the extra
# check though.
sub check-urls( *@urls --> Bool:D ) {
	state $ua = get-ua();
	my $errors = 0;
	for @urls -> $url {
		my $response = $ua.get: $url;
		next if $response.is-success;
		warn "Could not fetch <$url>: {$response.status-line}";
		$errors++;
		$exit-status++;
		}

	$errors ?? False !! True;
	}

sub get-ua ( --> HTTP::UserAgent:D ) {
# The GitHub API requires a user-agent header or you get a 403 response
# I don't care which ua it is so I stole this one.
	need HTTP::UserAgent;
	state $ua = HTTP::UserAgent.new(
		:useragent('Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0'),
		);
	$ua;
	}
