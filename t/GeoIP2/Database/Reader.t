use strict;
use warnings;

use Test::More;
use Test::Fatal;

use GeoIP2::Database::Reader;
use Path::Class qw( file );

my $languages = [ 'en', 'de', ];

{
    my $reader = GeoIP2::Database::Reader->new(
        file =>
            file(qw( maxmind-db test-data GeoIP2-City-Test.mmdb))->stringify,
        languages => $languages
    );

    ok( $reader, 'got reader for test database' );

    foreach my $endpoint ( 'country', 'city', 'city_isp_org', 'omni' ) {
        like(
            exception { $reader->$endpoint() },
            qr/Required param/,
            'dies on missing ip'
        );

        like(
            exception { $reader->$endpoint( ip => 'me' ) },
            qr/me is not a valid lookup IP/,
            'dies on "me"'
        );

        like(
            exception { $reader->$endpoint( ip => 'x' ) },
            qr/\QThe IP address you provided (x) is not a valid IPv4 or IPv6 address/,
            'dies on invalid ip'
        );

        my $ip = '81.2.69.160';
        my $omni = $reader->$endpoint( ip => $ip );

        is(
            $omni->country->name,
            'United Kingdom',
            'country name for ' . $endpoint
        );
        next if $endpoint eq 'country';

        is( $omni->city->name, 'London', 'city name for ' . $endpoint );
    }
}

done_testing();