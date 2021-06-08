use strict;
use warnings;

use HTTP::Request::Common;
use LWP::UserAgent;

my $ua  = LWP::UserAgent->new;
my $req = $ua->request( GET 'https://metacpan.org/' );
print $req->content;
