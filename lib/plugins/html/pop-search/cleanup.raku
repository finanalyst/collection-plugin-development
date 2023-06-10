#!/usr/bin/env raku
use v6.d;
# cleanup the directory
sub ($pr, %processed, %options ) {
    'pop-search-bar.js'.IO.spurt: '// This is a placeholder file for gather-js-jq, which is overwritten in compilation stage';
    'pop-search-extended.js'.IO.spurt: '// This is a placeholder file for gather-js-jq, which is overwritten in compilation stage';
}