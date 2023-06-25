var change_theme = function (theme) { return false; };
var persisted_theme = function () { return localStorage.getItem('color-scheme') };
var persist_theme = function (theme) { localStorage.setItem('color-scheme', theme) };

var sidebar_state;
var persisted_sidebars = function () {
    return JSON.parse( localStorage.getItem('sidebar-state') );
};
var persist_sidebars = function (sidebar_state) {
    localStorage.setItem('sidebar-state', JSON.stringify( sidebar_state ))
};
var set_sidebar_right;
var set_sidebar_left;

(function generateColorSchemes() {
    const theme_links = {};
    const change_themes = {};
    for (const link of document.querySelectorAll('link[rel="stylesheet"]')) {
        const title = link.getAttribute("title");
        if (!title)
            continue;
        link.disabled = true;
        (theme_links[title] ||= []).push(link);
    }
    const links_by_filter = (predicate) => Array.prototype.concat.apply([], Object.entries(theme_links).filter(k => predicate({ theme: k[0] })).map(e => e[1]));
    for (const theme in theme_links) {
        const links_to_disable = links_by_filter(e => e.theme != theme);
        const links_to_enable = links_by_filter(e => e.theme == theme);
        change_themes[theme] = function () {
            for (const link of links_to_disable)
                link.disabled = true;
            for (const link of links_to_enable)
                link.disabled = false;
        }
    }
    change_theme = function (theme) {
        let change = change_themes[theme];
        if (change) {
            change();
            return true;
        } else {
            console.error("Could not set theme", theme);
            return false;
        }
    }
})();
// initialise if localStorage not set
(function () {
    let theme = persisted_theme();
    if (theme && change_theme(theme)) {
        return;
    }
    theme = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    change_theme(theme);
    persist_theme(theme);
})();
(function () {
    sidebar_state = persisted_sidebars();
    set_sidebar_left = function ( state ) {
        if ( state == 'closed') {
            $('#left-column').css({"display": "none", "width": "0"});
            $('#navbar-left-toggle a div.sidebar-arrow span svg').addClass('fa-chevron-right');
            $('#navbar-left-toggle a div.sidebar-arrow span svg').removeClass('fa-chevron-left');
            $('#main-column').addClass('has-left-sidebar');
        }
        else {
            $('#left-column').css({"display": "block", "width": "300px"});
            $('#navbar-left-toggle a div.sidebar-arrow span svg').addClass('fa-chevron-left');
            $('#navbar-left-toggle a div.sidebar-arrow span svg').removeClass('fa-chevron-right');
            $('#main-column').removeClass('has-left-sidebar');
        }
        sidebar_state.left = state;
        persist_sidebars( sidebar_state );
    };
    set_sidebar_right = function ( state ) {
        if ( state == 'closed') {
            $('#right-column').css({"display": "none", "width": "0"});
            $('#navbar-right-toggle a div.sidebar-arrow span svg').addClass('fa-chevron-right');
            $('#navbar-right-toggle a div.sidebar-arrow span svg').removeClass('fa-chevron-left');
            $('#main-column').addClass('has-right-sidebar');
        }
        else {
            $('#right-column').css({"display": "block", "width": "300px"});
            $('#navbar-right-toggle a div.sidebar-arrow span svg').addClass('fa-chevron-left');
            $('#navbar-right-toggle a div.sidebar-arrow span svg').removeClass('fa-chevron-right');
            $('#main-column').removeClass('has-right-sidebar');
        }
        sidebar_state.right = state;
        persist_sidebars( sidebar_state );
    };
    if ( sidebar_state == null ) {
        sidebar_state = {
            "left": "closed",
            "right": "closed"
        };
    }
})();

// Add listeners
// Open navbar menu via burger button on mobiles
$(document).ready( function() {
    // Get all "navbar-burger" elements
    const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
    // Check if there are any navbar burgers
    if ($navbarBurgers.length > 0) {
        // Add a click event on each of them
        $navbarBurgers.forEach(el => {
            el.addEventListener('click', () => {
                // Get the target from the "data-target" attribute
                const target = el.dataset.target;
                const $target = document.getElementById(target);
                // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
                el.classList.toggle('is-active');
                $target.classList.toggle('is-active');
            });
        });
    };
    $('#toggle-theme').click(function () {
        let theme = persisted_theme() === 'light' ? 'dark' : 'light';
        change_theme(theme);
        persist_theme(theme);
    });
    // initialise state
    set_sidebar_left( sidebar_state.left );
    set_sidebar_right( sidebar_state.right );
    $('#navbar-left-toggle').click(function () {
        if (persisted_sidebars().left == 'open') {
            set_sidebar_left('closed');
        }
        else {
            set_sidebar_left('open');
        }
    });
    $('#navbar-right-toggle').click(function () {
        if (persisted_sidebars().right == 'open') {
            set_sidebar_right('closed');
        }
        else {
            set_sidebar_right('open');
        }
    });
    // copy code block to clipboard adapted from solution at
    // https://stackoverflow.com/questions/34191780/javascript-copy-string-to-clipboard-as-text-html
    // if behaviour problems with different browsers add stylesheet code from that solution.
    $('.copy-code').click( function() {
        var codeElement = $(this).next().next(); // skip the label and get the div
        var container = document.createElement('div');
        container.innerHTML = codeElement.html();
        container.style.position = 'fixed';
        container.style.pointerEvents = 'none';
        container.style.opacity = 0;
        document.body.appendChild(container);
        window.getSelection().removeAllRanges();
        var range = document.createRange();
        range.selectNode(container);
        window.getSelection().addRange(range);
        document.execCommand("copy", false);
        document.body.removeChild(container);
    });
});

