use strict;
use warnings;

use lib 'lib';

use EEE qw( one );
use EEE qw/ two /;
use EEE qw< three >;
use EEE qw' four ';
use EEE qw{ five };
use EEE qw| six |;
use EEE ( 'seven' );
use EEE 'eight';
use EEE qw+ nine +;
use EEE qw* ten *;
use EEE qw: eleven :;
use EEE qw$ twelve $;
