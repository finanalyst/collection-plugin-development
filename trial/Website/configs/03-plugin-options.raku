%(
    plugin-options => %(
        cro-app => %(
            :port<5000>,
            :host<0.0.0.0>,
            :url-map<assets/prettyurls>,
        ),
        link-error-test => %(
            :no-remote,
            :run-tests,
        ),
        ogdenwebb => %(
            :!extended-search,
            :error-report,
        ),
        raku-repl => %(
            :websocket-host<finanalyst.org>,
            :websocket-port<443>,
        ),
        search-bar => %(
            :search-site<new-raku.finanalyst.org>,
        )
    ),
)