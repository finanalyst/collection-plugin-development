use v6.d;
%(
    :cache<doc_cache>, # location relative to collection root of cached Pod
    :sources<raku_docs/doc>, # location of sources
    #| the array of strings sent to the OS by run to obtain sources, eg git clone
    #| assumes CWD set to the directory of collection
    :source-obtain(),#<git https://github.com/Raku/doc.git raku-docs/>,
    #| the array of strings run to refresh the sources, eg. git pull
    #| assumes CWD set to the directory of sources
    :source-refresh(), #git -C raku-docs/ pull --quiet>,
    # processing options independent of Mode
    :!no-status, # show progress
    :no-refresh, # do not call the refresh step after the first run
    :no-preserve-state,# do not archive
    :!recompile, # if true, force a recompilation of the source files when refresh is called
    :!full-render, # force rendering of all output files
    :!without-processing,
    :!without-report, # do not make a report - default is False, but set True
    :!without-completion, # we want the Cro app to start
    :!collection-info, # show milestone data
    :mode<Website>, # the default mode, which must exist
    :ignore< 404 HomePage >,
    :extensions< rakudoc pod pod6 p6 pm pm6 >,
    :asset-basename<asset_base>,
    :asset-paths( %( # type of asset is key, then metadata for that type
        image => %(
            :directory<images>,
            :extensions<png jpeg jpeg svg mp4 webm gif>,
        ),
    )),
)