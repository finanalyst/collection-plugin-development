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
	:version<0.1.1>,
	:jquery( ['sidebar-search.js',2], ),
	:information<jquery jquery-link add-css>,
	:add-css<css/sidebar-search-light.css css/sidebar-search-dark.css>,
	:jquery-link(
		['src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
			integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU="
			crossorigin="anonymous"', 1],
	),
	:compare-ignore<sidebar-search-extended.js>,
)