use v6.d;
use Test;
use RakuConfig;
use License::SPDX;

module Test::Collection {
    # several subs are taken from Jonathan Stowe's Test::Meta module.
    our $TESTING = False;

    sub test-plugin() is export {
        my %config;
        my @required = <custom-raku template-raku version auth license authors>;

        plan 11;

        ok check-file('README.rakudoc'), 'README exists';
        if check-file('config.raku') {
            pass 'got ｢config.raku｣';
            lives-ok { %config = get-config(:@required) }, 'config exists with mandatory keys';
            ok check-license(%config), 'license confirmed';
            ok check-authors(%config), 'authors included';
            ok check-version(%config), 'plugin version acceptible';
            ok check-custom(%config), 'custom block is acceptible';
            ok check-templates(%config), 'template are returned';
            ok check-auth(%config), 'auth field looks fine';
            ok check-milestone(%config), 'milestone definition seems ok';
            ok check-otherkey(%config), 'other keys, if they exist, are consistent';
        }
        else
        {
            flunk 'no ｢config.raku｣';
            skip-rest 'no config file'
        }
        done-testing
    }

    sub my-diag(Str $mess) {
        diag $mess unless $TESTING;
    }

    our sub check-authors(%config --> Bool) {
        my Bool $rc = True;
        if %config<authors>.elems == 0 {
            $rc = False;
            my-diag "No authors are listed, there shoule be at least one.";
        }
        $rc;
    }

    our sub check-license(%config --> Bool) {
        my Bool $rc = True;
        if %config<license>:exists {
            my $licence-list = License::SPDX.new;
            my $licence = $licence-list.get-license(%config<license>);
            if !$licence.defined {
                if %config<license> eq any('NOASSERTION', 'NONE') {
                    my-diag "NOTICE! License is %config<license>. This is valid, but licenses are prefered.";
                    $rc = True;
                }
                else {
                    my-diag qq:to/END/;
                    license ‘%config<license>’ is not one of the standardized SPDX license identifiers.
                    please use use one of the identifiers from https://spdx.org/licenses/
                    END

                    $rc = False;
                }
            }
            elsif $licence.is-deprecated-license {
                my-diag qq:to/END/;
                the licence ‘%config<license>()’ is valid but deprecated, you may want to use another license.
                END

            }
        }
        $rc;
    }
    our sub check-version(%config --> Bool) {
        my Bool $rc = True;
        unless %config<version> ~~ / ^ \d+ \. \d+ \. \d+ $ / {
            $rc = False;
            my-diag 'version must be in three parts dd.dd.dd but got '
                ~ %config<version>
        }
        $rc
    }
    our sub check-custom(%config --> Bool) {
        my Bool $rc = True;
        if %config<custom-blocks> ~~ Str:D {
            if %config<custom-blocks>.IO ~~ :e & :f {
                my $retval;
                try {
                    $retval = EVALFILE %config<custom-blocks>;
                    CATCH {
                        default {
                            my-diag(.message);
                            $rc = False
                        }
                    }
                    unless $retval ~~ Array:D {
                        my-diag("{ %config<custom-blocks> } should return an Array. Instead got ｢$retval｣.");
                        $rc = False;
                    }
                }
            }
        }
        elsif %config<custom-blocks> !~~ Empty {
            my-diag("｢custom-blocks｣ key may only be () or a string. Instead got ｢{ %config<custom-blocks> }｣.");
            $rc = False
        }
        $rc
    }
    our sub check-templates(%config --> Bool) {
        my Bool $rc = True;
        dd %config;
        if %config<template-raku> ~~ Str:D {
            if %config<template-raku>.IO ~~ :e & :f {
                my $retval;
                try {
                    $retval = EVALFILE %config<templates>;
                    CATCH {
                        default {
                            my-diag(.message);
                            $rc = False
                        }
                    }
                    unless $retval ~~ Hash:D {
                        my-diag("{ %config<template-raku> } should return a Hash. Instead got ｢$retval｣.");
                        $rc = False;
                    }
                }
            }
        }
        elsif %config<templates> !~~ Empty {
            my-diag("key ｢template-raku｣ may only be () or a string. Instead got ｢{ %config<template-raku> }｣.");
            $rc = False
        }
        $rc
    }
    our sub check-auth(%config --> Bool) {
        my Bool $rc = True;
        unless %config<template> ~~ Str:D {
            my-diag("The template key of the config must be a String");
            $rc = False
        }
        $rc
    }
    our sub check-milestone(%config --> Bool) {
        my Bool $rc = True;
        # the valid milestones are:
        # setup must return a callable
        # render may exist as a Boolean, if has a filename then must return a callable
        # compilation must return a callable
        # transfer must return a callable
        # report must return a callable
        # completion must return a callable
        my @required = <setup render compilation transfer report completion>;
        # at least one must exist
        unless any(%config.keys) ~~ any(@required) {
            $rc = False;
            my-diag("The config file must contain one of the keys ｢{ @required.join('｣,｢') }｣")
        }
        for %config.keys.grep(any(@required)) {
            next if (.match('render') and (%config<render> ~~ Bool));
            # all the other milestone keys must have strings that evaluate to callables
            if .match(Str:D) {
                if .IO ~~ :e & :f {
                    my $call;
                    try {
                        $call = EVALFILE %config($_);
                        CATCH {
                            default {
                                my-diag(.message);
                                $rc = False
                            }
                        }
                    }
                    unless $call ~~ Callable {
                        my-diag("key ｢$_｣ is ｢%config($_)｣ does not evaluate to a callable");
                        $rc = False
                    }
                }
                else
                {
                    my-diag("key ｢$_｣ is ｢%config($_)｣, which is not a file in the directory");
                    $rc = False
                }
            }
            else
            {
                my-diag("key ｢$_｣ is ｢%config($_)｣, which is not a Str:D");
                $rc = False;
            }
        }
        $rc
    }
    our sub check-otherkey(%config --> Bool) {
        my Bool $rc = True;
        my @specified = <setup render compilation transfer report completion
            version auth authors license custom-raku template-raku>;
        for %config.keys.grep(none(@specified)) {
            $rc &= check-file(%config($_), :extra("(in key ｢$_｣)"))
        }
        $rc
    }
    our sub check-file($fn, :$extra = '' --> Bool) {
        return True if ($fn.IO ~~ :e & :f);
        my-diag("a file called ｢$fn｣ { $extra ?? "($extra) " !! '' }is expected in the directory");
        return False
    }
}
