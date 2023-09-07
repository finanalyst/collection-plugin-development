#!/usr/bin/env raku
use v6.d;
%(
    'raku-search-block' => sub (%prm, %tml) {
    q:to/BLOCK/
        <div class="options-search-wrapper">
            <div class="autoComplete_wrapper">
                <input id="autoComplete" type="search" dir="ltr" spellcheck=false autocorrect="off" autocomplete="off" autocapitalize="off">
            </div>
            <div id="selected-candidate" class="ss-selected"></div>
            <div class="control is-grouped is-grouped-centered options-search-controls">
                 <label class="centreToggle" title="Include extra information (Alt-E)" style="--switch-width: 10.5">
                   <input id="options-search-extra" type="checkbox">
                   <span class="text">Extra info</span>
                   <span class="on">yes</span>
                   <span class="off">no</span>
                 </label>
                 <label class="centreToggle" title="Search engine type Strict/Loose (Alt-L)" style="--switch-width: 10.5">
                   <input id="options-search-loose" type="checkbox">
                   <span class="text">Search type</span>
                   <span class="on">loose</span>
                   <span class="off">strict</span>
                 </label>
                 <label class="centreToggle" title="Search in headings (Alt-H)" style="--switch-width: 10.5">
                   <input id="options-search-headings" type="checkbox">
                   <span class="text">Headings</span>
                   <span class="on">yes</span>
                   <span class="off">no</span>
                 </label>
                 <label class="centreToggle" title="Search indexed items (Alt-I)" style="--switch-width: 10.5">
                   <input id="options-search-indexed" type="checkbox">
                   <span class="text">Indexed</span>
                   <span class="on">yes</span>
                   <span class="off">no</span>
                 </label>
                 <label class="centreToggle" title="Search composite pages (Alt-C)" style="--switch-width: 10.5">
                   <input id="options-search-composite" type="checkbox">
                   <span class="text">Composite</span>
                   <span class="on">yes</span>
                   <span class="off">no</span>
                    </label>
                 <label class="centreToggle" title="Search primary sources (Alt-P)" style="--switch-width: 10.5">
                   <input id="options-search-primary" type="checkbox">
                   <span class="text">Primary</span>
                   <span class="on">yes</span>
                   <span class="off">no</span>
                 </label>
                 <label class="centreToggle" title="Open in new tab (Alt-Q)" style="--switch-width: 10.5">
                   <input id="options-search-newtab" type="checkbox">
                   <span class="text">New tab</span>
                   <span class="on">yes</span>
                   <span class="off">no</span>
                 </label>
                 <button class="button is-link is-small is-outlined is-rounded" id="options-search-google">Google search this site</button>
                 <button class="button is-link is-small is-outlined is-rounded js-modal-trigger"
                        data-target="options-search-help">Info about Search</button>
            </div>
        </div>
        <div id="options-search-help" class="modal">
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