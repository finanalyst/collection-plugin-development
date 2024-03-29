use v6.d;
sub ($pr, %processed, %options --> Array ) {
    "metadata.opf".IO.unlink;
    note "deleting metadata.opf from ebook-embed" if %options<collection-info>;
    []
}
