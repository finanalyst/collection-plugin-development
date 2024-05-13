%(
    :plugins<plugins>,
    :plugin-format<html>,
    plugins-required => %(
        :setup<raku-doc-setup>,
        :render<
            hiliter font-awesome tablemanager
            page-styling
            options-search
            announcements
            filtered-toc
            rakudoc-table
            link-error-test
            camelia simple-extras listfiles images deprecate-span filterlines
            secondaries typegraph generated sqlite-db
            leafletmap latex-render graphviz
            website
            gather-js-jq gather-css sitemap
        >,
        :report<link-plugin-assets-report sitemap>,
        :transfer<secondaries gather-js-jq gather-css
            images raku-doc-setup options-search sqlite-db
            announcements announcements>,
        :compilation<secondaries listfiles link-error-test options-search website sqlite-db>,
        :completion<cro-app>,
    ),
)