#!/usr/bin/env raku
use v6.d;
%(
    'raku-search-block' => sub (%prm, %tml) {
    q:to/BLOCK/
        <div id="search-box" class="content">
            <div class="control is-grouped is-grouped-centered">
                <div class="autoComplete_wrapper">
                    <input id="autoComplete" type="search" dir="ltr" spellcheck=false autocorrect="off" autocomplete="off" autocapitalize="off">
                </div>
                <div id="selected-candidate" class="ss-selected"></div>
                <label class="checkbox"><input type="checkbox" id="sidebar-search-extra" checked>
                    Include extra information (Alt-E)
                </label>
                <label class="checkbox"><input type="checkbox" id="sidebar-search-loose">
                    Search engine type Strict/Loose (Alt-L)
                </label>
                <label class="checkbox"><input type="checkbox" id="sidebar-search-headings" checked>
                    Search in headings (Alt-H)
                </label>
                <label class="checkbox"><input type="checkbox" id="sidebar-search-indexed" checked>
                    Search indexed items (Alt-I)
                </label>
                <label class="checkbox"><input type="checkbox" id="sidebar-search-composite" checked>
                    Search composite pages (Alt-C)
                </label>
                <label class="checkbox"><input type="checkbox" id="sidebar-search-primary" checked>
                    Search primary sources (Alt-P)
                </label><label class="checkbox"><input type="checkbox" id="sidebar-search-newtab" checked>
                    Open in new tab (Alt-Q)
                </label>
                <button class="button is-link is-small is-outlined is-rounded" id="sidebar-search-google">Google search this site</button>
                <button class="button is-link is-small is-outlined is-rounded" id="sidebar-search-help">Info about Search</button>
            </div>
        </div>
    BLOCK
   },
);