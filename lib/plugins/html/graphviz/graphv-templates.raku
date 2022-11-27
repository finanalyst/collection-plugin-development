#!/usr/bin/env raku
use v6.d;
%(
    graphviz => sub (%prm, %tml) {
        # check that dot executes
        my $proc = shell 'command -v dot', :out;
        unless $proc.out.slurp(:close) { # if dot does not exist, then no output
                return "\n"~'<div class="graphviz"><div style="color: red">The program ｢dot｣ fom Graphviz needs installing to get an image</div></div>'
        }
        #remove <p> and </p>
        my $data = %prm<contents>.subst(/^\<p\>/, '');
        $data .=subst(/\<\/p\> \s* $/, '');
        # de-escape data
        $data .= trans(qw｢ &lt; &gt; &amp; &quot; ｣ => qw｢ <    >    &     " ｣);
        $proc = Proc::Async.new(:w, 'dot', '-Tsvg');
        my $proc-rv;
        my $proc-err;
        $proc.stdout.tap(-> $d { $proc-rv ~= $d });
        $proc.stderr.tap(-> $v { $proc-err ~= $v });
        my $promise = $proc.start;
        $proc.put($data);
        $proc.close-stdin;
        try {
            await $promise;
            CATCH {
                default {}
            }
        }
        my $rv = "\n"~'<div class="graphviz">';
        if $proc-rv { $rv ~= $proc-rv }
        elsif $proc-err {
           $rv ~= '<div style="color: red">'
            ~ $proc-err.subst(/^ .+? 'tdin>:' \s*/, '') ~ '</div>'
            ~ '<div>Graph input was <div style="color: green">' ~ $data ~ '</div></div>'
        }
        $rv ~= '</div>'
    }
);