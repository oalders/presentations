use strict;
use warnings;

use Test::Differences;
use Test::More;

diag 'this test can be tidied';

ok(1);
is( 'one', 'two' );

eq_or_diff( 'one', 'two' );

SKIP: {
    skip 'some reason', 1 unless 0;
    ok( 1 );
}

warn 'something bad';

done_testing;
