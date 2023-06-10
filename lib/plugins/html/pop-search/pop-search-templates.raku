#!/usr/bin/env raku
use v6.d;
%(
    'head-search' => sub (%prm, %tml) {
        q:to/BLOCK/
            <div class="navbar-end navbar-search-wrapper">
                <div class="navbar-item">
                    <div class="field has-addons">
                        <div id="search" class="control">
                            <input id="query" class="input ui-autocomplete-input" type="text" placeholder="🔍" autocomplete="off">
                        </div>
                        <div class="control buttons">
                            <button class="button is-primary">
                                <span class="icon" title="Quick search">
                                    <i class="fas fa-search "></i>
                                </span>
                            </button>
                            <button id="pop-search-button" class="js-modal-trigger button is-primary" data-target="pop-search">
                              <span class="icon" title="Extended search">
                                <i class="fab fa-searchengin fa-lg"></i>
                                </span>
                            </button>
                        </div>
                        <div id="navbar-search" class="navbar-search-autocomplete" style="display: none;"></div>
                    </div>
                </div>
            </div>
	    BLOCK
   },
    footer => sub ( %prm, %tml ) {
      %tml.prior('footer').(%prm, %tml) ~ q:to/MODAL/;
            <div class="modal" id="pop-search">
              <div class="modal-background"></div>
              <div class="modal-card">
                <header class="modal-card-head">
                  <p class="modal-card-title">Extended search</p>
                  <button class="delete" aria-label="close"></button>
                </header>
                <section id="pop-search-body" class="modal-card-body">
                    <div id="modal-search-bar" class="field has-addons">
                        <input id="modal-query" class="input is-focused ui-autocomplete-input" type="text" placeholder="🔍">
                    </div>
                    <div id="modal-search" class="modal-search-autocomplete" style="display: none;"></div>
                </section>
                <footer class="modal-card-foot">
                  <div class="control is-grouped is-grouped-centered">
                      <label class="checkbox"><input type="checkbox" id="pop-search-fuzzy">
                        Fuzzy search (Alt-f)
                      </label>
                      <label class="checkbox"><input type="checkbox" id="pop-search-headings" checked>
                        Search in headings (Alt-h)
                      </label>
                      <label class="checkbox"><input type="checkbox" id="pop-search-indexed" checked>
                        Search indexed items (Alt-i)
                      </label>
                      <label class="checkbox"><input type="checkbox" id="pop-search-composite" checked>
                        Include composite pages (Alt-c)
                      </label>
                      <label class="checkbox"><input type="checkbox" id="pop-search-primary" checked>
                        Include primary sources (Alt-p)
                      </label>
                      <label class="text"><input type="range" id="pop-search-divider">
                        Width of label (Alt-p)
                      </label>
                    </div>
                    <div class="control">
                      <button class="button is-link is-small is-outlined is-rounded" id="pop-search-google">Google search this site</button>
                    </div>
                </footer>
              </div>
            </div>
        MODAL
    },
    extendedsearch => sub (%prm, %tml) {
        return q:to/ERROR/ without %prm<extendedsearch>;
            <div class="listf-error">ExtendedSearch has no collected data,
            is ｢extendedsearch｣ in the Mode's ｢plugins-required<compilation>｣ list?
            </div>
            ERROR
        qq:to/SEARCH/;
          <div class="container px-4">
            <div class="search-form mb-4">
              <div class="field">
                <div class="control has-icons-right">
                  <input id="search-input" class="input" type="text" placeholder="Search">
                  <span class="icon is-small is-right">
                    <i class="fas fa-search"></i>
                  </span>
                </div>
              </div>
              <nav class="level">
                <!-- Left side -->
                <div class="level-left">
                  <div class="level-item">
                    <div class="field">
                      <div class="control">
                        <div class="select">
                          <select id="search-category-select">
                            <option value="All">All</option>
                            { %prm<extendedsearch>.map(
                                { '<option value="' ~ $_ ~ '">' ~ $_ ~ '</option>' }
                            ) }
                          </select>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="level-right">
                  <div class="level-item">
                    <div id="search-count" class="raku search-result-amount">Type in a Search string</div>
                  </div>
                </div>
              </nav>
            </div>
            <div class="raku-search results"></div>
          </div>
        <script defer="" src="/assets/scripts/js/extended-search.js"></script>
        SEARCH
    },
);