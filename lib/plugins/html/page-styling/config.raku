%(
	:auth<collection>,
	:authors(
		"finanalyst",
		"ogdenwebb",
		"altai-man",
	),
	:custom-raku(),
	:license<Artistic-2.0>,
	:name<page-styling>,
	:render<move-images.raku>,
	:template-raku<page-styling.raku>,
	:error-report,
	:version<0.1.2>,
	:add-css<
		css/page-styling-main.css
		css/page-styling-dark.css css/page-styling-light.css
	>, # order of css files is important
	:jquery( ['page-styling.js', 3], ),
	:information<add-css jquery>,
)