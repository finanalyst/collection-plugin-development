use v6.d;
use RakuConfig;

unit module RefreshPlugins;

multi sub MAIN {
    # test whether there is a config.raku in the current directory
    my %config;
    try {
        %config = get-config;
        CATCH {
            default {
                exit note("Trying to access ｢config.raku｣ in ｢$*CWD｣ but got " ~ .message)
            }
        }
    }
    # so there is a config.raku file. Now is there a plugins.conf file
    my %plugins;
    try {
        %plugins = get-config(:path<plugins.conf>);
        CATCH {
            when RakuConfig::NoFiles {
                note("Creating ｢plugins.conf｣ in ｢$*CWD｣");
                %plugins = make-plugin-conf;
                .resume
            }
            default {
                exit note("Trying to access ｢plugins.conf｣ in ｢$*CWD｣ but got " ~ .message)
            }
        }
    }

}
sub make-plugin-conf(--> Associative) {
    my %pc;
    # create plugins conf from each of the sub-directories, which are Mode directories
    my @modes = dir>>.Str;
    for @modes -> $mode {
        my %config;
        try {
            %config = get-config(:path<<$mode/configs>>, :required<plugins plugin-format plugins-required> );
            CATCH {
                default { exit note("Trying to access Mode ｢$mode/configs｣, but got " ~ .message) }
            }
        }
    }
}