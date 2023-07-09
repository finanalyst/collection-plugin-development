#!/usr/bin/env raku
use v6.d;
# cleanup the directory
sub ($pr, %processed, %options ) {
    'sidebar-search-extended.js'.IO.spurt: '// This is a placeholder file for gather-js-jq, which is overwritten in compilation stage';
}