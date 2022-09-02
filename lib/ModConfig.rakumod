#!/usr/bin/env raku
use v6.d;
use PrettyDump;
unit module ModConfig;
no precompilation;

our %defaults is export(:MANDATORY) = %(
    :version<0.1.0>,
    :auth<finanalyst>,
    :authors('finanalyst',),
    :license('Artistic-2.0'),
);

multi sub MAIN(
    Bool :$defaults = False,
    Str:D :$plugin = '',
    Str:D :v(:$version) = '',
    Str:D :$auth = '',
    Str:D :$authors = '',
    Str:D :$license = '',
    Str:D :$path = '.',
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
        @plugins = ("$path/$plugin",)
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
    for @plugins {
        say "Trying plugin ｢$_｣." unless $quiet;
        my Bool $conf-present = "$_/config.raku".IO ~~ :e & :f;
        unless $conf-present {
            my $resp = '';
            note "plugin directory ｢$_｣ does not contain a config.raku file";
            prompt "(C)ontinue / something else to Exit" unless $quiet;
            exit(1) unless $resp ~~ /:i $ 'C' /;
            next
        }
        my %plug-conf = EVALFILE "$_/config.raku";
        %plug-conf ,= %conf;
        my $new-conf = format-config(%plug-conf);
        my $write = True;
        unless $quiet {
            say "New value of config.raku is \n$new-conf";
            my $resp = prompt "Is the new config correct (/n). \nIf 'N' or 'n', the plugin will not be changed.";
            $write = ?($resp !~~ /:i 'n' /)
        }
        "$_/config.raku".IO.spurt($new-conf) if $write
    }
}
multi sub MAIN(:show-default($)!) is export {
    say format-config(%defaults);
}
multi sub MAIN(|c) is export {
    print qq:to/USAGE/;
    The program ｢{ $*PROGRAM-NAME }｣
    - assumes that the current working directory has sub-directories named for plugins,
        unless -path=<route from current directory to plugin directories>
    - Either requires
        - -plugin='all' or -plugin=<name of a sub-directory>.
        and
        - -defaults or one of -version, -auth, -authors, -lisence
    - Or -show-defaults
    The options -defaults and -show-defaults are booleans by default False, so use them only
    when needed.
    The options -plugin, -auth, -lisence expect non-empty Strings.
    The option -version expects a Str in the form <Major>.<Minor>.<Patch>, where these are all integers.
    The option -authors expects a comma separated list of names, eg.
        -authors='Arthur Conan-Doyle, Ernest Hemingway, J.R. Tolkien'
    ｢{ $*PROGRAM-NAME }｣ will prompt with the new config.raku before it is re-written.
        -quiet, if present, will suppress prompts before config.raku is rewritten
    USAGE

}

#| format a config file for writing. Should be in RakuConfig
multi sub format-config(%d, :$level = 1 --> Str) is export(:MANDATORY) {
    my @r-lines;
    for %d.sort.map(|*.kv) -> $key, $val {
        given $val {
            when Bool {
                @r-lines.append: "\t" x $level ~ ":$key,"
            }
            when Associative {
                @r-lines.append: "\t" x $level ~ ":$key\%(\n" ~ format-config($val, :level($level + 1))
                    ~ "\n" ~ "\t" x $level ~ "),";
            }
            when Str:D {
                @r-lines.append: "\t" x $level ~ ":$key\<$val>,"
            }
            when Num {
                @r-lines.append: "\t" x $level ~ ":$key\($val),"
            }
            when Positional {
                if .elems {
                    @r-lines.append:
                        "\t" x $level
                            ~ ":$key\("
                            ~ format-config($val, :level($level + 1))
                            ~ "\n" ~ "\t" x $level ~ "),"
                }
                else {
                    @r-lines.append: "\t" x $level ~ ":$key\(),"
                }
            }
            default {
                @r-lines.append: "\t" x $level ~ ":$key\(''),"
            }
        }
    }
    return @r-lines if $level > 1;
    "%\(\n" ~ @r-lines.join("\n") ~ "\n)"
}
multi sub format-config(@a, :$level --> Str) is export(:MANDATORY) {
    @a.map({ "\n" ~ "\t" x $level ~ "\"$_\"," }).join
}