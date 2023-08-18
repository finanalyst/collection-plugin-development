%(
	:auth<collection>,
	:authors(
		"finanalyst",
		"ogdenwebb",
		"altai-man",
	),
	:custom-raku(),
	:license<Artistic-2.0>,
	:name<ogdenwebb>,
	:render<move-images.raku>,
	:template-raku<ogdenwebb-replacements.raku>,
	:error-report,
	:version<0.3.27>,
	:add-css<
		css/main.css
		css/themes/dark.css css/themes/light.css
	>, # order of css files is important
	:jquery( ['core.js', 3], ),
	:jquery-link(
		['src="https://rawgit.com/farzher/fuzzysort/master/fuzzysort.js"', 1],
	),
	:information<add-css jquery jquery-link>,
)