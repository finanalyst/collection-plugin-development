#!/usr/bin/env raku
use v6.d;
%(
    tablesearch => sub (%prm, %tml ) {
        with %prm<tablesearch> {
            with .{ %prm<data> } {
                if $_ ~~ Positional and .elems > 1 and .[0].elems > 0 {
                    my $cols = .[0].elems;

                }
                else {
                    qq:to/ERROR/;
                    <div class="listf-error">The data set corresponding to
                    ｢{ %prm<data> }｣ is in the wrong format, has no data rows, or has no columns.
                    This is being rendered from
                    a Rakudoc directive ｢=TableSearch :data<{ %prm<data> }>｣
                    </div>
                    ERROR
                }
            }
            else {
                qq:to/ERROR/;
                <div class="listf-error">There is no data corresponding to
                the data set ｢{ %prm<data> }｣. This is being rendered from
                a Rakudoc directive ｢=TableSearch :data<{ %prm<data> }>｣
                </div>
                ERROR
            }
        }
        else {
            q:to/ERROR/;
            <div class="listf-error">tablesearch has no collected data,
            Is ｢tablesearch｣ in the Mode's ｢plugins-required<render>｣ list?
            Another plugin needs to provide the data set needed.
            </div>
            ERROR
        }
    },
)