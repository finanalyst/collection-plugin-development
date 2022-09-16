#!/usr/bin/env raku
use v6.d;
use RakuConfig;
use Test::CollectionPlugin :MANDATORY;
unit module Collection::ModConfig;

our %defaults is export(:MANDATORY) = %(
    :version<0.1.0>,
    :auth<collection>,
    :authors('finanalyst',),
    :license('Artistic-2.0'),
);
sub modify-config(|c) is export(:CALLABLE) {
    MAIN(|c)
}

multi sub MAIN(
    Bool :default(:$defaults) = False,
    Str:D :plugins(:$plugin) = '',
    Str:D :v(:$version) = '',
    Str:D :$auth = '',
    Str:D :$authors = '',
    Str:D :$license = '',
    Str:D :$path = 'lib/plugins/html',
    Bool :$quiet = False
   ) is export {
    (exit note("｢$path｣ is not a valid path")) unless $path.IO ~~ :e & :d;
    my Bool $min-conditions = ?((($plugin ~~ Str:D and $plugin) or $plugin ~~ 'all')
        and ($defaults or any($version, $auth, $license, $authors)));
    (exit note(qq:to/MIN/)) unless $min-conditions;
        Something is Wrong.
        Try ｢{ $*PROGRAM-NAME } -help｣, or ｢{ $*PROGRAM-NAME } -show-defaults｣
        -path (default CWD) should be valid and have subdirectories for plugins
        -quiet, if present, will suppress info and prompts before config.raku is rewritten
        A minimum set of operating call parameters for ｢{ $*PROGRAM-NAME }｣ is
            (1) -plugin=<name of modified plugin> OR 'all'
            and
            (2) -default OR one of '-version', '-auth', '-authors', '-license' set to a string
        MIN

    my @plugins;
    if $plugin eq 'all' {
        @plugins = $path.IO.dir.grep({ .d });
        (exit note("There are no potential plugin sub-directories in ｢$path｣")) unless @plugins;
    }
    else {
        (exit note("The plugin sub-directory ｢$path/$plugin｣ is not valid"))
        unless "$path/$plugin".IO ~~ :e & :d;
        @plugins = ("$path/$plugin".IO,)
    }
    my %conf;
    if $defaults {
        %conf = %defaults
    }
    else {
        my @authors;
        %conf<auth> = $auth if $auth;
        %conf<license> = $license if $license;
        if $authors {
            @authors = $authors.split(/ \, /);
            (exit note("Something wrong with authors list ｢$authors｣, no author is parsed"))
            unless @authors;
            %conf<authors> = @authors
        }
        if $version {
            (exit note("Something wrong with version ｢$version｣, it should have form " ~ '/\d+ \. \d+ \. \d+/'))
                unless $version ~~ /^ \d+ \. \d+ \. \d+ $/;
            %conf<version> = $version
        }
    }
    my $prompt = $quiet;
    for @plugins {
        say "Trying plugin ｢$_｣." unless $quiet;
        my %plug-conf = get-config( .Str );
        %plug-conf<name> = .basename unless %plug-conf<name>:exists;
        %plug-conf ,= %conf; # keys in %conf over-write those in %plug-conf
        my $new-conf = format-config(%plug-conf);
        my $write = True;
        unless $prompt {
            say "New value of config.raku is \n$new-conf";
            my $resp = prompt q:to/PROMPT/;
                Is the new config correct (/n/q).
                If 'n', the plugin will not be changed.
                If 'q', remaining plugins written without prompt.
                PROMPT
            $write = ?($resp !~~ /:i 'n' /);
            $prompt = True if $resp ~~ /:i 'q' /
        }
        "$_/config.raku".IO.spurt($new-conf) if $write
    }
}
multi sub MAIN(:show-default(:show-defaults($))!) is export {
    say format-config(%defaults);
}
multi sub MAIN(Bool :$bump!, Str:D :plugins(:$plugin) = '', Str:D :$path = '.',
    Bool :$quiet = False ) {
    my %config = get-config(:path("$path/$plugin/config.raku"));
    my @v = %config<version>.split(/'.'/);
    @v[2]++;
    %config<version> = @v.join('.');
    my $new-conf = format-config(%config);
    my $write = True;
    unless $quiet {
        say "New value of config.raku is \n$new-conf";
        my $resp = prompt "Is the new config correct (/n). \nIf 'N' or 'n', the plugin will not be changed.";
        $write = ?($resp !~~ /:i 'n' /)
    }
    "$path/$plugin/config.raku".IO.spurt($new-conf) if $write
}
multi sub MAIN(|c) is export {
    say qq:to/USAGE/;
    The program ｢{ $*PROGRAM-NAME }｣
    - assumes that the current working directory has sub-directories named for plugins,
        unless -path=<route from current directory to plugin directories>
    - Has two main option combinations variants:
        (a)
        -plugin=<name of a sub-directory> [-path=...]
        and
        (a1) -defaults
        or
        (a2) -bump
        or
        (a3) -version | -auth | -authors | -license

    Or (b) -show-defaults

    The options -plugin, -auth, -license expect non-empty Strings.
    The option -version expects a Str in the form <Major>.<Minor>.<Patch>, where these are all integers.
    The option -authors expects a comma separated list of names, eg.
        -authors='Arthur Conan-Doyle, Ernest Hemingway, J.R. Tolkien'
    The option -bump will increase the <patch> part of the version string for the plugin
    ｢{ $*PROGRAM-NAME }｣ will prompt with the new config.raku before it is re-written.
        -quiet, if present, will suppress prompts before config.raku is rewritten
    USAGE
}
