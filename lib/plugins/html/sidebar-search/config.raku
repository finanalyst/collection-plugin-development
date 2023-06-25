%(
	:auth<collection>,
	:authors(
		"finanalyst",
		"rawleyfowler"
	),
	:compilation<add-pop-search.raku>,
	:custom-raku<new-blocks.raku>,
	:transfer<cleanup.raku>,
	:license<Artistic-2.0>,
	:name<pop-search>,
	:render,
	:template-raku<pop-search-templates.raku>,
	:version<0.1.24>,
	:jquery( ['pop-search-bar.js',2], ),
	:information<jquery jquery-link add-css search-site>,
	:add-css<pop-search-bar.css pop-search-bar-light.css pop-search-bar-dark.css>,
	:jquery-link(
		['src="https://rawgit.com/farzher/fuzzysort/master/fuzzysort.js"', 1],
		['src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
			integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU="
			crossorigin="anonymous"', 1],
	),
	:compare-ignore(<pop-search-bar.js pop-search-extended.js>),
)