#!/usr/bin/env raku
use v6.d;
%(
    'raku-search-block' => sub (%prm, %tml) {
    q:to/BLOCK/
        <div class="sidebar-search-wrapper">
            <div class="autoComplete_wrapper">
                <input id="autoComplete" type="search" dir="ltr" spellcheck=false autocorrect="off" autocomplete="off" autocapitalize="off">
            </div>
            <div id="selected-candidate" class="ss-selected"></div>
            <div class="control is-grouped is-grouped-centered sidebar-search-controls">
                 <label class="wordSwitch" title="Include extra information (Alt-E)">
                   <span class="text left">Extra info</span>
                   <input id="sidebar-search-extra" type="checkbox">
                   <span class="value"
                      data-word-on="yes"
                      data-word-off="no"
                      style="--switch-width: 6">
                   </span>
                 </label>
                 <label class="wordSwitch" title="Search engine type Strict/Loose (Alt-L)">
                   <span class="text left">Search type</span>
                   <input id="sidebar-search-loose" type="checkbox">
                   <span class="value"
                      data-word-on="loose"
                      data-word-off="strict"
                      style="--switch-width: 6">
                   </span>
                 </label>
                 <label class="wordSwitch" title="Search in headings (Alt-H)">
                   <span class="text left">Headings</span>
                   <input id="sidebar-search-headings" type="checkbox">
                   <span class="value"
                      data-word-on="yes"
                      data-word-off="no"
                      style="--switch-width: 6">
                   </span>
                 </label>
                 <label class="wordSwitch" title="Search indexed items (Alt-I)">
                   <span class="text left">Indexed</span>
                   <input id="sidebar-search-indexed" type="checkbox">
                   <span class="value"
                      data-word-on="yes"
                      data-word-off="no"
                      style="--switch-width: 6">
                   </span>
                 </label>
                 <label class="wordSwitch" title="Search composite pages (Alt-C)">
                   <span class="text left">Composite</span>
                   <input id="sidebar-search-composite" type="checkbox">
                   <span class="value"
                      data-word-on="yes"
                      data-word-off="no"
                      style="--switch-width: 6">
                   </span>
                    </label>
                 <label class="wordSwitch" title="Search primary sources (Alt-P)">
                   <span class="text left">Primary</span>
                   <input id="sidebar-search-primary" type="checkbox">
                   <span class="value"
                      data-word-on="yes"
                      data-word-off="no"
                      style="--switch-width: 6">
                   </span>
                 </label>
                 <label class="wordSwitch" title="Open in new tab (Alt-Q)">
                   <span class="text left">New tab</span>
                   <input id="sidebar-search-newtab" type="checkbox">
                   <span class="value"
                      data-word-on="yes"
                      data-word-off="no"
                      style="--switch-width: 6">
                   </span>
                 </label>
                 <button class="button is-link is-small is-outlined is-rounded" id="sidebar-search-google">Google search this site</button>
                 <button class="button is-link is-small is-outlined is-rounded js-modal-trigger"
                        data-target="sidebar-search-help">Info about Search</button>
            </div>
        </div>
        <div id="sidebar-search-help" class="modal">
          <div class="modal-background"></div>
          <div class="modal-content">
            <div class="box">
              <h>Search information</h>
                <p>The search panel can be opened using Ctrl-s</p>
                <p>The search response can be shortened by excluding the extra information line (Alt-E)</p>
                <p> The search engine can perform a strict search (only the characters in the search
                box) or a loose search (Alt-L)</p>
                <p>The search data can be filtered</p>
                <ul>
                    <li>Search through headings in all web-pages (Alt-H)</li>
                    <li>Search through all indexed items (Alt-I)</li>
                    <li>Search in the names of composite pages, which combine similar information from
                    the main web pages (Alt-C)</li>
                    <li>Search through the names of the main web pages (Alt-P)</li>
                </ul>
                <p>Once a search candidate has been chosen, it can be opened in a new tab or in the current
                tab (Alt-Q)</p>
                <p>If all else fails, use the Google search engine on the whole site</p>
                <p>Exit this page by pressing &lt;Escape&gt;, or clicking on X or on the background.</p>
            </div>
          </div>
          <button class="modal-close is-large" aria-label="close"></button>
        </div>
    BLOCK
   },
);