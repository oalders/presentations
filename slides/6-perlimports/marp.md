---
marp: true
---

# Where Did That Symbol Come From?

This will include a discussion of `Exporter`, `Sub::Exporter` and `Import::Into`. It will probably include some examples of other unexpected behaviour that may take place when `Foo->import` is called.

---

# What is a Symbol?

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

---

# goimports

---

# App::perlimports

Bare imports and import tags provide the code author with a convenience, but this can come at the cost of readability for everyone else. We will walk through using perlimports from the command line and see how it attempts to clean up import statements in a selection of a code, a file or even an entire codebase.

---

# perlimports in vim

 We will discuss how to use similar techniques with a simple vim integration, so that imports can be cleaned up directly in the vim editor. If perlimports does not present itself as a workable solution for an audience member, the preceding discussion should provide some food for thought as to how technical debt on an existing code base can be reduced through wise use of import statements.