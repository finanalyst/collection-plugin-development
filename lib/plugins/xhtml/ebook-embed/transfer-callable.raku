use v6.d;
sub ($pr, %processed, %options --> Array ) {
    for <metadata.opf toc.xhtml index.xhtml> {
        .IO.unlink;
        note "deleting $_ from ebook-embed" if %options<collection-info>;
    }
    []
}
