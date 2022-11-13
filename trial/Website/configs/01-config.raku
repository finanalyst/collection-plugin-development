%(
    :mode-sources<structure-sources>, # content for the website structure
    :mode-cache<structure-cache>, # cache for the above
    :mode-ignore( 'custom-ui.rakudoc', ), # no files to ignore
    :mode-obtain(), # not a remote repository
    :mode-refresh(), # ditto
    :mode-extensions<rakudoc pod6>, # only use these for content
    :no-code-escape, # must use this when using highlighter
    :external-highlighter, # do not use build time highlighting, as browser side is expected
    :destination<../rendered_html>, # where the html files will be sent relative to Mode directory
    :asset-out-path<assets>, # where the image assets will be sent relative to destination
    :landing-place<collection-examples>, # the first file
    :report-path<reports>,
    :output-ext<html>,
    :templates<templates>,
    completion-options => %(
        :port<30000>,
        :host<0.0.0.0>,
    ),
)