%(
    :plugins<plugins>,
    :plugin-format<html>,
    plugins-required => %(
        :setup('raku-doc-setup', ),
        :render<
            hiliter font-awesome tablemanager
            page-styling #sidebar-search
            #ogdenwebb
            search-bar
            filtered-toc
            rakudoc-table
            camelia simple-extras listfiles images deprecate-span filterlines
            secondaries typegraph generated
            leafletmap latex-render graphviz
            link-error-test
            gather-js-jq gather-css
        >,
        :report<link-plugin-assets-report>,
        :transfer<secondaries gather-js-jq gather-css images #sidebar-search search-bar raku-doc-setup>,
        :compilation<secondaries listfiles link-error-test #sidebar-search search-bar>,
        :completion<cro-app>,
    ),
)