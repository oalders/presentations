package BBB;

use strict;
use warnings;

BEGIN { print "\nBEGIN " . __PACKAGE__ . "\t"}

sub import { print 'import ' . __PACKAGE__ }

1;
