
sub ( $pp, %options ) {
    # need to move fonts in directory to asset file
    my $dir = 'fontawesome5_15_4/webfonts';
    my @move-to-dest;
    for $dir.IO.dir -> $fn {
        @move-to-dest.push( ('assets/' ~ $fn.IO.relative('fontawesome5_15_4'), 'myself', "$fn", ) );
    }
    # add all files to custom data section so they can be included in the manifest
    note 'The ebook-embed plugin must come before font-awesome plugin in the render section'
        unless $pp.plugin-datakeys (cont) 'ebook-embed';
    my %custom := $pp.get-data('ebook-embed');
    %custom<for-manifest>.append: @move-to-dest.map( *.[0] );
    @move-to-dest
}