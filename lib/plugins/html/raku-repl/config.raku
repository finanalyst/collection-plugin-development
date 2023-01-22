%(
	:add-css<raku-repl.css>,
	:auth<collection>,
	:authors(
		"finanalyst",
	),
	:custom-raku(),
	:information(
		"js-script",
		"websocket-host",
		"websocket-port",
	),
	:js-script<raku-repl.js>,
	:license<Artistic-2.0>,
	:name<raku-repl>,
	:render<modify-js.raku>,
	:template-raku(),
	:transfer<cleanup.raku>,
	:version<0.1.11>,
	:websocket-host<localhost>,
	:websocket-port<35145>,
)