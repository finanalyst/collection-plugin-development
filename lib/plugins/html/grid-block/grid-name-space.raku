#!/usr/bin/env raku
use v6.d;
sub ( $pp, %options --> Array ) {
    if 'grid-block' ~~ any( $pp.plugin-datakeys ) {
       my @ns = $pp.get-data('grid-block');
        @ns = [];
    }
    else {
        $pp.add-data('grid-block', @( ) );
    }
    []
}