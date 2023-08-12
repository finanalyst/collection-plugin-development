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
	:version<0.1.5>,
	:add-css<
		css/page-styling-main.css
		css/page-styling-dark.css css/page-styling-light.css
		css/wordSwitch-dark.css css/wordSwitch-light.css
		css/wordToggle-dark.css css/wordToggle-light.css
	>, # order of css files is important
	:jquery( ['page-styling.js', 3], ),
	:information<add-css jquery>,
)