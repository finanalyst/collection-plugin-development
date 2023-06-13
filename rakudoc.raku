#!/usr/bin/env raku
use v6.d;
my grammar Markers {
    rule marker {
        "\xff\xff" ~ "\xff\xff" .+?
    }
    rule TOP {
        [<marker> .*? ]+ $
    }
}
my $t = $=finish;

#my $parsed = $t ~~ / ( "\xFF\xFF" ~ "\xFF\xFF" ( .+? ) .*? ]+ $ /;
#my $parsed = Markers.parse( $t );
my @tokens;
my $nt;
for $parsed.chunks -> $c {
    if ~$c.key eq 'marker' {
        @tokens.push( $c.value<content> );
        $nt ~= "\xFF\xFF"
    }
    else {
        $nt ~= $c.value
    }
}
#my $parsed = $t.subst( / <marker> /,{ say "chunk is: ｢$_｣ and content is { $/<content> }"; @tokens.push( .<content> ); "\xff\xff" },:g);
say @tokens;
say "old: $t";
say "new: $nt";
=finish
    =begin code :allow< B R >
    sub demo {
        B<say> 'Hello R<name>';
        I<note> 'The I format is not recognised';
    }
    =end code

An X<array|ÿÿ<strong>ÿÿarrays, definition ofÿÿ</strong>ÿÿ> is an ordered list of scalars
indexed by number. A X<hash|ÿÿ<strong>ÿÿhashes, definition ofÿÿ</strong>ÿÿ>
is an unordered collection of scalar values indexed by their
associated string key.
