%(
    :plugins<plugins>,
    :plugin-format<html>,
    plugins-required => %(
        :setup('raku-doc-setup', ),
        :render<
            hiliter font-awesome tablemanager page-styling
            camelia simple-extras listfiles images deprecate-span filterlines
            secondaries typegraph generated
            filtered-toc
            leafletmap latex-render graphviz
            link-error-test
            gather-js-jq gather-css
        >,
        :report<link-plugin-assets-report>,
        :transfer<secondaries gather-js-jq gather-css images>,
        :compilation<secondaries listfiles link-error-test>,
        :completion<cro-app>,
    ),
)