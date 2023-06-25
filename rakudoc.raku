#!/usr/bin/env raku
use v6.d;
say $=pod.raku;
=begin pod

=begin table
    Markup instruction  +   Specifies
    __________________  +   ___________________________________________________________
    A<...>              +   Replaced by contents of specified macro/object
    B<...>              +   Basis/focus of sentence (typically rendered bold)
    C<...>              +   Code (typically rendered fixed-width)
    D<...\|...;...>     +   Developer note (D<visible text\|version; Notification text>
    E<...;...>          +   Entity names or numeric codepoints (E<entity1;entity2;...>
    G<...\|...>         +   Insert an inline graphic (G<alt text\|url>
    I<...>              +   Important (typically rendered in italics)
    K<...>              +   Keyboard input (typically rendered fixed-width)
    L<...\|...>         +   Link (L<display text\|destination URI>
    N<...>              +   Note (not rendered inline)
    P<...>              +   Placement link
    V<...>              +   Replaceable component or metasyntax
    S<...>              +   Space characters to be preserved
    T<...>              +   Terminal output (typically rendered fixed-width)
    U<...>              +   Unusual (typically rendered with underlining)
    V<...>              +   Verbatim (internal Markup instructions ignored)
    X<...\|..,..;...>   +   Index entry (X<display text\|entry,subentry;...>
    Z<...>              +   Zero-width comment (contents never rendered)

=end pod