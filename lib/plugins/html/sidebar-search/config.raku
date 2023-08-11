%(
	:auth<collection>,
	:authors(
		"finanalyst",
		"rawleyfowler"
	),
	:compilation<add-sidebar-search.raku>,
	:custom-raku(),
	:transfer<cleanup.raku>,
	:license<Artistic-2.0>,
	:name<sidebar-search>,
	:render,
	:template-raku<sidebar-search-templates.raku>,
	:version<0.1.2>,
	:information<css-link>,
	:add-css<css/sidebar-search-light.css css/sidebar-search-dark.css>,
	:js-link(
		['src="https://cdn.jsdelivr.net/npm/@tarekraafat/autocomplete.js@10.2.7/dist/autoComplete.min.js"', 1],
	),
	:js-script( ['sidebar-search.js',2], ),
	:css-link<href="https://cdn.jsdelivr.net/npm/@tarekraafat/autocomplete.js@10.2.7/dist/css/autoComplete.min.css">,
	:compare-ignore<sidebar-search-extended.js>,
)