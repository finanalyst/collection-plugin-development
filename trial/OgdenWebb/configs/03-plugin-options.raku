%(
    plugin-options => %(
        cro-app => %(
            :port<5000>,
            :host<0.0.0.0>,
        ),
        link-error-test => %(
            :no-remote,
        ),
        raku-repl => %(
            :websocket-host<finanalyst.org>,
            :websocket-port<35145>,
        ),
    ),
)