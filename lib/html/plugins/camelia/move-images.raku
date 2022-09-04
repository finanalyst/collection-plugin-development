#!/usr/bin/env raku
use v6.d;
sub ( $pp, %options --> Array ) {
    # need to move fonts in directory to asset file
    my $dir = 'image';
    my @move-to-dest;
    for $dir.IO.dir -> $fn {
        @move-to-dest.push( ("assets/images/$fn", 'myself', "images/$fn", ) );
    }
    @move-to-dest
}