%(
    :plugin-format<html>,
    :plugins<plugins>,
    plugins-required => %(
        :setup<raku-doc-setup>,
        :render<
            raku-styling website camelia simple-extras listfiles images font-awesome filterlines
            leafletmap graphviz latex-render
            link-error-test
            gather-js-jq gather-css
        >,
        :transfer<gather-js-jq gather-css>,
        :report(),
        :compilation<website listfiles link-error-test>,
        :completion<cro-app>,
    ),
)