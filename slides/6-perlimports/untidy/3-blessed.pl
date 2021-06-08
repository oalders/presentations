use Moose;

use Carp qw( confess );
use Scalar::Util qw( blessed looks_like_number );

my $is_blessed = blessed( 12 );
my $is_number = looks_like_number( 15 );

confess 'Something went wrong';
