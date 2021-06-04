---
marp: true
---

# Where Did That Symbol Come From?

---

# Problem

```perl
use HTTP::Request::Common;
use LWP::UserAgent;
 
my $ua = LWP::UserAgent->new;
my $req = $ua->request( GET 'https://metacpan.org/' );
```

Where did `GET` come from?

---

# With Explicit Imports

```perl
use HTTP::Request::Common qw( GET );
use LWP::UserAgent ();
 
my $ua = LWP::UserAgent->new;
my $req = $ua->request( GET 'https://metacpan.org/' );
```

---

# Are All of Your Imports Actually Needed?

```perl
use HTTP::Status qw(
    is_cacheable_by_default
    is_client_error
    is_error
    is_info
    is_redirect
    is_server_error
    is_success
    status_message
);
```

---

# Checkhov's Gun 

> "Remove everything that has no relevance to the story. If you say in the first chapter that there is a rifle hanging on the wall, in the second or third chapter it absolutely must go off. If it's not going to be fired, it shouldn't be hanging there"

[https://en.wikipedia.org/wiki/Chekhov%27s_gun](https://en.wikipedia.org/wiki/Chekhov%27s_gun)

---

# Chesterton's Fence

> Do not remove a fence until you know why it was put up in the first place.

[https://fs.blog/2020/03/chestertons-fence/](https://fs.blog/2020/03/chestertons-fence/)

---

# Are All of Your Modules Actually Needed?

* Once we remove unneeded imports, we can more easily find unused modules
* Unused modules are clutter
  * Why is this here?
  * Can I really just remove it?
  * Is this causing me to keep unneeded dependencies up to date?
  * Is this making my code slower?

---

# Do You Have a Constistent Style?

```perl
use Cpanel::JSON::XS;
use Database::Migrator::Types qw( HashRef ArrayRef Object Str Bool Maybe CodeRef FileHandle RegexpRef );
use List::AllUtils qw( uniq any );
use LWP::UserAgent    q{};
use Try::Tiny qw/ catch     try /;
use WWW::Mechanize  q<>;
```
---

# Is This Easier to Read?

```perl
use Cpanel::JSON::XS ();
use Database::Migrator::Types qw(
    ArrayRef
    Bool
    CodeRef
    FileHandle
    HashRef
    Maybe
    Object
    RegexpRef
    Str
);
use List::AllUtils qw( any uniq );
use LWP::UserAgent ();
use Try::Tiny qw( catch try);
use WWW::Mechanize ();
```
---
# To Whom are Import Tags Helpful?

```perl
use HTTP::Status qw( :constants );
```
vs
```
use HTTP::Status qw(
    HTTP_ACCEPTED
    HTTP_BAD_REQUEST
    HTTP_CONTINUE
    HTTP_I_AM_A_TEAPOT
    HTTP_MOVED_PERMANENTLY
    HTTP_NO_CODE
    HTTP_NOT_FOUND
    HTTP_OK
    ...
);
```

---

# Overview


This will include a discussion of `Exporter`, `Sub::Exporter` and `Import::Into`. It will probably include some examples of other unexpected behaviour that may take place when `Foo->import` is called.

---

# What is an exportable Symbol?

`Exporter.pm` allows the following symbols to be exported:

* `some_function`
* `&some_function` (explicit `&` prefix)
* `$some_scalar`
* `@some_array`
* `%some_hash`
* `*some_typeglob`

---

# `Sub::Exporter`

As the name implies, `Sub::Exporter` exports subroutines. If you want to export a variable, you'll need to use something else, like `Exporter`. Just make sure you export a `constant`.

---

# Exporting Constants

```
package Foo;

use Const::Fast qw( const );
use Exporter qw( import );

our $HTTP_OK = 200;

our @EXPORT_OK = ( $HTTP_OK );

1;
```
---

# How Imports Work

* What is exportable?
* @EXPORT and @EXPORT_OK
* Export tags
* Best practices with `Exporter`

---

# What Is Being Exported?

We will discuss why knowing what every CPAN module exports is almost impossible, but we'll review some techniques which we can use to maximize the number of modules we can reliably inspect for exports. 

---

# `Import::Into`

There will be a brief discussion on how `Import::Into` can be used to create your own pragmas, or even your own flavour of Moose.

---

# Maintenance Burdens

Why imports can introduce a maintenance burden on new and even experienced Perl programmers

Unmanaged import statements allow many unused symbols to be imported into existing code. Bare import statements and even import tags make it hard to discover where functions and other symbols originate from. Managing existing import statements gives us a chance to make code more readable, clarify the origin of imported symbols, remove unused dependencies and even speed up code compilation.

---

# `Perl::Critic`

There will be a brief discussion of existing `Perl::Critic` policies which try to address this. We will look at using `dump-perl-exports` as a tool to discover what a module really exports.

* [Perl::Critic::Policy::TooMuchCode::ProhibitUnusedImport](https://metacpan.org/pod/Perl::Critic::Policy::TooMuchCode::ProhibitUnusedImport)
* [Perl::Critic::Policy::TooMuchCode::ProhibitUnusedInclude](https://metacpan.org/pod/Perl::Critic::Policy::TooMuchCode::ProhibitUnusedInclude)

See also:
* [Perl::Critic::Policy::TooMuchCode::ProhibitUnusedConstant]()
* [Test::Vars](https://metacpan.org/pod/Test::Vars)

---

# goimports

---

# App::perlimports

Bare imports and import tags provide the code author with a convenience, but this can come at the cost of readability for everyone else. We will walk through using perlimports from the command line and see how it attempts to clean up import statements in a selection of a code, a file or even an entire codebase.

---

# perlimports in vim

 We will discuss how to use similar techniques with a simple vim integration, so that imports can be cleaned up directly in the vim editor. If perlimports does not present itself as a workable solution for an audience member, the preceding discussion should provide some food for thought as to how technical debt on an existing code base can be reduced through wise use of import statements.