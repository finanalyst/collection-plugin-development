%(
	:auth<collection>,
	:authors(
		"finanalyst",
	),
	:custom-raku(),
	:license<Artistic-2.0>,
	:name<ogdenwebb>,
	:render<move-images.raku>,
	:template-raku<ogdenwebb-replacements.raku>,
	:version<0.1.0>,
	:add-css<
		css/themes/dark.css css/themes/light.css
		css/code/dark.css css/code/light.css
		css/lib/codemirror.min.css
		css/main.css
	>,
	:jq-script<
		js/core.js js/extended-search.js
		js/lib/autoComplete.min.js
		js/lib/codemirror.min.js
		js/lib/cookie.umd.min.js
		js/lib/raku-mode.js
	>,
	:information<add-css jq-script>,
)