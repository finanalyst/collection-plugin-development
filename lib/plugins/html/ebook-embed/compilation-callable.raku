use v6.d;
sub ( $pr, %processed, %options) {
    my @meta;
    my @spine;
    my %toc = %(
        'Language_beginning_Language' => %( :name<Getting started>, :contents( [ ] ) ),
        'Language_migration_Language' => %( :name<Migration guides>, :contents( [ ] ) ),
        'Language_tutorial_Language' => %( :name<Tutorials>, :contents( [ ] ) ),
        'Language_fundamental_Language' => %( :name<Fundamental topics>, :contents( [ ] ) ),
        'Language_reference_Language' => %( :name<General reference>, :contents( [ ] ) ),
        'Language_advanced_Language' => %( :name<Advanced topics>, :contents( [ ] ) ),
        Programs_programs_programs => %( :name<Programs>, :contents( [ ] ) ),
    );
    my $metadata-start = qq:to/META/;
    <?xml version='1.0' encoding='utf-8'?>
    <package dir="ltr" xmlns="http://www.idpf.org/2007/opf" xml:lang="en" unique-identifier="RakuDocumentationEbook" version="3.0">
      <metadata xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/"  xmlns:opf="http://www.idpf.org/2007/opf">
        <dc:creator>The Raku Community</dc:creator>
        <dc:subject>Rakulang</dc:subject>
        <dc:subject>Documentation</dc:subject>
        <dc:identifier id="RakuDocumentationEbook" opf:scheme="uuid">24cb6cd3-e3ff-46cb-9d09-48c414a0a18f</dc:identifier>
        <dc:contributor opf:role="bkp">Collection [https://github.com/finanalyst/Collection]</dc:contributor>
        <dc:title>Raku Canonical Documentation</dc:title>
        <dc:language>en</dc:language>
        <dc:description>The Raku documentation suite in Ebook form</dc:description>
        <dc:author>The Raku Community</dc:author>
        <dc:publisher>Raku Steering Council</dc:publisher>
        <dc:license>Artistic 2.0</dc:license>
        <dc:rightsHolder>The Perl & Raku Foundation</dc:rightsHolder>
        <dc:date>{ DateTime.now.utc }</dc:date>
      </metadata>
      <manifest>
        <item href="toc.xhtml" id="toc" media-type="application/xhtml+xml" properties="nav"/>
    META
    my $spinedata-start = "\t<spine toc=\"toc\">\n\t\t<itemref idref=\"toc\"></itemref>\n";
    for %processed.kv -> $fn, $podf {
        @meta.push: qq[   <item id="$fn" href="$fn\.xhtml" media-type="application/xhtml+xml"></item>\n];
        @spine.push: qq[    <itemref idref="$fn"></itemref>\n];
        # create TOC data
        my $kind = $podf.pod-config-data<kind> // '';
        my $subkind = $podf.pod-config-data<subkind> // '';
        my $cat = $podf.pod-config-data<category> // '';
        my $key = $kind ~ '_' ~ $cat ~ '_' ~ $subkind;
        unless %toc{$key}:exists {
            %toc{$key} = %( :contents([ ]), :name(
                $subkind.tc ~ ' ' ~ $cat ~ ($cat.ends-with('s') ?? 'es' !! 's')
            ) )
        }
        %toc{$key}<contents>.push:
            $pr.tmpl<toc-chapter>.( %( :toc($podf.raw-toc), :$fn, :title( $podf.title ) ), $pr.tmpl )
    }
    my $toc = q:to/TOC/;
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
        <html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
        <head>
            <title>Raku Documentation</title>
            <meta charset="utf-8"/>
        </head>
        <body>
            <nav epub:type="toc">
                <h1>Table of Contents</h1>
                <ol class="contents">
        TOC
    my $toc-end = q:to/TOC/;
                </ol> <!-- contents -->
            </nav>
        </body>
        </html>
        TOC
    for <Language_beginning_Language Language_tutorial_Language
    Language_migration_Language Language_fundamental_Language
    Language_reference_Language Language_advanced_Language
    Programs_programs_programs> -> $key {
        my %data = %toc{ $key }:delete;
        next unless %data<contents>.elems;
        $toc ~= $pr.tmpl<toc-section>.( %( :%data, :$key), $pr.tmpl)
    }
    for %toc.sort.map( |*.kv ) -> $key, %data {
        $toc ~= $pr.tmpl<toc-section>.( %( :%data, :$key), $pr.tmpl)
    }
    'toc.xhtml'.IO.spurt: $toc ~ $toc-end;
    'metadata.opf'.IO.spurt:
        $metadata-start ~ [~] @meta ~ "  </manifest>\n"
        ~ $spinedata-start ~ [~] @spine ~ "  </spine>\n</package>\n";
    [
        ['metadata.opf', 'myself', 'metadata.opf'],
        ['toc.xhtml', 'myself', 'toc.xhtml'],
    ]
}

