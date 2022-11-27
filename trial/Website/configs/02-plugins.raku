%(
    :plugins<plugins>,
    :plugin-format<html>,
    plugins-required => %(
        :setup<raku-doc-setup>,
        :render<
            raku-styling website camelia simple-extras listfiles images font-awesome filterlines
            leafletmap graphviz latex-render
            link-error-test
            gather-js-jq gather-css
        >,
        :report<link-plugin-assets-report>,
        :transfer<gather-js-jq gather-css images>,
        :compilation<website listfiles link-error-test>,
        :completion<cro-app>,
    ),
)