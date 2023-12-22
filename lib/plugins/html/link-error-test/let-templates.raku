#!/usr/bin/env perl6
%(
    linkerrortest => sub (%prm, %tml) {
        my $rv = '';
        if %prm<linkerrortest>:exists and +%prm<linkerrortest>.keys {
            my $data = %prm<linkerrortest>;
            # structure: no-file|no-target|unknown|remote
            my %titles =
                no-file => %( :div('Links to missing files'), :cap(q:to/CAP/), ),
                    <table class="table"><tr>
					<th>Document with glitch</th>
                    <th>Displayed text</th>
                    <th>Non-Existent target file</th>
                    </tr>
                    CAP
                no-target => %( :div('Links to non-existent interior targets'), :cap(q:to/CAP/), ),
                    <table class="table"><tr>
					<th>Document with glitch</th>
                    <th>Displayed text</th>
                    <th col-span="2">Document containing anchor</th>
                    <th>Attempted anchor name (variants tried)</th>
                    </tr>
                    CAP
                unknown => %( :div('Unknown target schema (typo in L<> ?)'), :cap(q:to/CAP/), ),
                    <table class="table"><tr>
					<th>Document with glitch</th>
                    <th>Displayed text</th>
                    <th>Dubious url</th>
                    </tr>
                    CAP
                remote  => %( :div('Remote http/s links with bad host or 404'), :cap(q:to/CAP/), :not-set(q:to/NOT/),),
                    <table class="table"><tr>
					<th>Document with glitch</th>
                    <th>Displayed text</th>
                    <th>Dubious url</th>
                    <th>Error response</th>
                    </tr>
                    CAP
                    <table class="table"><tr>
					<th>Remote link test skipped</th>
                    <th>Link-error-test plugin has option <strong>no-remote</strong> set to True</th>
                    </tr>
                    NOT
            ;
            for <remote no-target unknown no-file> -> $type {
                my %object = $data{$type};
                next unless %object.elems;
                $rv ~= '<h2 class="raku-h2">' ~ %titles{$type}<div> ~ "</h2>\n";
                if $type eq 'remote' and %object<no_test> {
                    $rv ~= %titles{$type}<not-set>
                }
                else {
                    $rv ~= %titles{$type}<cap>;
                    for %object.sort.grep( { .value ~~ Positional } ).map(|*.kv) -> $fn, $resp {
                        $rv ~= qq:to/HEAD/;
                            <tr>\<td>\<a class="button" href="$fn" target="_blank" rel="noopener noreferrer">$fn\</a>\</td>
                        HEAD
                        when $type eq 'no-file' {
                            $rv ~= '<td></td><td></td></tr>';
                            for $resp.list -> %info {
                                $rv ~= '<tr><td></td><td>' ~ %tml<escaped>( %info<link-label> )
                                    ~ '</td><td>'
                                    ~ %tml<escaped>(%info<file>)
                                    ~ "</td></tr>\n"
                            }
                        }
                        when $type eq 'unknown' {
                            $rv ~= '<td></td><td></td></tr>';
                            for $resp.list -> %info {
                                $rv ~= '<tr><td></td><td>' ~ %tml<escaped>( %info<link-label> )
                                    ~ '</td><td>'
                                    ~ %tml<escaped>(%info<url>)
                                    ~ '</td>'
                            }
                            $rv ~= "</tr>\n";
                        }
                        when $type eq 'remote' {
                            $rv ~= '<td></td><td></td><td></td></tr>';
                            for $resp.list -> %info {
                                $rv ~= '<tr><td></td><td>' ~ %tml<escaped>( %info<link-label> )
                                    ~ '</td><td>'
                                    ~ %tml<escaped>(%info<url> )
                                    ~ '</td><td>'
                                    ~ %info<resp>
                                    ~ "</td></tr>\n"
                            }
                        }
                        when $type eq 'no-target' {
                            $rv ~= '<td></td><td></td><td></td></tr>';
                            for $resp.list -> %info {
                                $rv ~= '<tr><td></td><td>' ~ %tml<escaped>( %info<link-label> )
                                    ~ '</td><td>'
                                    ~ '<a class="button" href="' ~ %tml<escaped>( %info<file> ) ~ '" target="_blank" rel="noopener noreferrer">'
                                    ~ %tml<escaped>(%info<file> )
                                    ~ "</a></td><td></td></tr>\n"
                                    ~ %info<targets>.map( {
                                        '<tr><td></td><td></td><td></td><td>'
                                        ~ %tml<escaped>( $_ )
                                        ~ "</td></tr>\n"
                                    } )
                            }
                        }
                    }
                }
                $rv ~= "</table>\n"
            }
        }
#        {
#            my $data = %prm<linkerrortest>;
#            # structure: no-file|no-target|unknown|remote
#            my %titles = <no-file no-target unknown remote >
#                    Z=> 'Links to missing files',
#                        'Links to non-existent interior targets',
#                        'Unknown target schema (typo in L<> ?)',
#                        'Remote http/s links with bad host or 404';
#            for <remote no-target unknown no-file> -> $type {
#                my %object = $data{$type};
#                next if (! %object.elems)
#                    or ( $type eq 'remote' and ! %object<no_test> and %object.elems eq 1 );
#                $rv ~= '<h2 class="raku-h2">' ~ %titles{$type} ~ "</h2>\n";
#                given $type {
#                    when 'remote' {
#                        if %object<no_test> {
#                            $rv ~= q:to/HEADER/ ~ "\n"
#                                    <div class="let-file header">
#                                    <div class="let-response header"><div>Remote link test skipped</div>
#                                    <div class="let-link-text header">LET plugin config file has 'no-remote' set</div>
#                                    </div></div>
#                                HEADER
#                        }
#                        else {
#                            $rv ~= q:to/HEADER/ ~ "\n"
#                                    <div class="let-file header">
#                                    <div>Document containing link<div class="let-clickable">Click for originating document in new tab</div></div>
#                                    <div class="let-link-text header">Originating link text</div>
#                                    <div class="let-links header">Dubious url
#                                    <div class="let-response header">Error response</div>
#                                    </div></div>
#                                HEADER
#                        }
#                    }
#                    when 'no-target' {
#                        $rv ~= q:to/HEADER/ ~ "\n"
#                                <div class="let-file header"><div>Document containing link<div class="let-clickable">Click for originating document in new tab</div></div>
#                                <div class="let-link-text header">Originating link text
#                                <div class="let-link-file header"><div>A document generates a web-page<div class="let-clickable">Click for destination document in new tab</div></div>
#                                <div class="let-link-target header">An internal target is referenced but does not exist (variants tried)</div>
#                                </div></div></div>
#                            HEADER
#                    }
#                    when 'no-file' {
#                        $rv ~= q:to/HEADER/ ~ "\n"
#                                <div class="let-file header"><div>Document containing link<div class="let-clickable">Click for originating document in new tab</div></div>
#                                <div class="let-link-text header">Originating link text
#                                <div class="let-link-file header">Non-Existent target file</div>
#                                </div></div>
#                            HEADER
#                    }
#                    default {
#                        $rv ~= q:to/HEADER/ ~ "\n"
#                                <div class="let-file header"><div>Document containing link<div class="let-clickable">Click for originating document in new tab</div></div>
#                                <div class="let-link-text header">Originating link text
#                                <div class="let-url header">Dubious url</div>
#                                </div></div>
#                            HEADER
#                    }
#                }
#                unless %object<no_test> {
#                    for %object.sort.grep( { .value ~~ Positional } ).map(|*.kv) -> $fn, $resp {
#                        $rv ~= '<div class="let-file"><div>' ~ $fn ~ '<a class="let-clickable" href="' ~ $fn ~ '" target="_blank" rel="noopener noreferrer">Clickable</a></div>';
#                        when $type eq 'no-file' {
#                            for $resp.list -> %info {
#                                $rv ~= '<div class="let-link-text">' ~ %tml<escaped>( %info<link-label> )
#                                    ~ '<div class="let-link-file">'
#                                    ~ %tml<escaped>(%info<file>)
#                                    ~ '</div></div>'
#                            }
#                            $rv ~= "</div>\n";
#                        }
#                        when $type eq 'unknown' {
#                            for $resp.list -> %info {
#                                $rv ~= '<div class="let-link-text">' ~ %tml<escaped>( %info<link-label> ) ~ '</div>'
#                                    ~ '<div class="let-links">'
#                                    ~ %tml<escaped>(%info<url>)
#                                    ~ '</div>'
#                            }
#                            $rv ~= "</div>\n";
#                        }
#                        when $type eq 'remote' {
#                            for $resp.list -> %info {
#                                $rv ~='<div class="let-link-text">' ~ %tml<escaped>( %info<link-label> ) ~ '</div>'
#                                    ~  '<div class="let-links">'
#                                    ~ %tml<escaped>( %info<url> )
#                                    ~ '<div class="let-response">'
#                                    ~ %info<resp>
#                                    ~ "</div></div>\n"
#                            }
#                            $rv ~= "</div>\n";
#                        }
#                        when $type eq 'no-target' {
#                            for $resp.list -> %info {
#                                $rv ~= '<div class="let-link-text">' ~ %tml<escaped>( %info<link-label> )
#                                    ~ '<div class="let-link-file"><div>'
#                                    ~ %tml<escaped>( %info<file> )
#                                    ~ '<a class="let-clickable" href="' ~ %tml<escaped>( %info<file> ) ~ '" target="_blank" rel="noopener noreferrer">Clickable</a></div>'
#                                    ~ %info<targets>.map( {
#                                        '<div class="let-link-target">'
#                                        ~ %tml<escaped>( $_ )
#                                        ~ '</div>'
#                                    } )
#                                    ~ "</div></div>\n"
#                            }
#                            $rv ~= "</div>\n";
#                        }
#                    }
#                }
#            }
#        }
        else {
            $rv = "<div><h2>Link Tests</h2>No errors detected</div>"
        }
        $rv
    },
)