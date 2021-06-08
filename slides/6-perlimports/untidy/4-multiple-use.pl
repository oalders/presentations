use strict;
use warnings;

use Scalar::Util qw( blessed );
use Scalar::Util qw( blessed looks_like_number );
use Scalar::Util qw( looks_like_number );
require Scalar::Util;

my $is_blessed = blessed( 12 );
my $is_number = looks_like_number( 15 );
