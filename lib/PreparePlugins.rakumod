use v6.d;
use RakuConfig;
use File::Directory::Tree;
use Test::CollectionPlugin :MANDATORY;

unit module RefreshPlugins;

class BadPlugin is Exception {
    has $.plugin;
    method message {
        "$.plugin must be a directory, but is { $!plugin.raku }"
    }
}

sub map-to-repo(Str:D :$repo = "../raku-collection-plugins",
                Str:D :$origin = "lib",
                Str:D :$format = 'html'
                ) is export {
    my $from = "$origin/plugins/$format";
    for $from.IO.dir -> $node {
        my $plug = $node.basename;
        my %config = get-config(:path("$node/config.raku"));
        my $release = "{ $plug }_v{ %config<version>.split('.')[0] }_auth_{ %config<auth> }";
        my $to = "$repo/plugins/$format/$release";
        print "From ｢$plug｣ to release ｢$release｣.";
        if $to.IO ~~ :e & :d {
            print " Release exists.";
            my %rel-config = get-config(:path("$to/config.raku"));
            if %config<version> eq %rel-config<version> {
                print " Same version ｢{%config<version>}｣.";
                my @problems = compare-modified(~$node, $to).flat;
                if @problems {
                    say " Changes in ｢$plug｣ after ｢$release｣.\n\t",
                        @problems.join(",\n\t"),
                        "\n\tBump the version and run ｢prepare-plugins｣ again.";
                    next
                }
                else {
                    say " No change."
                }
            }
            else {
                say " Different versions, copying plugin.";
            }
        }
        else {
            say " Transferring to new release";
        }
        copy-plugin(:$node, :$to);
    }
}
sub copy-plugin(IO :$node!, Str:D :$to!) is export {
    $to.IO.mkdir unless $to.IO ~~ :e & :d;
    for $node.dir {
        if $_ ~~ :d {
            copy-plugin(:node($_), :to($to ~ '/' ~ $_.basename))
        }
        else {
            $_.copy( $to ~ '/' ~ $_.basename)
        }
    }
}
sub compare-modified(Str:D $from, Str:D $to--> Positional) {
    my @problems =();
    for "$from".IO.dir -> $node {
        my $fn = $node.basename;
        if "$to/$fn".IO ~ :e {
            @problems.append: compare-modified(~$node, "$to/$fn").flat
                if $node ~~ :d;
            if $node.modified > "$to/$fn".IO.modified {
                @problems.append: "｢$fn｣ was modified in ｢$from｣ after its copy in ｢$to｣"
            }
        }
        else {
            @problems.append: ($node ~~ :f ?? "File" !! "Directory") ~ " ｢$fn｣ in ｢$from｣ does not exist in ｢$to｣"
        }
    }
    @problems
}