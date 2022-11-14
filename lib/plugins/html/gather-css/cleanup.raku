use v6.d;
sub ($pr, %processed, %options --> Array ) {
    for dir(:test( *.ends-with('.css'))) {
        note "deleting $_" unless %options<no-status>;
        .unlink
    }
    note "deleting css-templates.raku" unless %options<no-status>;
    "css-templates.raku".IO.unlink;
    []
}