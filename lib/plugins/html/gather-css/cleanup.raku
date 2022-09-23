use v6.d;
sub ($pr, %processed, %options --> Array ) {
    for dir(:test( *.ends-with('.css'))) {
        note "deleting $_";
        .unlink
    }
    note "deleting css-templates.raku";
    "css-templates.raku".IO.unlink;
    []
}