#!/usr/bin/env raku
use v6.d;
use JSON::Fast;
use ProcessedPod;

sub ($pp, %processed, %options) {
    # This routine creates the JS data structure to be added to the JS query function
    # The data structure is an array of hashes :category, :value, :url
    # Category is used to split up items, value is what is searched for, url is where it is to be found.
    # eg { "category": "Types", "value": "Distribution::Hash", "url": "/type/Distribution::Hash" }
    # The first three items are supplied for some reason.
    #| total length of search bar in char
    my $search-len = 110;
    #| the number of extra chars in the candidate rendering
    #| spaces in the break between the value and the info section
    #| [  ]
    my $bar-chars = 8;
    my @entries =
        %( :category("Syntax"), :value("# single-line comment"), :url("/language/syntax#Single-line_comments"), :type<source> ),
        %( :category("Syntax"), :value("#` multi-line comment"), :url("/language/syntax#Multi-line_/_embedded_comments"), :type<source> ),
        %( :category("Signature"), :value(";; (long name)"), :url("/type/Signature#index-entry-Long_Names"), :type<source> )
    ;
    my @extended-entries;
    my $categories = <Syntax Signature Heading Indexed>.SetHash;
    # collect info stored from parsing headers
    # structure of processed
    # <filename> => %( :config-data => :kind, @sub-kind, @category )
    # Helper functions as in Documentable
    sub escape(Str $s) is export {
        $s.trans([</ \\ ">] => [<\\/ \\\\ \\">]);
    }
    sub escape-json(Str $s) is export {
        $s.subst(｢\｣, ｢%5C｣, :g).subst('"', '\"', :g).subst(｢?｣, ｢%3F｣, :g)
    }
    for %processed.kv -> $fn, $podf {
        my $value = $podf.title;
        my $info = '';
        # some files dont have a subtitle, so no extra information to show
        with $podf.subtitle {
            if m/ \S / {
                $info = .subst(/ '<p>' | '</p>' /,'',:g);
                my $vals = $value.chars;
                if ( $vals + $bar-chars + $info.chars ) > $search-len {
                    $info = '<i>'
                        ~  $info.substr( 0, ( $search-len - $vals - $bar-chars - 4 ) )
                        ~ '</i> ... '
                }
                else {
                    $info = "<i>$info\</i>"
                }
            }
        }
        if $fn ~~ / ^ [ 'syntax/' | 'routine/' ] / {
            @extended-entries.push: %(
                :category($podf.pod-config-data<subkind>.tc),
                :$value,
                :$info,
                :url(escape-json('/' ~ $fn)),
                :type<composite>,
            )
        }
        else {
            @entries.push: %(
                :category( $podf.pod-config-data<subkind>.tc // 'Language' ), # a default subkind in case one is missing.
                :$value,
                :$info,
                :url(escape-json('/' ~ $fn)),
                :type<primary>,
            )
        }
        for $podf.raw-toc.grep({ !(.<is-title>) }) {
            @extended-entries.push: %(
                :category<Heading>,
                :value(.<text>),
                :info(': section in <b>' ~ $podf.title ~ '</b>'),
                :url(escape-json('/' ~ $fn ~ '#' ~ .<target>)),
                :type<headings>,
            )
        }
        for $podf.raw-glossary {
            my $value = .key;
            for .value.list {
                next if .<is-header>;
                @extended-entries.push: %(
                    :category<Indexed>,
                    :$value,
                    :info("[ { .<place> } ] in <b>{ $podf.title }\</b>"),
                    :url(escape-json('/' ~ $fn ~ '#' ~ .<target>)),
                    :type<indexed>,
                )
            }
        }
        $categories{ $podf.pod-config-data<kind>.tc }++
    }
    # try to filter out duplicates by looking for only unique urls
    @entries .= unique(:as(*.<url>));
    # now sort so js only does filtering.
    my $search-order = -> $pre, $pos {
        if $pre.<category> ne 'Language' and $pos.<category> eq 'Language' { Order::More }
        elsif $pos.<category> ne 'Language' and $pre.<category> eq 'Language' { Order::Less }
        elsif $pre.<url>.contains('5to6') and $pos.<category> eq 'Language' and ! $pos.<url>.contains('5to6') { Order::More }
        elsif $pos.<url>.contains('5to6') and $pre.<category> eq 'Language' and ! $pre.<url>.contains('5to6') { Order::Less }
        elsif $pre.<category> ne 'Composite' and $pos.<category> eq 'Composite' { Order::More }
        elsif $pos.<category> ne 'Composite' and $pre.<category> eq 'Composite' { Order::Less }
        elsif $pre.<category> ne 'Indexed' and $pos.<category> eq 'Indexed' { Order::Less }
        elsif $pos.<category> ne 'Indexed' and $pre.<category> eq 'Indexed' { Order::More }
        elsif $pre.<category> ne 'Heading' and $pos.<category> eq 'Heading' { Order::Less }
        elsif $pos.<category> ne 'Heading' and $pre.<category> eq 'Heading' { Order::More }
        elsif $pre.<category> ne $pos.<category> { $pre.<category> leg $pos.<category> }
        else { $pre.<value> leg $pos.<value> }
    }
    @entries .= sort( $search-order );
    'pop-search-bar.js'.IO.spurt: qq:to/JS1/;
        var items =
        { JSON::Fast::to-json(@entries) }
        ;
        { 'pop-search-temp.js'.IO.slurp }
        JS1
    @extended-entries .= sort( $search-order );
    'pop-search-extended.js'.IO.spurt: qq:to/JS2/;
        var itemsExtended = { JSON::Fast::to-json( @extended-entries ) }
        ;
        for (var i = 0, len = itemsExtended.length; i < len; i++) \{
            items.push(itemsExtended[i]);
        }
        needExtendedItems = false;
        JS2

    [
        ['assets/scripts/pop-search-bar.js', 'myself', 'pop-search-bar.js'],
        ['assets/scripts/pop-search-extended.js', 'myself', 'pop-search-extended.js'],
    ]
}