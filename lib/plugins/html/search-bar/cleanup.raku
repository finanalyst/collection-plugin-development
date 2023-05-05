#!/usr/bin/env raku
use v6.d;
# cleanup the directory
sub ($pr, %processed, %options ) {
    'search-bar.js'.IO.unlink
}