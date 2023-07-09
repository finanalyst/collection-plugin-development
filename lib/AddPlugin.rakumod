#!/usr/bin/env perl6
use RakuConfig;
use Collection::Entities;

unit module Collection::AddPlugin;
multi sub MAIN(Str:D $plug, :$mile = 'render', :$format = 'html', Bool :$test = False) is export {
    my $path = $test ?? $format !! "lib/plugins/$format";
    exit note("A plugin called ｢$plug｣ already exists for format ｢$format｣. Try a new name")
    if $plug ~~ any($path.IO.dir>>.basename);
    exit note("Plugin name ｢$plug｣ does not match Collection plugin naming rules")
        unless $plug ~~ / ^ <plugin-name> $ /;
    my $p-path = "$path/$plug";
    $p-path.IO.mkdir;
    "$p-path/README.rakudoc".IO.spurt(qq:to/TEMP/);
            \=begin pod
            \=TITLE {$plug.tc} is a Collection plugin

            The plugin is for the $mile milestone

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

    my %config = %collection-defaults;
    %config<name> = $plug;
    for $mile.comb(/ <plugin-name> /) {
        %config{$_} = "$_\-callable.raku" unless $_ eq 'render';
        when 'render' {
            %config ,= %(
                :render,
                :template-raku(),
                :custom-raku(),
            );
        }
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
    "$p-path/config.raku".IO.spurt(format-config(%config));
    say "Successfully created: ｢$plug｣ in ｢$path｣" unless $test
}
