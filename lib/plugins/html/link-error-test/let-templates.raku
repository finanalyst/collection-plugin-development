#!/usr/bin/env perl6
%(
    linkerrortest => sub (%prm, %tml) {
        my $rv = '';
        if %prm<linkerrortest>:exists and +%prm<linkerrortest>.keys {
            my $data = %prm<linkerrortest>;
            # structure: no-file|no-target|unknown|remote
            my %titles = %(
                no-file => %(:t('Links to missing files'), :h(q:to/HEADER/) ),
                    <div class="let-file header">
                        <div>Document containing link
                            <div class="let-clickable">Click for originating document in new tab</div>
                        </div>
                        <div class="let-link-text header">Originating link text
                                <div class="let-link-file header">Non-Existent target file</div>
                        </div>
                    </div>
                    HEADER
                no-target => %(:t('Links to non-existent interior targets'), :h(q:to/HEADER/) ),
                    <div class="let-file header">
                        <div>Document containing link
                            <div class="let-clickable">Click for originating document in new tab</div>
                        </div>
                        <div class="let-link-text header">Originating link text
                            <div class="let-link-file header">
                                <div>A document generates a web-page
                                    <div class="let-clickable">Click for destination document in new tab</div>
                                </div>
                                <div class="let-link-target header">An internal target is referenced but does not exist (variants tried)</div>
                            </div>
                        </div>
                    </div>
                    HEADER
                unknown => %(:t('Unknown target schema (typo in L<> ?)'), :h(q:to/HEADER/) ),
                    <div class="let-file header">
                        <div>Document containing link
                            <div class="let-clickable">Click for originating document in new tab</div>
                        </div>
                        <div class="let-link-text header">Originating link text
                            <div class="let-link-file header">Non-Existent target file</div>
                        </div>
                    </div>
                    HEADER
                remote => %(:t('Remote http/s links with bad host or 404'), :nh(q:to/NHEADER/), :h(q:to/HEADER/) ),
                    <div class="let-file header">
                        <div class="let-response header">
                            <div>Remote link test skipped</div>
                            <div class="let-link-text header">LET plugin config file has 'no-remote' set</div>
                        </div>
                    </div>
                    NHEADER
                    <div class="let-file header">
                        <div>Document containing link
                            <div class="let-clickable">Click for originating document in new tab</div>
                        </div>
                        <div class="let-link-text header">Originating link text</div>
                        <div class="let-url header">Dubious url
                            <div class="let-response header">Error response</div>
                        </div>
                        </div>
                    </div>
                    HEADER
            );
            my $lnk = 'LET-000';
            for <remote no-target unknown no-file> -> $type {
                my %object = $data{$type};
                if $type eq 'remote' and %object<no_test> {
                    $rv ~= '<h2 class="raku-h2">' ~ %titles{$type}<t> ~ "</h2>\n"
                        ~ %titles{$type}<nh>;
                    next
                }
                next unless %object.elems;
                my $init = '<h2 class="raku-h2">' ~ %titles{$type}<t> ~ "</h2>\n";
                my $body = %titles{$type}<h>;
                for %object.sort.grep( { .value ~~ Positional } ).map(|*.kv) -> $fn, $resp {
                    $body ~= qq:to/BODY/;
                        <div id="{ ++$lnk }" class="let-file">
                            <div>$fn
                                <a class="let-clickable" href="$fn" target="_blank" rel="noopener noreferrer">Clickable\</a>
                            </div>
                        BODY
                    when $type eq 'no-file' {
                        for $resp.list -> %info {
                            $body ~= '<div class="let-link-text">' ~ %tml<escaped>( %info<link-label> )
                                ~ '<div class="let-link-file">'
                                ~ %tml<escaped>(%info<file>)
                                ~ '</div></div>'
                        }
                    }
                    when $type eq 'unknown' {
                        for $resp.list -> %info {
                            $body ~= '<div class="let-link-text">' ~ %tml<escaped>( %info<link-label> ) ~ '</div>'
                                ~ '<div class="let-links">'
                                ~ %tml<escaped>(%info<url>)
                                ~ '</div>'
                        }
                    }
                    when $type eq 'remote' {
                        for $resp.list -> %info {
                            $body ~='<div class="let-link-text">' ~ %tml<escaped>( %info<link-label> ) ~ '</div>'
                                ~  '<div class="let-links">'
                                ~ %tml<escaped>( %info<url> )
                                ~ '<div class="let-response">'
                                ~ %info<resp>
                                ~ "</div></div>\n"
                        }
                    }
                    when $type eq 'no-target' {
                        $init ~= q:to/NOTRG/;
                            <div class="table"><table>
                                <tr><th>Source name</th><th>No of errors</th></tr>
                            NOTRG
                        for $resp.list -> %info {
                            $init ~= '<tr><td><a href="#' ~ $lnk ~ '">'
                                ~ %tml<escaped>( %info<file> ) ~ '</a></td><td>'
                                ~ %info<targets>.elems ~ "</td></tr>\n"
                            ;
                            $body ~= '<div class="let-link-text">' ~ %tml<escaped>( %info<link-label> )
                                ~ '<div class="let-link-file">'
                                ~ %tml<escaped>( %info<file> )
                                ~ '<a class="let-clickable" href="' ~ %tml<escaped>( %info<file> ) ~ '" target="_blank" rel="noopener noreferrer">Clickable</a></div>'
                                ~ %info<targets>.map( {
                                    '<div class="let-link-target">'
                                    ~ %tml<escaped>( $_ )
                                    ~ '</div>'
                                } )
                                ~ "</div>\n"
                        }
                        $init ~= "</table></div>\n"
                    }
                }
                $rv ~= $init ~ $body ~ "</div>\n"
            }
        }
        else {
            $rv = "<div><h2>Link Tests</h2>No errors detected</div>"
        }
        $rv
    },
)