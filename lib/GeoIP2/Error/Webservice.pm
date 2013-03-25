package GeoIP2::Error::Webservice;

use strict;
use warnings;

use GeoIP2::Types qw( Str );

use Moo;

with 'GeoIP2::Role::Error::HTTP';

extends 'Throwable::Error';

has code => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

1;

# ABSTRACT: A generic exception

__END__

=head1 SYNOPSIS

  use v5.10;

  use GeoIP2::Webservice::Client;
  use Scalar::Util qw( blessed );

  my $client = GeoIP2::Webservice::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  try {
      $client->omni( ip => '24.24.24.24' );
  }
  catch {
      die $_ unless blessed $_;
      if ( $_->isa('GeoIP2::Error::HTTP') ) {
          log_webservice_error(
              maxmind_code => $_->code(),
              status       => $_->http_status(),
              uri          => $_->uri(),
          );
      }

      # handle other exceptions
  };

=head1 DESCRIPTION

This class represents an error returned by MaxMind's GeoIP Precision web
service. It extends L<Throwable::Error> and adds attributes of its own.

=head1 METHODS

The C<< $error->message() >>, and C<< $error->stack_trace() >> methods are
inherited from L<Throwable::Error>. The message will be the value provided by
the MaxMind web service. See http://dev.maxmind.com/geoip/precision for
details.

It also provide three methods of its own:

=head2 $error->code()

Returns the code returned by the MaxMind GeoIP Precision web service.

=head2 $error->http_status()

Returns the HTTP status. This should be either a 4xx or 5xx error.

=head2 $error->uri()

Returns the URI which gave the HTTP error.
