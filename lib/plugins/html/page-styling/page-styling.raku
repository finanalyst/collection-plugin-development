#!/usr/bin/env raku
use v6.d;
%(
    'source-wrap' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <!DOCTYPE html>
        <html lang="{ %prm<config><lang> }"
            class="fontawesome-i2svg-active fontawesome-i2svg-complete">
        { %tml<head-block>.(%prm, %tml) }
        <body class="has-navbar-fixed-top">
        { %tml<top-of-page>.(%prm, %tml) }
        { %tml<navigation>.(%prm, %tml)  }
        { %tml<wrapper>.(%prm, %tml)  }
        { %tml<footer>.(%prm, %tml)  }
        { %tml<js-bottom>.({}, {}) }
        </body>
        </html>
        BLOCK
    },
    'head-block' => sub (%prm, %tml) {
        qq:to/HEADBLOCK/
            <head>
                <title>{ %tml<escaped>.(%prm<title>) } | Raku Documentation\</title>
                <meta charset="UTF-8" />
                { %tml<favicon>.({}, {}) }
                { %prm<metadata> // '' }
                { %tml<css>.({}, {}) }
                { %tml<jq-lib>.({}, {}) }
                { %tml<js>.({}, {}) }
            </head>
            HEADBLOCK
    },
    'navigation' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <nav class="navbar is-fixed-top" role="navigation" aria-label="main navigation">
        { %tml<left-bar-toggle>.( %prm, %tml) }
        { %tml<head-brand>.( %prm, %tml) }
        { %tml<head-topbar>.( %prm, %tml) }
        { %tml<right-bar-toggle>.( %prm, %tml) }
        </nav>
        BLOCK
    },
    'left-bar-toggle' => sub (%prm, %tml ) {
      q:to/BLOCK/
        <div id="navbar-left-toggle" class="has-tooltip-bottom navbar-start" title="Toggle Table of Contents">
          <a class="navbar-item navbar-filter-settings navbar-sidebar-btn">
          <div>
            <span class="icon-text filter">
                <span class="icon " aria-hidden="true">
                <i class="fas fa-cogs"></i>
                </span>
                <span class="sidebar-title">Contents</span>
            </span>
          </div>
          <div class="sidebar-arrow">
              <span class="icon " aria-hidden="true">
                <i class="fas fa-chevron-right"></i>
              </span>
          </div>
        </a>
      </div>
      BLOCK
    },
    'right-bar-toggle' => sub (%prm, %tml ) {
      q:to/BLOCK/
        <div id="navbar-right-toggle" class="navbar-end has-tooltip-bottom is-hidden-touch" title="Toggle search sidebar">
            <a class="navbar-item navbar-channels navbar-sidebar-btn">
            <div class="sidebar-arrow">
                <span class="icon " aria-hidden="true">
                <i class="fas fa-chevron-left"></i>
                </span>
            </div>
            <div>
                <span class="icon-text">
                <span class="icon " aria-hidden="true">
                <i class="fas fa-cogs"></i>
                </span>
                <span class="sidebar-title">Search</span>
                </span>
            </div>
            </a>
        </div>
      BLOCK
    },
    'head-brand' => sub (%prm, %tml ) {
        q:to/BLOCK/
        <div class="navbar-brand navbar-logo">
          <div class="navbar-logo">
            <a class="navbar-item" href="/">
              <img src="/assets/images/camelia-recoloured.png" alt="Raku" width="52.83" height="38">
            </a>
            <div class="navbar-logo-tm">tm</div>
          </div>
          <a role="button" class="navbar-burger burger" aria-label="menu" aria-expanded="false" data-target="navMenu">
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
          </a>
        </div>
        BLOCK
    },
    'head-topbar' => sub ( %prm, %tml ) {
        q:to/BLOCK/
          <div id="navMenu" class="navbar-menu">
            <div class="navbar-start">
                <a class="navbar-item" href="/language">
                    Language
                </a>
                <a class="navbar-item" href="/types">
                    Types
                </a>
                <a class="navbar-item" href="/routines">
                    Routines
                </a>
                <a class="navbar-item" href="/programs">
                    Programs
                </a>
                <a class="navbar-item" href="https://raku.org">
                    Raku™ Homepage
                </a>
                <a class="navbar-item" href="https://kiwiirc.com/client/irc.libera.chat/#raku">
                    Chat with us
                </a>
                <div class="navbar-item has-dropdown is-hoverable">
                  <a class="navbar-link">
                    More
                  </a>
                  <div class="navbar-dropdown">
                    <hr class="navbar-divider">
                    <a class="navbar-item" href="/about">
                      About
                    </a>
                    <hr class="navbar-divider">
                    <a class="navbar-item has-text-red" href="https://github.com/raku/doc-website/issues">
                      Report an issue with this site
                    </a>
                    <hr class="navbar-divider">
                    <a class="navbar-item has-text-red" href="https://github.com/raku/doc/issues">
                      Report an issue with the documentation content
                    </a>
                  </div>
                </div>
            </div>
          </div>
        BLOCK
    },
    'wrapper' => sub (%prm, %tml) {
        with %prm<config><direct-wrap> {
            %prm<body>
        }
        else {
            qq:to/BLOCK/
            <div id="wrapper">
                <section class="section">
                <div class="columns">
                { %tml<toc-sidebar>.(%prm, %tml)  }
                { %tml<page-main>.(%prm, %tml) }
                { %tml<search-sidebar>.(%prm, %tml)  }
                </div>
                </section>
            </div>
            BLOCK
        }
    },
    'search-sidebar' => sub (%prm, %tml ) {
	    qq:to/BLOCK/
            <div id="right-column" class="column is-narrow is-hidden-touch" style="width:0px; display:none;">
                {
                    if %tml<raku-search-block>:exists { %tml<raku-search-block>.(%prm, %tml) }
                    else { 'No search function' }
                }
            </div>
        BLOCK
    },
    'toc-sidebar' => sub (%prm, %tml) {
        qq:to/BLOCK/
            <div id="left-column" class="column is-narrow is-hidden-touch" style="width:0px; display:none;">
                {
                    if %tml<raku-toc-block>:exists { %tml<raku-toc-block>.(%prm, %tml) }
                    else { 'No Table of Contents' }
                }
            </div>
        BLOCK
    },
    'page-main' => sub (%prm, %tml ) {
        qq:to/MAIN/
            <div id="main-column" class="column column-middle">
            { %tml<page-header>.(%prm, %tml) }
            { %tml<page-content>.(%prm, %tml) }
            { %tml<page-footnotes>.(%prm, %tml) }
            </div>
        MAIN
    },
    'page-header' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <section class="raku page-header">
            <div class="container px-4">
                <div class="raku page-title has-text-centered">
                { %prm<title> }
                </div>
                <div class="raku page-subtitle has-text-centered">
                { %prm<subtitle> }
                </div>
                { %tml<page-edit>.(%prm,%tml) }
            </div>
        </section>
        BLOCK
    },
    'page-content' => sub (%prm, %tml) {
        my $rv = '<section class="raku page-content">';
        $rv ~= %prm<config><page-content-columns>
            ?? '<div class="container"><div class="columns listing">'
            !! '<div class="container px-4">';
        $rv ~=  %prm<body>;
        $rv ~= %prm<config><page-content-columns>
            ?? '</div></div>'
            !! '</div>';
        $rv ~= "</section>\n"
    },
    'page-footnotes' => sub (%prm, %tml) {
        return '' unless %prm<footnotes>;
        qq:to/BLOCK/
        <section class="page-footnotes">
            <div class="container">
            { %prm<footnotes>  }
            </div>
        </section>
        BLOCK
    },
    'pod' => sub (%prm, %tml) {
        (%prm<contents> // '')
        ~ "\n" ~ (%prm<tail> // '') ~ "\n"
    },
    'footer' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <footer class="footer main-footer">
          <div class="container px-4">
            <nav class="level">
            { %tml<footer-left>.(%prm, %tml) }
            { %tml<footer-right>.(%prm, %tml) }
            </nav>
          </div>
        </footer>
        BLOCK
    },
    footer-left => sub (%prm, %tml ) {
        q:to/FLEFT/
        <div class="level-left">
            <div class="level-item">
              <a href="/about">About</a>
            </div>
            <div class="level-item">
              <a id="toggle-theme">Toggle theme</a>
            </div>
        </div>
        FLEFT
    },
    footer-right => sub (%prm, %tml ) {
        q:to/FRIGHT/
        <div class="level-right">
            <div class="level-item">
              <a href="/license">License</a>
            </div>
        </div>
        FRIGHT
    },
    page-edit => sub (%prm, %tml) {
        return '' unless %prm<config><path> ~~ / ^ .+ 'docs/' ( .+) $ /;
        qq:to/BLOCK/
        <div class="page-edit">
            <a class="button page-edit-button"
               href="https://github.com/Raku/doc/edit/main/{ %tml<escaped>.(~$0) }"
               title="Edit this page.">
              <span class="icon is-right">
                <i class="fas fa-pen-alt is-medium"></i>
              </span>
            </a>
          </div>
        BLOCK
    },
    heading => sub (%prm, %tml) {
        my $txt = %prm<text> // '';
        my $index-parse = $txt ~~ /
            ( '<a name="index-entry-' .+? '</a>' )
            '<span class="glossary-entry">' ( .+? ) '</span>'
        /;
        my $h = 'h' ~ (%prm<level> // '1');
        my $targ = %tml<escaped>.(%prm<target>);
        qq[[\n<$h id="$targ"]]
            ~ qq[[ class="raku-$h">]]
            ~ ( $index-parse.so ?? $index-parse[0] !! '' )
            ~ qq[[<a href="#{ %tml<escaped>.(%prm<top>) }" title="go to top of document">]]
            ~ ( $index-parse.so ?? $index-parse[1] !! $txt )
            ~ qq[[<a class="raku-anchor" title="direct link" href="#$targ">§</a>]]
            ~ qq[[</a></$h>\n]]
    },
    table => sub (%prm, %tml) {
        my $tb = %tml.prior('table').(%prm, %tml);
        $tb.subst(/ '<table class="' /, '<table class="table is-bordered centered ')
    },
    toc => sub (%prm, %tml) {
        my $rv = '';
        if %prm<toc>.defined and %prm<toc>.keys {
            $rv = "<ul class=\"menu-list\">\n";
            my $last-level = 1;
            for %prm<toc>.list -> %el {
                my $lev = %el<level>;
                given $last-level {
                    when $_ > $lev {
                        while $last-level > $lev {
                            $rv ~= "\n</ul>\n";
                            $last-level--;
                        }
                    }
                    when $_ < $lev {
                        while $lev > $last-level {
                            $last-level++;
                            $rv ~= "\n<ul>\n";
                        }
                    }
                }
                $rv ~= "\n<li>"
                    ~ '<a href="#'
                    ~ (%el.<target>)
                    ~ '">'
                    ~ (%el.<text> // '')
                    ~ '</a></li>';
            }
            $rv ~= "\n</ul>\n";
        }
        $rv
    },
    'list' => sub (%prm, %tml) {
        qq[
        <ul{ %prm<nesting> == 0 ?? ' class="rakudoc-item"' !! ''}>
           { %prm<items>.join }
        </ul>
        ]
    },


    'format-b' => sub (%prm, %tml) {
        my $beg = '<strong>';
        my $end = '</strong>';
        my $mark = "\xFF\xFF";
        if %prm<context>.Str eq 'InCodeBlock' {
            $beg = $mark ~ $beg ~ $mark;
            $end = $mark ~ $end ~ $mark;
        }
        $beg ~ %prm<contents> ~ $end
    },
    'format-c' => sub (%prm, %tml) {
        my $beg = '<code>';
        my $end = '</code>';
        my $mark = "\xFF\xFF";
        if %prm<context>.Str eq 'InCodeBlock' {
            $beg = $mark ~ $beg ~ $mark;
            $end = $mark ~ $end ~ $mark;
        }
        $beg ~ %prm<contents> ~ $end
    },
    'format-i' => sub (%prm, %tml) {
        my $beg = '<em>';
        my $end = '</em>';
        my $mark = "\xFF\xFF";
        if %prm<context>.Str eq 'InCodeBlock' {
            $beg = $mark ~ $beg ~ $mark;
            $end = $mark ~ $end ~ $mark;
        }
        $beg ~ %prm<contents> ~ $end
    },
    'format-k' => sub (%prm, %tml) {
        my $beg = '<kbd>';
        my $end = '</kbd>';
        my $mark = "\xFF\xFF";
        if %prm<context>.Str eq 'InCodeBlock' {
            $beg = $mark ~ $beg ~ $mark;
            $end = $mark ~ $end ~ $mark;
        }
        $beg ~ %prm<contents> ~ $end
    },
    'format-r' => sub (%prm, %tml) {
        my $beg = '<var>';
        my $end = '</var>';
        my $mark = "\xFF\xFF";
        if %prm<context>.Str eq 'InCodeBlock' {
            $beg = $mark ~ $beg ~ $mark;
            $end = $mark ~ $end ~ $mark;
        }
        $beg ~ %prm<contents> ~ $end
    },
    'format-t' => sub (%prm, %tml) {
        my $beg = '<samp>';
        my $end = '</samp>';
        my $mark = "\xFF\xFF";
        if %prm<context>.Str eq 'InCodeBlock' {
            $beg = $mark ~ $beg ~ $mark;
            $end = $mark ~ $end ~ $mark;
        }
        $beg ~ %prm<contents> ~ $end
    },
    'format-u' => sub (%prm, %tml) {
        my $beg = '<u>';
        my $end = '</u>';
        my $mark = "\xFF\xFF";
        if %prm<context>.Str eq 'InCodeBlock' {
            $beg = $mark ~ $beg ~ $mark;
            $end = $mark ~ $end ~ $mark;
        }
        $beg ~ %prm<contents> ~ $end
    },
    'format-l' => sub ( %prm, %tml ) {
        # type = local: <link-label> -> <target>#<place> | <target>
        # type = internal: <link-label> -> #<place>
        # type = external: <link-label> -> <target>
        my $trg;
        given %prm<type> {
            when 'local' {
                $trg = %prm<target>;
                $trg ~= '#' ~ %prm<place> if %prm<place>;
                $trg = 'href="' ~ $trg ~ '"'
            }
            when 'internal' {
                $trg = 'href="#' ~ %prm<place> ~ '"'
            }
            default {
                $trg = 'href="' ~ %prm<target> ~ '"'
            }
        }
        my $beg = '<a ' ~ $trg ~ '>';
        my $end =  '</a>';
        my $mark = "\xFF\xFF";
        if %prm<context>.Str eq 'InCodeBlock' {
            $beg = $mark ~ $beg ~ $mark;
            $end = $mark ~ $end ~ $mark;
        }
        $beg ~ ( %prm<link-label> // '' ) ~ $end;
    },
    'format-n' => sub (%prm, %tml) {
        my $beg = '<sup class="content-footnote"><a name="'
                ~ %tml<escaped>.(%prm<retTarget>)
                ~ '" href="#' ~ %tml<escaped>.(%prm<fnTarget>)
                ~ '">';
        my $end = "</a></sup>\n";
        my $mark = "\xFF\xFF";
        if %prm<context>.Str eq 'InCodeBlock' {
            $beg = $mark ~ $beg ~ $mark;
            $end = $mark ~ $end ~ $mark;
        }
        $beg ~ '[' ~ %tml<escaped>.(%prm<fnNumber>) ~ ']' ~ $end
    },
    'format-p' => sub (%prm, %tml) {
        '<div class="pod-placement"><pre>'
                ~ (%prm<contents> // '').=trans(['<pre>', '</pre>'] => ['&lt;pre&gt;', '&lt;/pre&gt;'])
                ~ "</pre></div>\n"
    },
    'format-x' => sub (%prm, %tml) {
        my $indexedheader = %prm<meta>.elems ?? %prm<meta>[0].join(';') !! %prm<text>;
        my $beg = qq[
            <a name="{ %prm<target> // ''}" class="index-entry"
            data-indexedheader="{ $indexedheader }"></a>
            { (%prm<text>.defined and %prm<text> ne '') ?? '<span class="glossary-entry">' !! '' }
        ];
        my $end = '</span>';
        my $mark = "\xFF\xFF";
        if %prm<context>.Str eq 'InCodeBlock' {
            $beg = $mark ~ $beg ~ $mark;
            $end = $mark ~ $end ~ $mark;
        }
        # if there is indexedheader but no text, must still return beg. If indexh.. but text, then end
        $beg ~ ( (%prm<text>.defined and %prm<text> ne '') ?? %prm<text> ~ $end !! '' )
    },
);