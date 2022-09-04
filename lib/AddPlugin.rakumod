#!/usr/bin/env perl6
use RakuConfig;
use Collection::ModConfig :CALLABLE;

unit module Collection::AddPlugin;
multi sub MAIN(Str:D $plug, :$mile = 'render', :$format = 'html', Bool :$test = False) is export {
    my $path = $test?? $format !! "lib/$format/plugins";
    exit note("A plugin called ｢$plug｣ already exists for format ｢$format｣. Try a new name")
        if $plug ~~ any( $path.IO.dir>>.basename );
    my $p-path = "$path/$plug";
    $p-path.IO.mkdir;
    "$p-path/README.rakudoc".IO.spurt(qq:to/TEMP/);
            \=begin pod
            \=TITLE $plug is a plugin for Collection

            The plugin is for the $mile milestone

            \=head1 Custom blocks

            \=head1 Templates

            \=end pod
            TEMP
    "$p-path/t".IO.mkdir;
    "$p-path/t/05-basic.rakutest".IO.spurt(q:to/TEST/);
        use v6.d;
        use Test;
        use Test::CollectionPlugin;
        test-plugin();
        done-testing
        TEST
    if $mile eq 'render' {
        "$p-path/config.raku".IO.spurt(q:to/TEMP/);
            %(
                :render,
                :template-raku(),
                :custom-raku(),
            )
            TEMP
    }
    else {
        "$p-path/config.raku".IO.spurt(qq:to/TEMP/);
            %(
                :{ $mile }<{$mile}-callable.raku>,
            )
            TEMP
    }
    modify-config( :plugin($plug), :path($path), :defaults, :quiet);
    given $mile {
        when 'setup' {
            "$p-path/$_\-callable.raku".IO.spurt(q:to/TEMP/);
            use v6.d;
            sub ( $source-cache, $mode-cache, Bool $full-render,  $source-root, $mode-root, %options ) {
                # return nothing
            }
            TEMP
        }
        when 'compilation' {
            "$p-path/$_\-callable.raku".IO.spurt(q:to/TEMP/);
            use v6.d;
            sub ( $pr, %processed, %options) {
                # return nothing
            }
            TEMP
        }
        when 'transfer' {
            "$p-path/$_\-callable.raku".IO.spurt(q:to/TEMP/);
            use v6.d;
            sub ($pr, %processed, %options --> Array ) {
                # return array of triplets
                []
            }
            TEMP
        }
        when 'report' {
            "$p-path/$_\-callable.raku".IO.spurt(q:to/TEMP/);
            use v6.d;
            sub (%processed, @plugins-used, $pr, %options --> Array ) {
                # return array of triplets
                []
            }
            TEMP
        }
        when 'completion' {
            "$p-path/$_\-callable.raku".IO.spurt(q:to/TEMP/);
            use v6.d;
            sub ($destination, $landing-place, $output-ext, %completion-options, %options) {
                # return nothing
            }
            TEMP
        }
    }
}