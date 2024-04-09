%(
    :plugins<plugins>,
    :plugin-format<xhtml>,
    plugins-required => %(
        :setup<raku-doc-setup>,
        :render<
            hiliter
            ebook-embed
            font-awesome rakudoc-table
            camelia simple-extras images
            generated
            gather-js-jq gather-css
        >,
        :report<link-plugin-assets-report>,
        :transfer<gather-js-jq gather-css images raku-doc-setup ebook-embed>,
        :compilation<ebook-embed>,
        :completion<ebook-embed>,
    ),
)