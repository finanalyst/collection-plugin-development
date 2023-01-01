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
        { %tml<header>.(%prm, %tml)  }
        { %tml<sidebar>.(%prm, %tml)  }
        { %tml<wrapper>.(%prm, %tml)  }
        { %tml<footer>.(%prm, %tml)  }
        { %tml<js-bottom>.({}, {}) }
        { %tml<end-block>.(%prm, %tml) }
        BLOCK
    },
    'header' => sub (%prm, %tml) {
        q:to/BLOCK/
        <nav class="navbar is-fixed-top" role="navigation" aria-label="main navigation">
          <div class="container">
            <div class="navbar-brand navbar-logo">
              <div class="navbar-logo">
                <a class="navbar-item" href="/">
                  <img src="/assets/image/camelia-recoloured.png" alt="Raku" width="52.83" height="38">
                </a>
                <div class="navbar-logo-tm">tm</div>
              </div>
              <a role="button" class="navbar-burger burger" aria-label="menu" aria-expanded="false" data-target="navMenu">
                <span aria-hidden="true"></span>
                <span aria-hidden="true"></span>
                <span aria-hidden="true"></span>
              </a>
            </div>
            <div id="navMenu" class="navbar-menu">
              <div class="navbar-start">
                  <a class="navbar-item" href="/language">
                    Language
                  </a>
                  <a class="navbar-item" href="/type">
                    Types
                  </a>
                  <a class="navbar-item" href="/routine">
                    Routines
                  </a>
                  <a class="navbar-item" href="/programs">
                    Programs
                  </a>
                <a class="navbar-item" href="https://raku.org">
                  Raku Homepage
                </a>
                <a class="navbar-item" href="https://webchat.freenode.net/?channels=#raku">
                  Chat with us
                </a>
                <div class="navbar-item has-dropdown is-hoverable">
                  <a class="navbar-link">
                    More
                  </a>
                  <div class="navbar-dropdown">
                    <a class="navbar-item" href="/search">
                      Extended Search
                    </a>
                    <hr class="navbar-divider">
                    <a class="navbar-item" href="/about">
                      About
                    </a>
                    <hr class="navbar-divider">
                    <a class="navbar-item has-text-red" href="https://github.com/raku/doc/blob/master/CONTRIBUTING.md#reporting-bugs">
                      Report an issue with the content
                    </a>
                    <hr class="navbar-divider">
                    <a class="navbar-item has-text-red" href="https://github.com/Altai-man/docs.raku.org/issues">
                      Report an issue of this site
                    </a>
                  </div>
                </div>
              </div>
              <div class="navbar-end navbar-search-wrapper">
                <div class="navbar-item">
                  <div class="field has-addons">
                    <div id="search" class="control">
                      <input id="query" class="input ui-autocomplete-input" type="text" placeholder="🔍" autocomplete="off">
                    </div>
                    <div class="control">
                      <a class="button is-primary">
                        <span class="icon">
                          <i class="fas fa-search "></i>
                        </span>
                      </a>
                    </div>
                  </div>
                </div>
                <div id="navbar-search" class="navbar-search-autocomplete" style="display: none;">
                    <ul id="ui-id-1"
                        tabindex="0"
                        class="ui-menu ui-widget ui-widget-content ui-autocomplete ui-front"
                        style="display: none;">
                    </ul>
                </div>
                <div id="navbar-search-empty"
                    class="navbar-search-autocomplete">
                  <a id="try-web-search" href="https://www.google.com/" class="button" target="blank">
                    Not found, but you can try site search</a>
                </div>
              </div>
            </div>
          </div>
        </nav>;
        BLOCK
    },
    'sidebar' => sub (%prm, %tml) {
        return '' unless %prm<toc>;
        qq:to/BLOCK/
        <div id="mainSidebar" class="raku-sidebar" style="width:0px; display:none;">
          <div class="field">
            <label class="label has-text-centered">Table of Contents</label>
            <div class="control has-icons-right">
              <input id="toc-filter" class="input" type="text" placeholder="Filter">
              <span class="icon is-right has-text-grey">
                <i class="fas fa-search is-medium"></i>
              </span>
            </div>
          </div>
          <div class="raku-sidebar-body">
            <aside id="toc-menu" class="menu">
            { %prm<toc> }
            </aside>
          </div>
        </div>
        BLOCK
    },
    'wrapper' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <div id="wrapper">
        { %tml<page-header>.(%prm, %tml)  }
        { %tml<page-content>.(%prm, %tml)  }
        { %tml<page-footnotes>.(%prm, %tml)  }
        { %tml<page-generated>.(%prm, %tml)  }
        </div>
        BLOCK
    },
    'page-header' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <section class="container px-4">
            <div class="raku page-title has-text-centered">
            { %prm<title>  }
            </div>
            <div class="raku page-subtitle has-text-centered">
            { %prm<subtitle>  }
            </div>
            { %tml<page-edit>.(%prm,%tml)  }
        </section>
        BLOCK
    },
    'page-content' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <section class="raku page-content">
            <div class="container px-4">
            { %prm<body>  }
            </div>
        </section>
        BLOCK
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
    'page-generated' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <section class="page-generated">
            <div class="container has-text-centered">
              <p> Generated from { %prm<config><path> }
                at { DateTime(now).truncated-to('second') }</p>
            </div>
        </section>;
        BLOCK
    },
    'footer' => sub (%prm, %tml) {
        q:to/BLOCK/
        <footer class="footer main-footer">
          <div class="container px-4">
            <nav class="level">
                <div class="level-left">
                  <div class="level-item">
                      <a href="/about">About</a>
                   </div>
                    <div class="level-item">
                      <a id="toggle-theme">Toggle theme</a>
                    </div>
                </div>
                <div class="level-right">
                  <div class="level-item">
                    <p>
                      This website is licensed under
                      <a href="https://raw.githubusercontent.com/Raku/doc/master/LICENSE">the Artistic License 2.0</a>
                    </p>
                  </div>
                </div>
            </nav>
          </div>
        </footer>
        BLOCK
    },
    'page-edit' => sub (%prm, %tml) {
        return '' unless %prm<config><path> ~~ / ^ .+ ('docs/' .+) $ /;
        qq:to/BLOCK/
        <div class="page-edit">
            <a class="button page-edit-button"
               href="https://github.com/Raku/doc/edit/master/{ %tml<escaped>.(~$0) }"
               title="Edit this page.">
              <span class="icon is-right">
                <i class="fas fa-pen-alt is-medium"></i>
              </span>
            </a>
          </div>
        BLOCK
    },
    'end-block' => sub (%prm, %tml) {
        qq:to/BLOCK/
        <script
            defer=""
            src="https://use.fontawesome.com/releases/v5.3.1/js/all.js">
        </script>
        <div
            role="status"
            aria-live="assertive"
            aria-relevant="additions"
            class="ui-helper-hidden-accessible">
        </div>
        BLOCK
    },
);