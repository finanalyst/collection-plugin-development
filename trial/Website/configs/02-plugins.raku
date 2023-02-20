%(
    :plugins<plugins>,
    :plugin-format<html>,
    plugins-required => %(
        :setup<raku-doc-setup credits-page git-reflog>,
        :render<
            font-awesome tablemanager ogdenwebb
            website camelia simple-extras listfiles images deprecate-span filterlines
            secondaries typegraph search-bar
            leafletmap latex-render graphviz
            link-error-test git-reflog
            gather-js-jq gather-css
        >,
        :report<link-plugin-assets-report>,
        :transfer<secondaries gather-js-jq gather-css images search-bar>,
        :compilation<secondaries listfiles link-error-test search-bar>,
        :completion<cro-app>,
    ),
)