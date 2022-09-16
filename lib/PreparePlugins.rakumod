use v6.d;
use RakuConfig;
use File::Directory::Tree;
use Test::CollectionPlugin :MANDATORY;
use Terminal::ANSIColor;

unit module RefreshPlugins;

class BadPlugin is Exception {
    has $.plugin;
    method message {
        "$.plugin must be a directory, but is { $!plugin.raku }"
    }
}

multi sub prepare(Str:D :$repo = "$*HOME/.local/share/Collection",
            Str:D :$origin = "lib"
            ) is export {
    (exit note("｢$repo｣ does not exist. Create git repo directory and point at Collection-plugins"))
    unless $repo.IO ~~ :e & :d;
    (exit note("｢$origin/plugins｣ does not exist."))
    unless "$origin/plugins".IO ~~ :e & :d;
    mktree("$repo/plugins") unless "$repo/plugins".IO ~~ :e & :d;
    for  "$origin/plugins".IO.dir {
        next unless .IO.d;
        my $format = .basename;
        map-to-repo(:repo("$repo/plugins"), :origin("$origin/plugins"), :$format);
    }
    prepare(:$repo, :rebuild );
}
multi sub prepare(Str:D :$repo = "$*HOME/.local/share/Collection",
            Bool :rebuild($)!
            ) is export {
    (exit note("｢$repo｣ does not exist. Create git repo directory and point at Collection-plugins"))
    unless $repo.IO ~~ :e & :d;
    my %manifest;
    for $repo.IO.dir -> $type {
        next unless $type ~~ :d and $type.basename ~~ / ^ \w /;
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
                ) is export {
    my $from = "$origin/$format";
    (exit note("｢$from｣ must exist with plugins")) unless $from.IO ~~ :e & :d;
    my $to-r = "$repo/$format";
    mktree($to-r) unless $to-r.IO ~~ :e & :d;
    my $count = 0;
    for $from.IO.dir -> $node {
        $count++;
        my $plug = $node.basename;
        my %config = get-config($node.Str);
        my $release = "{ $plug }_v{ %config<version>.split('.')[0] }_auth_{ %config<auth> }";
        my $to = "$to-r/$release";
        print 'From ｢', color('blue'), $plug, color('reset'), '｣ to release ｢', color('green'), $release, color('reset'), '｣.';
        if $to.IO ~~ :e & :d {
            print " Release exists.";
            my %rel-config = get-config(:path("$to/config.raku"));
            if %config<version> eq %rel-config<version> {
                print " Same version ｢{ %config<version> }｣.";
                my @problems = compare-modified(~$node, $to).flat;
                if @problems {
                    say "\n\t",color('red'), BOLD, 'Changes ', BOLD_OFF, color('reset'), 'in ｢', $plug, '｣ after ｢',$release,"｣.\n\t",
                        @problems.join(",\n\t"),
                        "\n\t",color('red'), BOLD, 'Bump ', BOLD_OFF, color('reset'), 'the version and run ', color('green'), $*PROGRAM-NAME, color('reset'), ' again.';
                    next
                }
                else {
                    say BOLD, ' No change.', BOLD_OFF
                }
            }
            else {
                say ' Different versions, ', color('red'), 'copying plugin.', color('reset');
            }
        }
        else {
            say color('red'), ' Transferring', color('reset'), ' to new release';
        }
        copy-plugin(:$node, :$to);
    }
    say "Processed $count plugins";
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
                @problems.append: "｢$fn｣ was modified in ｢$from｣ after its release."
            }
        }
        else {
            @problems.append: ($node ~~ :f ?? "File" !! "Directory") ~ " ｢$fn｣ in ｢$from｣ does not exist in release"
        }
    }
    @problems
}