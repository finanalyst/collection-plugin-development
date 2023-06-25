#!/usr/bin/env raku
use v6.d;
%(
    raku-toc-block => sub (%prm, %tml) {
        qq:to/TOC/
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
        TOC
    },
);
