%(
    :plugins<plugins>,
    :plugin-format<html>,
    plugins-required => %(
        :setup<raku-doc-setup>,
        :render<
            ogdenwebb website camelia simple-extras listfiles images font-awesome filterlines
            leafletmap graphviz latex-render secondaries
            link-error-test
            gather-js-jq gather-css
        >,
        :report<link-plugin-assets-report>,
        :transfer<secondaries gather-js-jq gather-css images>,
        :compilation<secondaries website listfiles link-error-test>,
        :completion<cro-app>,
    ),
)