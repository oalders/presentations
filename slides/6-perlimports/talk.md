# perlimports


## Introduction

Today I want to talk about how imports are used in Perl. 

My plan is to break this down into terms which even someone who is relatively new to Perl programming can understand. If you've already been writing Perl for a lot of years, please bear with me for the first few minutes. Sometimes a refresher on the basics can be a very good thing. Some of the details we'll be discussing are around things that many of us assume we understand really well, but that's not always the case.

---

# The Problem

```perl
use HTTP::Request::Common;
use LWP::UserAgent;
 
my $ua = LWP::UserAgent->new;
my $req = $ua->request( GET 'https://metacpan.org/' );
```

Where did `GET` come from? If you're familiar with `HTTP::Request::Common`, this may be obvious to you. If you're not, then it's a bit more difficult. You see a `GET` somewhere in the code. You `grep` for it. You can't see where it's defined. Is it a Perl built-in? Did it appear by magic? Well, it sort of did.

# Exporter

`HTTP::Request::Common` uses a module called `Exporter`. `Exporter`'s API says that if you define an array called `our @EXPORT` that the symbols in this array will be imported into a package when your module is used without arguments.

So, when you do this:

```perl
use HTTP::Request::Common;
```

you get the following functions available to your package:

```
+--------------------------+
| GET                      |
| HEAD                     |
| OPTIONS                  |
| PATCH                    |
| POST                     |
| PUT                      |
'--------------------------'
```

That's convenient, but from an outsider's perspective it can be very confusing. Keep in mind that an outsider might just be someone who is not familiar with `HTTP::Request::Common`. How do we make this clearer?

---

# With Explicit Imports

`Exporter`'s API defines another special array called `our @EXPORT_OK`. This array contains the names of symbols which can only be imported explicitly. So, if a symbol occurs either in a modules `@EXPORT` or in its `@EXPORT_OK` you can import it explicitly, without getting many of the symbols you did not ask for.

For example, 

```perl
use HTTP::Request::Common qw( GET );
use LWP::UserAgent ();
 
my $ua = LWP::UserAgent->new;
my $req = $ua->request( GET 'https://metacpan.org/' );
```

This imports `GET`, but it does not import `HEAD`, `OPTIONS`, etc. So, we don't have symbols in our package which we don't intend to use. Also, we now are able to `grep` on `GET` and see where it is defined. Everybody wins!

---

# What is an exportable Symbol?

`Exporter.pm` allows the following symbols to be exported:

* `some_function`
* `&some_function` (note the explicit `&` prefix)
* `$some_scalar`
* `@some_array`
* `%some_hash`
* `*some_typeglob`

---

# Checkhov's Gun 

> "Remove everything that has no relevance to the story. If you say in the first chapter that there is a rifle hanging on the wall, in the second or third chapter it absolutely must go off. If it's not going to be fired, it shouldn't be hanging there"

[https://en.wikipedia.org/wiki/Chekhov%27s_gun](https://en.wikipedia.org/wiki/Chekhov%27s_gun)

---

# Chesterton's Fence

> Do not remove a fence until you know why it was put up in the first place.

[https://fs.blog/2020/03/chestertons-fence/](https://fs.blog/2020/03/chestertons-fence/)

---

## pragmata

Imports come up pretty quickly for people who are learning about Perl. One of the first things someone new to Perl learns is how to import a pragma.  

> A pragma is a module which influences some aspect of the compile time or run time behaviour of Perl such as `strict` or `warnings`.

[https://perldoc.perl.org/perlpragma](https://perldoc.perl.org/perlpragma)

That would be something like:

```perl
use strict;
use warnings;
```

---

## Modules

While you may not consciously think of it, you're actually using a module called `strict.pm` and a module called `warnings.pm` here. Both of these modules are provided to you for free, when you install `perl`. We call these modules which are included with Perl "core" modules.

Now that we know about `strict` and `warnings`, we might learn about importing CPAN modules.

```
use String::Trim;
use Trim;
use Text::Trim;
use String::Trim::More;
use Mojo::Util qw( trim );
```

Wow, there really are a lot of ways to trim. Wouldn't it be great if this existed in core Perl? That wouldn't be a controversial change, would it? Oh, right. https://github.com/Perl/perl5/issues/17952

---

## Now You're Dangerous

When we begin our Perl programming journey, we learn enough about imports to be dangerous. In a lot of cases that's good enough. As far as the beginner is concerned `strict` and `warnings` enable behaviour which is widely regarded as a "best practice" and `use Some::Module;` allows you to use the functionality provided by `Some::Module` in your own code. You now know enough get on with your day and begin solving the world's problems. But is that all you really need to know?

---

## Behind the Scenes with `import`

Let's get a little more into the weeds with what happens when we import *something* in Perl. What is happening when we say `use Module;`? The documentation at [https://perldoc.perl.org/functions/use](https://perldoc.perl.org/functions/use) tells us that `use Module;` is equivalent to:

```
BEGIN { require Module; Module->import( LIST ); }
```

Let's break this down. First off all, we can see `use` is essentially a `require` followed by an `import` and it all happens inside a `BEGIN` block.

---

## BEGIN blocks

What's a `BEGIN` block? We can look this up in perldoc at [https://perldoc.perl.org/perlmod#BEGIN%2C-UNITCHECK%2C-CHECK%2C-INIT-and-END](https://perldoc.perl.org/perlmod#BEGIN%2C-UNITCHECK%2C-CHECK%2C-INIT-and-END)

> A BEGIN code block is executed as soon as possible, that is, the moment it is completely defined, even before the rest of the containing file (or string) is parsed. 
> 
> ...
> 
> BEGIN blocks run FIFO during compilation

Note that "FIFO" means "First In First Out" or essentially the order in which the code appears.

---

## Compile time vs run time
`BEGIN` blocks run during the code's compilation phase. 

It's good to keep in mind that `perl script.pl` actually does two things:

1. First, it compiles the code
1. Next, it executes/runs the code

Note that if you only want to check that code compiles, you may use the `-c` flag:

`perl -c script.pl`

---

## Compilation

For our purposes today, we're mainly concerned with what happens in the first phase -- the code compilation.

So far we've established that `use` happens in a `BEGIN` block, at compile time, which happens before the code can be run. That means that this code will never actually run, because it doesn't compile.

```perl
use strict;
use warnings;

use Local::MissingModule;
use Local::OtherModule;
```
It will error during compilation at line 4:

```
Can't locate Local/MissingModule.pm in @INC
```

That's because the above code is equivalent to:

```perl
BEGIN {
    require strict;
    strict->import;
}
BEGIN {
    require warnings;
    warnings->import;
}

BEGIN {
    require Local::MissingModule;
    Local::MissingModule->import;
}
```

It also exits with `Can't locate Local/MissingModule.pm in @INC`.

---

## `require`

We've now established that under the hood, `use` is essentially `require` followed by `import` inside a `BEGIN` block. We've discussed `BEGIN`. Now let's look at `require`.

```perl
require Local::MissingModule;
```

 The high level overview of `require` is that it is that, in the above instance, `require` will try to find the module and then `eval` the code inside the module. As you may have guessed, there's more to it than that. Check [https://perldoc.perl.org/functions/require](https://perldoc.perl.org/functions/require) for more depth. For our purposes today, this is probably a "good enough" explanation.
 
To demonstrate, let's take a module whose sole purpose is to `die`:

```perl
package Local::Dies;

use strict;
use warnings;

die 'oof';

1;
```

We'll include it in a script:

```perl
use strict;
use warnings;

use Local::Dies;
...;
```

We'll try to compile the script:


```bash
$ perl -Ilib -c script/with-module-that-dies.pl
oof at lib/Local/Dies.pm line 6.
Compilation failed in require at script/with-module-that-dies.pl line 4.
BEGIN failed--compilation aborted at script/with-module-that-dies.pl line 4.
```

---

## Order of Operations

At this point we've established that `perl -c script.pl` will:

1. Start compiling code
1. Treat `use Module;` statement as `BEGIN { require Module; }`
1. Locate `Module` or exit
1. Successfully `eval` `Module` or exit

If all of the above are successful, we'll finally get to the `import`.

---

## `import`

> There is no builtin import function. It is just an ordinary method (subroutine) defined (or inherited) by modules that wish to export names to another module. The use function calls the import method for the package used.

[https://perldoc.perl.org/functions/import](https://perldoc.perl.org/functions/import)

If your module has a defined (or inherited) `import` subroutine it will be called after a successful `require`. If it does not have such a subroutine, then compilation continues without any warnings. It's as if nothing happened.

This is where it gets interesting for our purposes today, because what I just told you is a lie. Let's consider the following:

---

### The implicit import
```perl
use POSIX;
```

### The explicit import
```perl
use POSIX qw( setsid );
```

### The empty import
```perl
use POSIX ();
```

These examples demonstrate the three different ways in which we can `use` modules. Let's break them down individually.

---

## The implicit import
```perl
use POSIX;
```

This is equivalent to:

```perl
BEGIN {
    require POSIX;
    POSIX->import;
}
```

No big surprises here. This is essentially the example we've been dealing with up to this point.

---

## The explicit import
```perl
use POSIX qw( setsid );
```

In this form, we're actually passing arguments to the `import` method of this module. This is equivalent to:

```perl
BEGIN {
    require POSIX; 
    POSIX->import( qw( setsid ) );
}
```

So far, so good, with the exception of one thing. If you pass arguments to a module which has no `import` subroutine there will be no warning. Your arguments will silently be ignored and compilation will happily continue. So:

```perl
use ModuleWithNoImport qw( this that thing );
```
is equivalent to

```perl
use ModuleWithNoImport;
```

because there is nothing to import. Confused yet?

---

## The empty import
This brings us to our last form, the empty import.

```perl
use POSIX ();
```

This is equivalent to:

```perl
BEGIN {
    require POSIX;
}
```

Hang on. What just happened here? It turns out that passing an empty list to `use` is a way of saying "I don't want to call the `import` subroutine". Let's keep that in mind as we move forward.

To summarize, there are now two cases in which the `import` subroutine is not called. The first is when it does not exist and the second is when an empty list is passed as an argument to `use` as in `use POSIX ();`

---

## What Does `import()` Actually Do?


This is surprisingly hard to answer. There are some conventions around how might happen when a module's `import` gets called. In the general case for modules which export functions, saying

```perl
use Mojo::Util qw( trim );
```

means that you now have a `trim` function available in the package where you issued the `use` statement. (If you haven't explicitly declared a package, you're in package `main`).

However, there is no binding contract to say that this must be the case.

---

## `import()`: What Do We Really Know?

This is what we can say with certainty.

```perl
use Module;
```

* Calls `import()` if it exists
* What happens in `import()` is up to the implementor

```perl
use Module qw( some_function );
```

* Calls `import( some_function)` if `import` exists.
* If `import` does not exist, nothing happens. There is no warning that your arguments are being silently ignored.
* What can be passed as values to `import()` is left up to the implementor. For instance, it's not unusual to pass a hash reference, etc.
  * `use DDP max_depth => 2, deparse => 1;`
  * `use Test::More import => [ 'done_testing', 'is', 'ok' ];`
  * `use Test::Needs { perl => 5.020 };`
  * `use HTTP::Status qw(:constants :is status_message);`


```perl
use Module ();
```

* Bypasses `import()` entirely.
* If the module relies on `import()` being called you may be in for surprises later when you rely on certain behaviour.

---

## Multiple Imports of the Same Module

Since `import` is just a method on a class, you can call it as many times as you like:

```perl
use Module ();
use Module qw( some_function );
use Module qw( :SOME_TAG );
use Module qw( some_function );
require Module;
```

---

## Best Practices

Import declarations are where we document which symbols are available to the enclosed code. In order to best help others (and future versions of ourselves) best understand what this code actually needs, we can follow a few simple rules.

### use strict and warnings

The first import statements in your package should be:

```perl
use strict;
use warnings;
```

or some equivalent module or pragma which also enables these.

```perl
use Moose;
```

or 

```perl 
use Moo;
```

or 

```perl
use myownpragma;
```

---

### other pragmas

Unless you need to enable other pragmas in a specific order, add them after `strict` and `warnings`.

```perl
use strict;
use warnings;
use feature qw( signatures );
use namespace::autoclean;
no warnings qw( experimental::signatures );
```

---

### Everything Else

Leave a space after the pragmata and then include the other modules you need, alpha-sorted unless, for some reason, order matters.

```perl
use strict;
use warnings;
use feature qw( signatures );
no warnings qw( experimental::signatures );

use Carp qw( croak );
use Mojo::Util qw( trim );
use POSIX ();
```

`use` statements which would stretch beyond 78 characters, should try to pass arguments one per line, alpha-sorted, for readability.

```perl
use strict;
use warnings;
use feature qw( signatures );
no warnings qw( experimental::signatures );

use Carp qw( croak );
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
use Mojo::Util qw( trim );
use POSIX ();
```

---

## Sort Your use Statements

If everything is alpha-sorted, it makes it easier to see what has been used multiple times. You might be surprised how often this happens when use statements are not sorted. Keep in mind that they may not always be introduced intentionally. If you are rebasing in `git` and sorting out a merge conflict among import statements, it can be easy to introduce a second use of the same module accidentally.

---

## Stick With One Style of Parens

```perl
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
```

Perl will not stop you from being creating with your use of parentheses, but if you start mixing these up, they can be very hard to read. A more uniform look will be easier for most people to understand quickly.

---

## Stick With One Style of Padding

A consistent use of padding with arguments also makes for a more uniform, readable list. Either a single space

```perl
use AAA qw( one );
use BBB qw( two );
```

or no padding at all

```perl
use AAA qw(one);
use BBB qw(two);
```

If you mix them up, it gets harder to read.

```perl
use AAA qw(one);
use BBB qw( two );
use CCC qw( three);
use DDD qw(four );
```

---

## Avoid Export Tags

An export tag is essentially an alias for a group of symbols to import. A tag can provide a convenient shorthand, but it obscures where symbols have been imported from. They are slightly better than an implicit import, but it's much easier to grep on things if you avoid them entirely. Using import tags, our previous example might have looked like

```perl
use strict;
use warnings;
use feature qw( signatures );
no warnings qw( experimental::signatures );

use Carp qw( croak );
use HTTP::Status qw( :is status_message );
use Mojo::Util qw( trim );
use POSIX ();
```

This is more succinct, but a `grep` on `is_client_error` will not yield anything in the `use` statements, which means more digging around, unless you're already quite familiar with `HTTP::Status` and its export tags.

---

## Don't Be Clever

The `Exporter` docs advertise this supported syntax:

```perl
use Socket qw(!/^[AP]F_/ !SOMAXCONN !SOL_SOCKET);
use POSIX  qw(:errno_h :termios_h !TCSADRAIN !/^EXIT/);
```

In order to figure out what's being imported you need to 

* be very familiar with what `Socket` and `POSIX` export 
* know that they use the `Exporter` module
* look up `Exporter`'s documentation to figure out what's going on here

Think of the children. Also think of your colleagues who are not intimately familiar with Perl, who may occasionally need to poke at your code. If you make they jump through these kinds of hoops to figure out what's going on, they will not thank you.

---

## If You Insist on Cleverness

The solution to figuring out what `Exporter` does in the previous instance is incomplete. The `Exporter` docs point out that there is a debugging tool at your disposal.

```perl
BEGIN { $Exporter::Verbose=1 }
use Socket qw(!/^[AP]F_/ !SOMAXCONN !SOL_SOCKET);
use POSIX  qw(:errno_h :termios_h !TCSADRAIN !/^EXIT/);
```

### Demo: `perl script/verbose-exporter.pl`

---

## Use Modules Once

Unless you have a compelling reason, don't do this:

```perl
use Carp qw( croak );
use Carp qw( confess );
```

Inevitably what will happen is that your code will, at some future date, stop using `Carp` entirely, but one of the statements will remain because it got missed. This can happen quite easily if you have a long list of unsorted imports. At that point, someone will be left wondering why it is there (see: Checkov's Gun) and whether they can remove it (see: Chesterton's Fence).

---

## Don't require at the top level (unless you really need to)

```perl
use AAA qw( one );
use BBB qw( two );
require CCC;
use DDD qw( four );
```
is basically equivalent to:

```perl
use AAA qw( one );
use BBB qw( two );
use CCC ();
use DDD qw( four );
```

except for the fact that the `use` happens in a `BEGIN` block while the `require` does not. So, they are subtly different in that they'll be executed at different phases. With `require CCC;` we get the following compilation order.

```
$ perl -c -Ilib script/top-level-require.pl 2>/dev/null

BEGIN AAA       import AAA
BEGIN BBB       import BBB
BEGIN DDD       import DDD
```

We can see that `require CCC;` was passed over entirely. That means that if module `CCC` does not exist or does not compile, we won't know about it until runtime. This is particularly meaningful if we are testing scripts. Sometimes the best you can reasonably do is ensure that the script compiles. With the `require` in place a compilation test will happily pass even if there is a serious problem with `CCC` -- like the fact that it may not exist.

Now, if we run the script rather than just compiling it:

```
$ perl -Ilib script/top-level-require.pl

BEGIN AAA       import AAA
BEGIN BBB       import BBB
BEGIN DDD       import DDD
BEGIN CCC
```

Here we see that `CCC` does finally get an `eval` after all of the other modules, but that an `import` never happens.

If we run the script in the second format, where we've swapped out the `require` with the `use ... ()`:

```sh
$ perl -c -Ilib script/no-top-level-require.pl 2>/dev/null

BEGIN AAA       import AAA
BEGIN BBB       import BBB
BEGIN CCC
BEGIN DDD       import DDD
```

Now we see that all of the modules are `eval`'ed in the compilation phase and that this happens in a predictable order. Still no call to `CCC->import()`.

We've now established there there is a subtle but significant difference between `require CCC;` and `use CCC ();`. If we find a top level require in our code, this leaves code reviewers wondering if this difference is meaningful (Chesterton's Fence). 

If there is no good reason for `require CCC;`, stick with `use CCC ();` in cases where you don't want `import()` to be run. The uniformity will make your code easier to understand. It's also easier for the eye to scan a long list of `use` statements which aren't interrupted by a `require` which is there for reasons nobody can quite explain.

An added bonus to being discplined with `require` is that on the occasions where `require` is meaningful, your attention will be drawn to it. For example, when exporting from your own code you might `require Exporter`.

```
require Exporter;
our @ISA = qw(Exporter);
```

Having said that, you can get to the same place without the `require`:

```
use Exporter qw( import );
```

---

## Only import Modules Which You Need

Don't import modules which you aren't currently using. If you're no longer using them, remove them. If you intend to use them in future, add them at that time. One exception to this rule is modules which you are pre-loading. For instance, you may want to ensure a module is loaded into memory before forking. In this case, add a comment to clarify that this is what you are doing. (Checkov's Gun).

Doing so reduces the technical debt in your codebase as your colleagues will no longer have to reason about why this module which appears to do nothing, is in the codebase. (Chesterton's Fence).

A side effect of this is that can makes dependency management easier. Once unneccessary module imports are removed, it becomes more obvious which modules can be removed from your dependencies entirely. This may make for one less module which you need to install or perhaps even more, if this module itself depends on other packages which you aren't otherwise using. Less dependencies to install means less things which can go wrong when developing or even deploying your application.

Also consider that using fewer modules can reduce your memory footprint and even startup time. Paring down the amount of required code has multiple benefits. Pulling in dependencies which you are not using, but contrast, is generally a net negative. 

---

## Only import Symbols Which You Need

```perl
use AAA qw( one two three four five six );

print three();
```

Don't import symbols which you aren't currently using. If you're no longer using them, remove them. If you intend to use them in future, add them at that time. (Checkov's Gun).

```perl
use AAA qw( three );

print three();
```

---

## Avoid Implicit Imports at All Costs

```perl
use POSIX;
```

That imports 761 symbols into your package. Do you know what they are? Can you possibly keep this in memory?

```perl
use POSIX qw( ceil );
```

This imports 1 symbol into your package.

---

## Use Empty Parens as Documentation

```
use LWP::UserAgent ();
```

`LWP::UserAgent` has no `import()`, so there's not really a functional difference between these two uses:

```perl
use LWP::UserAgent;
use LWP::UserAgent ();
```

However, the bare parens act as documentation saying "this module imports nothing". If you're intimately familiar with all of the modules in your codebase, this distinction may not be meaningful to you, but it can be meaningful to others who also need to work on it. If I see a list of imports that is disciplined in its use of parens, then the modules with the implicit imports immediately become more obvious.

```perl
use Moose;

use Carp qw( croak );
use Data::Printer; # exports p() and np() by default
use LWP::UserAgent ();
use POSIX qw( ceil );
```

The magic of `Moose` happens when you import its symbols into your package. This is one case where implicit imports are a reasonable convention.

For the record, those exports are:

```
.--------------------------.
| Default Exported Symbols |
+--------------------------+
| after                    |
| around                   |
| augment                  |
| before                   |
| blessed                  |
| confess                  |
| extends                  |
| has                      |
| inner                    |
| isa                      |
| meta                     |
| override                 |
| super                    |
| with                     |
'--------------------------'
```

Aside from the fact that `Data::Printer` exports `p()` and `np()` functions into your package, it also does other interesting things in your `import()`, like looking for user configuration files. Having this as the only import without parens makes clear that something special is happening here. You can also pass args to `Data::Printer`, but in the general case, if you're using it for quick debugging, you probably won't need to do this.