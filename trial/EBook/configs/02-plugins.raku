%(
    :plugins<plugins>,
    :plugin-format<xhtml>,
    plugins-required => %(
        :setup<raku-doc-setup>,
        :render<
            hiliter
            ebook-embed
            font-awesome rakudoc-table
            camelia
            generated
            gather-css
        >,
        :report<link-plugin-assets-report>,
        :transfer<gather-css raku-doc-setup ebook-embed>,
        :compilation<ebook-embed>,
        :completion<ebook-embed>,
    ),
)