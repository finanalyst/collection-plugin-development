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
            link-error-test
            camelia simple-extras listfiles images deprecate-span filterlines
            secondaries typegraph generated
            leafletmap latex-render graphviz
            gather-js-jq gather-css sitemap
        >,
        :report<link-plugin-assets-report sitemap>,
        :transfer<secondaries gather-js-jq gather-css images raku-doc-setup options-search>,
        :compilation<secondaries listfiles link-error-test options-search>,
        :completion<cro-app>,
    ),
)