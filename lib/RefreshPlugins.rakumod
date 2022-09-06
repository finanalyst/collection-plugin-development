use v6.d;
use RakuConfig;
use File::Directory::Tree;
use Test::CollectionPlugin :MANDATORY;

unit module RefreshPlugins;

multi sub refresh {
    # test whether there is a config.raku in the current directory
    my %config;
    try {
        %config = get-config;
        CATCH {
            default {
                exit note("Trying to access ｢config.raku｣ in ｢$*CWD｣ but got " ~ .message)
            }
        }
    }
    # so there is a config.raku file. Now is there a plugins.conf file
    my %plugins;
    try {
        %plugins = get-config(:path<plugins.conf>);
        CATCH {
            when RakuConfig::NoFiles {
                note("Creating ｢plugins.conf｣ in ｢$*CWD｣");
                %plugins = make-plugin-conf;
                .resume
            }
            default {
                exit note("Trying to access ｢plugins.conf｣ in ｢$*CWD｣ but got " ~ .message)
            }
        }
    }

}
sub make-plugin-conf(--> Associative) {
    my %pc;
    # create plugins conf from each of the sub-directories, which are Mode directories
    my @modes = dir>>.Str;
    for @modes -> $mode {
        my %config;
        try {
            %config = get-config(:path<<$mode/configs>>, :required<plugins plugin-format plugins-required>);
            CATCH {
                default { exit note("Trying to access Mode ｢$mode/configs｣, but got " ~ .message) }
            }
        }
    }
}
sub map-to-repo(Str:D :$repo = "../raku-collection-plugins",
                Str:D :$origin = "lib",
                Str:D :$format = 'html'
                ) is export {
    for "$origin/plugins/$format".IO.dir {
        my $plug = .basename;
        my %config = get-config(:path("$_/config.raku"));
        my $release = "{ $plug }_v{ %config<version>.split('.')[0] }_auth_{ %config<auth> }";
        say "Transfering / refreshing plugin ｢$plug｣ to ｢$release｣.";
        if "$repo/plugins/$format/$release".IO ~~ :e & :d {
            say "\tRelease ｢$plug｣ exists.";
            my %rel-config = get-config(:path("$repo/plugins/$format/$release/config.raku"));
            say("\tSkipping copy because ｢$plug｣ and ｢$release｣ both have version number {%config<version>}.")
                and next
                if %config<version> eq %rel-config<version>;
        }
        copy-plugin(:from("$origin/plugins/$format/$plug"), :to("$repo/plugins/$format/$release"));
    }
}
sub copy-plugin(Str:D :$from!, Str:D :$to!) is export {
    $to.IO.mkdir unless $to.IO ~~ :e & :d;
    for $from.IO.dir {
        if $_ ~~ :d {
            copy-plugin(:from(~$_), :to($to ~ '/' ~ $_.basename))
        }
        else {
            $_.copy( $to ~ '/' ~ $_.basename)
        }
    }
}