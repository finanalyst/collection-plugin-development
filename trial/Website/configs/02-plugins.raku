%(
    no-code-escape => True, # must use this when using highlighter
    plugins => 'plugins',
    plugins-required => %(
        :setup<raku-doc-setup>,
        :render<
            raku-styling website camelia simple-extras listfiles images font-awesome filterlines
            leafletmap graphviz latex-render
            gather-js-jq gather-css
        >,
        :transfer<gather-js-jq gather-css>,
        :report(),
        :compilation<website listfiles>,
        :completion<cro-app>,
    ),
)