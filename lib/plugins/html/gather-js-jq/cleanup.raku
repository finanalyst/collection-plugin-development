use v6.d;
sub ($pr, %processed, %options --> Array ) {
    "js-templates.raku".IO.unlink;
    say "deleting js-templates.raku from gather-js-jq" unless %options<collection-info>;
    []
}