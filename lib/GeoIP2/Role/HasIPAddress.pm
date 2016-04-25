package GeoIP2::Role::HasIPAddress;

use strict;
use warnings;

our $VERSION = '2.003002';

use GeoIP2::Types qw( IPAddress );

use Moo::Role;

has ip_address => (
    is       => 'ro',
    isa      => IPAddress,
    required => 1,
);

1;
