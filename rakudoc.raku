#!/usr/bin/env raku
use v6.d;
use JSON::Fast;
my %h = from-json $=finish;
say %h.raku;
# more lines of code

#|(This is a sub example
With several lines
)
sub nothing() { ... }

my $x = nothing();


=finish
{ "key1": "a string value", "key2": "another value" }