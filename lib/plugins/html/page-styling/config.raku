%(
	:auth<collection>,
	:authors(
		"finanalyst"
	),
	:custom-raku(),
	:license<Artistic-2.0>,
	:name<page-styling>,
	:render<move-images.raku>,
	:template-raku<page-styling.raku>,
	:version<0.1.3>,
	:add-css<
		css/page-styling-main.css
		css/page-styling-dark.css css/page-styling-light.css
	>, # order of css files is important
	:jquery( ['page-styling.js', 3], ),
	:information<add-css jquery>,
)