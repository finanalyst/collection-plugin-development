use v6.d;
sub ( $pr, %processed, %options) {
    my %config = $pr.get-data('ebook-embed');
    my @meta;
    my @spine;
    my %toc = %(
        # Website tabs
        #Introduction page
        #=for ListFiles :select<kind=Language, category=beginning>
        #Getting started
        'Getting started' =>
        #
        #=for ListFiles :select<kind=Language, category=migration>
        #Migration guides
        #
        #=for ListFiles :select<kind=Language, category=tutorial>
        #Tutorials
        #
        #Reference page
        #=for ListFiles :select<kind=Language, category=fundamental>
        #Fundamental topics
        #
        #=for ListFiles :select<kind=Language, category=reference>
        #General reference
        #
        #Introduction page
        #=for ListFiles :select<kind=Language, category=beginning>
        #Getting started
        #
        #=for ListFiles :select<kind=Language, category=migration>
        #Migration guides
        #
        #=for ListFiles :select<kind=Language, category=tutorial>
        #Tutorials
        #
        #miscellaneous
        #=for ListFiles :select<kind=Language, category=advanced>
        #Advanced topics
        #
        #=for ListFiles :select<kind=Programs>
        #Programs

    my $metadata-start = qq:to/META/;
    <?xml version='1.0' encoding='utf-8'?>
    <package xmlns="http://www.idpf.org/2007/opf" unique-identifier="RakuDocumentationEbook" version="2.0">
      <metadata xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/"  xmlns:opf="http://www.idpf.org/2007/opf">
        <dc:creator opf:file-as="ebook-embed Collection plugin" opf:role="aut">ebook-embed Collection plugin</dc:creator>
        <dc:subject>Rakulang</dc:subject>
        <dc:subject>Documentation</dc:subject>
        <dc:identifier id="RakuDocumentationEbook" opf:scheme="uuid">24cb6cd3-e3ff-46cb-9d09-48c414a0a18f</dc:identifier>
        <dc:contributor opf:role="bkp">Collection [https://github.com/finanalyst/Collection]</dc:contributor>
        <dc:title>Raku Documentation</dc:title>
        <dc:language>en</dc:language>
        <dc:description>The Raku documentation suite in Ebook form</dc:description>
        <dc:publisher>Raku Steering Council</dc:publisher>
        <dc:date>{ DateTime.now.utc }</dc:date>
      </metadata>
      <manifest>
    META
    my $spinedata-start = "  <spine toc=\"ncx\">\n";
    my $toc-start = qq:to/TOC/;
    <?xml version="1.0" encoding="utf-8"?>
    <!DOCTYPE html>
    <html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
        <head>
            <title>Raku Official Documentation</title>
            <meta charset="utf-8"/>
        </head>
        <body>
            <nav epub:type="toc">
                <h1>Contents</h1>
                <ol>
    TOC
    for %processed.kv -> $fn, $podf {
        @meta.push: qq[    <item id="$fn" href="$fn\.xhtml" media-type="application/xhtml+xml"></item>\n];
        @spine.push: qq[     <itemref idref="$fn"></itemref>\n];
        @toc.push: qq[];
    }
    'metadata.opf'.IO.spurt:
        $metadata-start ~ [~] @meta ~ "  </manifest>\n"
        ~ $spinedata-start ~ [~] @spine ~ "  </spine>\n</package>\n";
    [
        ['metadata.opf', 'myself', 'metadata.opf'],
    ]
}

