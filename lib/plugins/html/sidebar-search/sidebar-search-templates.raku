#!/usr/bin/env raku
use v6.d;
%(
    'raku-search-block' => sub (%prm, %tml) {
    q:to/BLOCK/
        <div id="search-box" class="content">
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
                <div class="control is-grouped is-grouped-centered">
                    <label class="checkbox"><input type="checkbox" id="sidebar-search-fuzzy">
                        Fuzzy search (Alt-f)
                    </label>
                    <label class="checkbox"><input type="checkbox" id="sidebar-search-headings" checked>
                        Search in headings (Alt-h)
                    </label>
                    <label class="checkbox"><input type="checkbox" id="sidebar-search-indexed" checked>
                        Search indexed items (Alt-i)
                    </label>
                    <label class="checkbox"><input type="checkbox" id="sidebar-search-composite" checked>
                        Include composite pages (Alt-c)
                    </label>
                    <label class="checkbox"><input type="checkbox" id="sidebar-search-primary" checked>
                        Include primary sources (Alt-p)
                    </label>
                    <button class="button is-link is-small is-outlined is-rounded" id="sidebar-search-google">Google search this site</button>
                    <label class="checkbox"><input type="checkbox" id="sidebar-search-newtab" checked>
                        Open in new tab (Alt-q)
                    </label>

                </div>
            <div id="sidebar-search" class="sidebar-search-autocomplete" style="display: none;"></div>
        </div>
    BLOCK
   },
);