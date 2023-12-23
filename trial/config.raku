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
    :no-refresh, # call refresh step even after the initiation
    :no-preserve-state,# do not archive
    :!recompile, # if true, force a recompilation of the source files when refresh is called
    :!full-render, # force rendering of all output files
    :!without-processing,
    :mode<Website>, # the default mode, which must exist
    :ignore(),
    :extensions< rakudoc pod pod6 p6 pm pm6 >,
    :asset-basename<asset_base>,
    :asset-paths( %( # type of asset is key, then metadata for that type
        image => %(
            :directory<images>,
            :extensions<png jpeg jpeg svg mp4 webm gif>,
        ),
    )),
    :with-only(q:to/SAMPLE/), # constrain test run
        language/101-basics
        language/5to6-nutshell
        language/classtut
        language/control
        language/faq
        language/functions
        language/glossary
        language/grammars
        language/operators
        language/rb-nutshell
        language/regexes
        language/structures
        language/unicode_entry
        language/variables
        native/int
        programs/01-debugging
        programs/02-reading-docs
        type/Attribute
        type/BagHash
        type/Baggy
        type/CallFrame
        type/Signature
        type/Str
        type/X/Proc/Unsuccessful
        type/X/Syntax/Regex/SolitaryQuantifier
        type/independent-routines
        404 index reference
        about introduction routines test
        error-report license miscellaneous types.rakudoc
        SAMPLE
)