use v6.d;
sub ($pr, %processed, %options --> Array ) {
    for dir(:test( *.ends-with('.css'))) {
        note "deleting $_ from gather-css" unless %options<collection-info>;
        .unlink
    }
    note "deleting css-templates.raku from gather-css" unless %options<collection-info>;
    "css-templates.raku".IO.unlink;
    []
}