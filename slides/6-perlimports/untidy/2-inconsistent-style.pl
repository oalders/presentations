#!/usr/bin/env perl

use strict;
use warnings;

use Cpanel::JSON::XS;
use Database::Migrator::Types qw( HashRef ArrayRef Object Str Bool Maybe CodeRef FileHandle RegexpRef );
use List::AllUtils qw( uniq any );
use LWP::UserAgent    q{};
use Try::Tiny qw/ catch     try /;
use WWW::Mechanize  q<>;

my $json = Cpanel::JSON::XS->new;
my $found = any { $_ > 2 } (0..9);
my @unique = uniq ( 0..9, 0..5 );

my $lwp = LWP::UserAgent->new;
my $ua;
try {
    $ua = WWW::Mechanize->new;
}

catch {
    die $_;
};

