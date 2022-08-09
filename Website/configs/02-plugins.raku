%(
    no-code-escape => True, # must use this when using highlighter
    plugins => 'plugins',
    plugins-required => %(
        :setup<raku-doc-setup>,
        :render<
            raku-styling website camelia simple-extras listfiles images font-awesome filterlines xlink-error-test
            leafletmap
            gather-js-jq gather-css
        >,
        :report<images link-plugin-assets-report>,
        :compilation<website listfiles xlink-error-test>,
        :completion<cro-app>,
    ),
)