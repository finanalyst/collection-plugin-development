#!/usr/bin/env raku
use v6.d;
my %temp = %(
    'heading' => sub (%prm, %tml) {
        my grammar DefinitionHeading {
            token operator { infix | prefix | postfix | circumfix | postcircumfix | listop }
            token routine { sub | method | term | routine | submethod | trait }
            token syntax { twigil | constant | variable | quote | declarator }
            token subkind { <routine> | <syntax> | <operator> }
            token name { .* }
            token single-name { \S* }
            token the-foo-infix {
                ^ \s* [T | t]'he' \s <single-name> \s <subkind> \s* $
            }
            rule infix-foo {
                ^\s*<subkind> <name>\s*$
            }

            rule TOP { <the-foo-infix> | <infix-foo>  }
        }

        my class DefinitionHeadingActions {
            has Str  $.dname     = '';
            has      $.dkind     ;
            has Str  $.dsubkind  = '';
            has Str  $.dcategory = '';

            method name($/) {
                $!dname = $/.Str;
            }

            method single-name($/) {
                $!dname = $/.Str;
            }

            method subkind($/) {
                $!dsubkind = $/.Str.trim;
            }

            method operator($/) {
                $!dkind     = Kind::Routine;
                $!dcategory = "operator";
            }

            method routine($/) {
                $!dkind     = Kind::Routine;
                $!dcategory = $/.Str;
            }

            method syntax($/) {
                $!dkind     = Kind::Syntax;
                $!dcategory = $/.Str;
            }
        }
        # get the heading information structure
        my $parsed = DefinitionHeading.parse( %prm<contents> );
        say $parsed.raku
    },
);

%temp<heading>.( { :contents<method say(Str $s) {...}> }, {});

