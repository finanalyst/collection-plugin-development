var sidebarSearchItems;
var needSearchItems = true;
var current_search = "";
var searchOptions;
var persisted_searchOptions = function () {
    return JSON.parse( localStorage.getItem('searchOptions') );
};
var persist_searchOptions = function (searchOptions) {
    localStorage.setItem('searchOptions', JSON.stringify( searchOptions ))
};

var searchSite = window.location.hostname;
var selectedUrl = '';
var keywords = '';
let menuWidth = 600;
let firstItemVal = 25;
let firstItemWid = 120;

function trim_results(results, term) {
  const cutoff = 50;
  if (results.length < cutoff) {
      return results;
  }
  // Prefer exact matches, then starting matches.
  const exacts = [];
  const prefixes = [];
  const rest = [];
  for (let ii = 0; ii <results.length; ii++) {
      if (results[ii].value.toLowerCase() == term.toLowerCase()) {
          exacts.push(ii);
      } else if (results[ii].value.toLowerCase().startsWith(term.toLowerCase())) {
      prefixes.push(ii);
      } else {
          rest.push(ii);
      }
  }
  const keeps = [];
  let pos = 0;
  while (keeps.length <= cutoff && pos < exacts.length) {
      keeps.push(exacts[pos++]);
  }
  pos = 0;
  while (keeps.length <= cutoff && pos < prefixes.length) {
      keeps.push(prefixes[pos++]);
  }
  pos = 0;
  while (keeps.length <= cutoff && pos < rest.length) {
      keeps.push(rest[pos++]);
  }
  const filtered = [];
  for (pos = 0; pos < results.length; pos++) {
      if (keeps.indexOf(pos) != -1) {
          filtered.push(results[pos]);
      }
  }
  return filtered;
};
const category_search = (function() {
    const method_sign = new RegExp(/^(\.)(\w[\w\-]+)/);
    const routine_sign = new RegExp(/^(\&)(\w[\w-]+.*)/);
    const routineMethod_sign = new RegExp(/([^\(]+)(\(\)?)$/);
    const classPackageRole_sign = new RegExp(/^(\:\:)([A-Z][\w\:]*)/);
    return {
        filter_by_category: function(search_term, sidebarSearchItems) {
            let filteredItems = [];
            if (search_term.match(method_sign)) {
                filteredItems = sidebarSearchItems.filter(function(item) { return item.category.toLowerCase() === 'methods' ||  item.category.toLowerCase() === 'routines' });
            } else if (search_term.match(routine_sign)){
                filteredItems = sidebarSearchItems.filter(function(item) { return item.category.toLowerCase() === 'subroutines' || item.category.toLowerCase() === 'routines' });
            } else if (search_term.match(routineMethod_sign)) {
                filteredItems = sidebarSearchItems.filter(function(item) { return item.category.toLowerCase() === 'methods' || item.category.toLowerCase() === 'subroutines' || item.category.toLowerCase() === 'routines' });
            } else if (search_term.match(classPackageRole_sign)) {
                filteredItems = sidebarSearchItems.filter(function(item) { return item.category.toLowerCase() === 'types' });
            } else {
                filteredItems = sidebarSearchItems;
            }
            return filteredItems;
        },
        strip_sign: function(search_term) {
            let match;
            if (search_term.match(method_sign)) {
                // We matched `.`, strip it off
                search_term = search_term.substring(1);
            } else if (search_term.match(routine_sign)) {
                // We matched a &, strip it off
                search_term = search_term.replace('&', '');
            } else if (search_term.match(routineMethod_sign)) {
                // We matched (), strip it off
                search_term = search_term.replace(/[()]/g, '');
            } else if (search_term.match(classPackageRole_sign)) {
                // We matched ::, strip it off
                search_term = search_term.replace('::', '');
            }
            return search_term;
        }
    }
})();
var followLink = function() {
//    /* When using return key to select, the select event
//    and keydown event are both activated and the second
//    event should do nothing */
    window.location.href = selectedUrl;
}
/*
 * Courtesy https://siderite.blogspot.com/2014/11/super-fast-and-accurate-string-distance.html
 */

// Sift4 - common version
// online algorithm to compute the distance between two strings in O(n)
// maxOffset is the number of characters to search for matching letters
// maxDistance is the distance at which the algorithm should stop computing the value and just exit (the strings are too different anyway)
function sift4(s1, s2, maxOffset, maxDistance) {
    if (!s1||!s1.length) {
        if (!s2) {
            return 0;
        }
        return s2.length;
    }

    if (!s2 || !s2.length) {
        return s1.length;
    }

    var l1=s1.length;
    var l2=s2.length;

    var c1 = 0;  //cursor for string 1
    var c2 = 0;  //cursor for string 2
    var lcss = 0;  //largest common subsequence
    var local_cs = 0; //local common substring
    var trans = 0;  //number of transpositions ('ab' vs 'ba')
    var offset_arr=[];  //offset pair array, for computing the transpositions

    while ((c1 < l1) && (c2 < l2)) {
        if (s1.charAt(c1) == s2.charAt(c2)) {
            local_cs++;
            let isTrans = false;
            //see if current match is a transposition
            let i=0;
            for(let i = 0; i < offset_arr.length; i++) {
                const ofs=offset_arr[i];
                if (c1<=ofs.c1 || c2 <= ofs.c2) {
                    // when two matches cross, the one considered a transposition is the one with the largest difference in offsets
                    isTrans = Math.abs(c2 - c1) >= Math.abs(ofs.c2 - ofs.c1);
                    if (isTrans)
                    {
                        trans++;
                    } else {
                        if (!ofs.trans) {
                            ofs.trans=true;
                            trans++;
                        }
                    }
                    break;
                } else {
                    if (c1 > ofs.c2 && c2 > ofs.c1) {
                        offset_arr.splice(i,1);
                    } else {
                        i++;
                    }
                }
            }
            offset_arr.push({
                c1:c1,
                c2:c2,
                trans:isTrans
            });
        } else {
            lcss += local_cs;
            local_cs = 0;
            if (c1!=c2) {
                c1 = c2=Math.min(c1,c2);  //using min allows the computation of transpositions
            }
            //if matching characters are found, remove 1 from both cursors (they get incremented at the end of the loop)
            //so that we can have only one code block handling matches
            for (let i = 0; i < maxOffset && (c1+i<l1 || c2+i<l2); i++) {
                if ((c1 + i < l1) && (s1.charAt(c1 + i) == s2.charAt(c2))) {
                    c1 += i-1;
                    c2--;
                    break;
                }
                if ((c2 + i < l2) && (s1.charAt(c1) == s2.charAt(c2 + i))) {
                    c1--;
                    c2+= i-1;
                    break;
                }
            }
        }
        c1++;
        c2++;
        if (maxDistance) {
            let temporaryDistance=Math.max(c1,c2)-lcss+trans;
            if (temporaryDistance>=maxDistance) return Math.round(temporaryDistance);
        }
        // this covers the case where the last match is on the last token in list, so that it can compute transpositions correctly
        if ((c1 >= l1) || (c2 >= l2)) {
            lcss+=local_cs;
            local_cs=0;
            c1=c2=Math.min(c1,c2);
        }
    }
    lcss+=local_cs;
    return Math.round(Math.max(l1,l2)- lcss +trans); //add the cost of transpositions to the final result
}

$(function(){
  // when the page is renewed, the extended sidebarSearchItems will not be loaded, so signal this
  needExtendedItems = true;
  $.widget( "custom.catcomplete", $.ui.autocomplete, {
    _create: function() {
      this._super();
      this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );
    },
    _renderItem: function( ul, item) {
        const info_element = $('<div>')
            .attr('class', 'item-info')
            .css( 'width', (menuWidth - firstItemWid - 10) )
            .html( item.info );
        const regex = new RegExp('('
            + current_search.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&')
            + ')', 'ig');
        const text = item.label.replace(regex, '<b>$1</b>');
        const boldMatch = text.match(/^<b>.*?<\/b>$/);
        if (boldMatch && boldMatch[0].match(/<b>/g).length === 1) {
            selectedUrl = item.url;
        }
        return $( "<li title='Type enter to select'>" )
            .append( $( "<div>" ).css('width', firstItemWid ).html(text) )
            .append(info_element)
            .appendTo( ul )
    },
    _renderMenu: function( ul, sidebarSearchItems ) {
      const that = this;
      let currentCategory = "";
      menuWidth = this.menu.element.outerWidth();
      firstItemWid = menuWidth * firstItemVal / 100;
      keywords = category_search.strip_sign( that.element.val() );
      sidebarSearchItems.forEach(function(item, index) {
        let li;
        if ( item.category != currentCategory ) {
          ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
          currentCategory = item.category;
        }
        li = that._renderItemData( ul, item );
        if ( item.category ) {
          li.attr( "aria-label", item.category + " : " + item.label );
        }
      });
      if ($(ul).find('.default-selection').length > 1) {
        $(ul).find('.default-selection').not(":first")
            .removeClass('default-selection')
            .css({'display': 'none'});
      };
    }
  });

  // The catcomplete plugin doesn't handle unfocus, so hide the "no results" bar
  // manually in case the search is not used anymore
    $("#query").attr('placeholder', '🔍').catcomplete({
      appendTo: "#sidebar-search",
      autoFocus: true,
      open: function() {
        const ui_el = $('.ui-autocomplete');
        if ( ui_el.offset().left < 0 ) {
            ui_el.css({left: 0})
        }
      },
      position: { my: "right top", at: "right bottom" },
      source: function(request, response) {
          const filteredItems = category_search.filter_by_category(request.term, sidebarSearchItems);
          const results = $.ui.autocomplete.filter(filteredItems, category_search.strip_sign(request.term));
          response(trim_results(results, request.term));
      },
      select: function (event, ui) {
        selectedUrl = ui.item.url;
        followLink();
      }
  });

  $("#query").keydown(function(event, ui) {
    if (event.keyCode == 13) {
     followLink();
    }
  });
});
/*
 * allow for inexact searching via sift4
 * try to restrict usage, and always check the standard
 * search mechanism if sift4 doesn't match
 */
$.extend( $.ui.autocomplete, {
    escapeRegex: function( value ) {
        return value.replace( /[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&" );
    },
    filter: function( array, term ) {
        current_search = term.toLowerCase();

        var search_method = false;
        if (term.match(/^\s*\.[a-zA-Z][a-zA-Z0-9_-]+\s*$/)) {
            search_method = true;
            term = term.substr(1);
        }

        const len = term.length;
        const matcher = new RegExp( $.ui.autocomplete.escapeRegex( term ), "i" );
        const OK_distance = len > 9 ? 4 : len > 6 ? 3 : len > 4 ? 2 : 1;
        return $.grep( array, function( value ) {
            if ( value.type == 'primary' && ! searchOptions.primary ) { return false };
            if ( value.type == 'composite' && ! searchOptions.composite ) { return false };
            if ( value.type == 'headings' && ! searchOptions.headings ) { return false };
            if ( value.type == 'indexed' && ! searchOptions.indexed ) { return false };

            if (search_method && value.category != 'Method') {
                return false;
            }
            if (len >=2 && searchOptions.fuzzy ) {
                const result = sift4( value.value, term, 4, 0);
                if (result <= OK_distance) {
                    return true;
                }
            }

            // Try the old school match
            return matcher.test( value.label || value.value || value );
        } );
    }
} );

// Code to set up the search bar events
$(document).ready(function() {
    searchOptions = persisted_searchOptions();
    if ( searchOptions == null ) {
        searchOptions  = {
            "fuzzy": false,
            "headings": true,
            "indexed": true,
            "primary": true,
            "composite": true,
            "newtab": true
        };
        persist_searchOptions( searchOptions );
    }
    for ( const prop in searchOptions ) {
        $('#sidebar-search-' + prop ).prop('checked', searchOptions[ prop ]);
    }
    $('#query').focus(function () {
        if ( needExtendedItems ) {
            $.getScript("/assets/scripts/sidebar-search-extended.js");
        }
        $('#sidebar-search').show();
    });
  // Functions to manage buttons
  $('#sidebar-search-google').click( function() {
      window.open(
        'https://www.google.com/search?q=site%3A'
        + searchSite
        + '+'
        + encodeURIComponent( keywords ), '_blank'
        );
  });
  $('#sidebar-search-fuzzy').on('change', function() {
    searchOptions.fuzzy = this.checked;
    persist_searchOptions( searchOptions );
  });
  $('#sidebar-search-headings').on('change', function() {
    searchOptions.headings = this.checked;
    persist_searchOptions( searchOptions );
  });
  $('#sidebar-search-indexed').on('change', function() {
    searchOptions.indexed = this.checked;
    persist_searchOptions( searchOptions );
  });
  $('#sidebar-search-primary').on('change', function() {
    searchOptions.primary = this.checked;
    persist_searchOptions( searchOptions );
  });
  $('#sidebar-search-composite').on('change', function() {
    searchOptions.composite = this.checked;
    persist_searchOptions( searchOptions );
  });
  $('#sidebar-search-newtab').on('change', function() {
    searchOptions.newtab = this.checked;
    persist_searchOptions( searchOptions );
  });
  // Add Alt key strokes for changes above
  $('#right-column').on('keydown', function(e) {
   let srch = false;
   if (e.altKey && e.key === 'f') {
     // Prevent the Save dialog to open
     e.preventDefault();
     $('#sidebar-search-fuzzy').trigger('click');
     srch = true;
   }
   if (e.altKey && e.key === 'h') {
     // Prevent the Save dialog to open
     e.preventDefault();
     $('#sidebar-search-headings').trigger('click');
     srch = true;
   }
   if (e.altKey && e.key === 'i') {
     // Prevent the Save dialog to open
     e.preventDefault();
     $('#sidebar-search-indexed').trigger('click');
     srch = true;
   }
   if (e.altKey && e.key === 'p') {
     // Prevent the Save dialog to open
     e.preventDefault();
     $('#sidebar-search-primary').trigger('click');
     srch = true;
   }
   if (e.altKey && e.key === 'c') {
     // Prevent the Save dialog to open
     e.preventDefault();
     $('#sidebar-search-composite').trigger('click');
     srch = true;
   }
   if (e.altKey && e.key === 'q') {
     e.preventDefault();
     $('#sidebar-search-newtab').trigger('click');
   }
   if ( srch ) {
     $('#query').catcomplete('search', $('#query').val() )
   }
 });
});