use v6.d;
sub ($destination, $landing-place, $output-ext, %completion-options, %options) {
    my $ebook-path-name = %completion-options<ebook-embed><ebook-path-name>;
    run <<zip -rq $ebook-path-name $destination>>;
}
