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

multi sub prepare(Str:D :$repo = "$*HOME/.local/lib/Collection",
            Str:D :$origin = "lib"
            ) is export {
    (exit note("｢$repo｣ does not exist. Create git repo directory and point at Collection-plugins"))
    unless $repo.IO ~~ :e & :d;
    (exit note("｢$origin/plugins｣ does not exist."))
    unless "$origin/plugins".IO ~~ :e & :d;
    mktree("$repo/plugins") unless "$repo/plugins".IO ~~ :e & :d;
    my $count;
    for  "$origin/plugins".IO.dir {
        next unless .IO.d;
        ++$count;
        my $format = .basename;
        my %plugins = map-to-repo(:repo("$repo/plugins"), :origin("$origin/plugins"), :$format);
    }
    prepare(:$repo, :rebuild );
    say "$count plugins prepared";
}
multi sub prepare(Str:D :$repo = "$*HOME/.local/lib/Collection",
            Bool :rebuild($)!
            ) is export {
    (exit note("｢$repo｣ does not exist. Create git repo directory and point at Collection-plugins"))
    unless $repo.IO ~~ :e & :d;
    my %manifest;
    for $repo.IO.dir -> $type {
        next unless $type ~~ :d;
        for $type.dir -> $format {
            next unless $format ~~ :d;
            for $format.dir -> $plug {
                next unless $plug ~~ :d;
                my %config = get-config( $plug.relative );
                %manifest{ $type.basename }{ $format.basename }{ $plug.basename }
                    = %config<version>
            }
        }
    }
    "$repo/manifest.rakuon".IO.spurt: format-config( %manifest );
    say "Rebuilt ｢$repo/manifest.rakuon｣."
}

sub map-to-repo(
    Str:D :$repo!,
    Str:D :$origin!,
    Str:D :$format!
    --> Associative
                ) is export {
    my $from = "$origin/$format";
    (exit note("｢$from｣ must exist with plugins")) unless $from.IO ~~ :e & :d;
    my $to-r = "$repo/$format";
    mktree($to-r) unless $to-r.IO ~~ :e & :d;
    my %plugins;
    for $from.IO.dir -> $node {
        my $plug = $node.basename;
        my %config = get-config($node.Str);
        my $release = "{ $plug }_v{ %config<version>.split('.')[0] }_auth_{ %config<auth> }";
        my $to = "$to-r/$release";
        print "From ｢$plug｣ to release ｢$release｣.";
        if $to.IO ~~ :e & :d {
            print " Release exists.";
            my %rel-config = get-config(:path("$to/config.raku"));
            if %config<version> eq %rel-config<version> {
                print " Same version ｢{ %config<version> }｣.";
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
        %plugins{$release} = %config<version>;
    }
    %plugins
}
sub copy-plugin(IO :$node!, Str:D :$to!) is export {
    $to.IO.mkdir unless $to.IO ~~ :e & :d;
    for $node.dir {
        if $_ ~~ :d {
            copy-plugin(:node($_), :to($to ~ '/' ~ $_.basename))
        }
        else {
            $_.copy($to ~ '/' ~ $_.basename)
        }
    }
}
sub compare-modified(Str:D $from, Str:D $to--> Positional) {
    my @problems;
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