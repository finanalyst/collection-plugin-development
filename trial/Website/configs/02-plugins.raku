%(
    :plugins<plugins>,
    :plugin-format<html>,
    plugins-required => %(
        :setup<raku-doc-setup>,
        :render<
            hiliter font-awesome tablemanager
            page-styling
            options-search
            filtered-toc
            rakudoc-table
            camelia simple-extras listfiles images deprecate-span filterlines
            secondaries typegraph generated
            leafletmap latex-render graphviz
            gather-js-jq gather-css
        >,
        :report<link-plugin-assets-report>,
        :transfer<secondaries gather-js-jq gather-css images raku-doc-setup options-search>,
        :compilation<secondaries listfiles options-search>,
        :completion<cro-app>,
    ),
)