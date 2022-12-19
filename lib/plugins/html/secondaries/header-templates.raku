#!/usr/bin/env raku
use v6.d;
%(
    'heading' => sub ( %prm, %tml ) {
        return 'secondaries heading installed' if %prm<_test>;
    # The grammar and actions are taken from Documentable
    # The tokens and actions have to be written out separately because this is an anonymous sub
    # grammar DefinitionHeading {
        my token operator    { infix  | prefix   | postfix  | circumfix | postcircumfix | listop }
        my token routine     { sub    | method   | term     | routine   | submethod     | trait  }
        my token syntax      { twigil | constant | variable | quote     | declarator             }
        my token subkind     { <routine> | <syntax> | <operator> }
        my token name        { .*  } # is rw
        my token single-name { \S* } # infix

        my rule the-foo-infix {^\s*[T|t]'he' <single-name> <subkind>\s*$}
        my rule infix-foo     {^\s*<subkind> <name>\s*$}

        my rule TOP { <the-foo-infix> | <infix-foo> }
    #}

    #my class DefinitionHeadingActions {
    #    has Str  $.dname     = '';
    #    has      $.dkind     ;
    #    has Str  $.dsubkind  = '';
    #    has Str  $.dcategory = '';
    #
    #    method name($/) {
    #        $!dname = $/.Str;
    #    }
    #
    #    method single-name($/) {
    #        $!dname = $/.Str;
    #    }
    #
    #    method subkind($/) {
    #        $!dsubkind = $/.Str.trim;
    #    }
    #
    #    method operator($/) {
    #        $!dkind     = Kind::Routine;
    #        $!dcategory = "operator";
    #    }
    #
    #    method routine($/) {
    #        $!dkind     = Kind::Routine;
    #        $!dcategory = $/.Str;
    #    }
    #
    #    method syntax($/) {
    #        $!dkind     = Kind::Syntax;
    #        $!dcategory = $/.Str;
    #    }
    #}

        # get the heading information structure
        my $text = %prm<text> // '';
        my $target = %tml<escaped>(%prm<target>);
        my $level = %prm<level> // '1';
        my $bookmark = '';
        unless %prm<skip-parse> {
            my $parsed = $text ~~ / <TOP> /;
            if $parsed {
                my $kind;
                my $category;
                my $fn = %prm<config><name>;
                with $parsed<TOP><infix-foo><subkind><routine> { $kind = 'routine'; $category = .Str }
                with $parsed<TOP><infix-foo><subkind><syntax> { $kind = 'syntax'; $category = .Str }
                with $parsed<TOP><infix-foo><subkind><operator> { $kind = 'routine'; $category = 'operator' }
                %prm<heading><defs>{ $fn } = {} unless %prm<heading><defs>{ $fn }:exists;
                %prm<heading><defs>{ $fn }{ $target } = %(
                    name       => ~$parsed<TOP><infix-foo><name> // ~$parsed<TOP><infix-foo><single-name>,
                    :$kind,
                    subkind   => ~$parsed<TOP><infix-foo><subkind>,
                    :$category, # only one category per defn
                );
                $bookmark = "<!-- defnmark $target -->";
            }
        }
        # now output the header
        '<h' ~ $level
            ~ ' id="'
            ~ $target
            ~ '"><a href="#'
            ~ %tml<escaped>(%prm<top>)
            ~ '" class="u" title="NEW TITLE=Go to top">'
            ~ $text
            ~ '</a></h'
            ~ $level
            ~ ">\n$bookmark\n"
    },
);
