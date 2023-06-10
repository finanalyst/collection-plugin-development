%(
    :plugins<plugins>,
    :plugin-format<html>,
    plugins-required => %(
        :setup('raku-doc-setup', ),
        :render<
            font-awesome tablemanager ogdenwebb
            website camelia simple-extras listfiles images deprecate-span filterlines
            secondaries typegraph pop-search generated
            leafletmap latex-render graphviz
            link-error-test
            gather-js-jq gather-css
        >,
        :report<link-plugin-assets-report>,
        :transfer<secondaries gather-js-jq gather-css images pop-search>,
        :compilation<secondaries listfiles link-error-test pop-search>,
        :completion<cro-app>,
    ),
)