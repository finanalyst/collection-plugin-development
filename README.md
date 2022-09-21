# Development of Collection Plugins
>
## Table of Contents
[Introduction](#introduction)  
[Collection plugin specification](#collection-plugin-specification)  
[Collection plugin tests](#collection-plugin-tests)  
[Collection-Plugin-Development utilities](#collection-plugin-development-utilities)  
[add-collection-plugin](#add-collection-plugin)  
[modify-collection-plugin](#modify-collection-plugin)  
[test-all-collection-plugins](#test-all-collection-plugins)  
[sub prepare-plugins( :$from = '../raku-collection-plugins', :$to = 'lib', :$format = 'html' )](#sub-prepare-plugins-from--raku-collection-plugins-to--lib-format--html-)  
[Naming of released plugin](#naming-of-released-plugin)  
[Collection plugin management system](#collection-plugin-management-system)  
[System implementation](#system-implementation)  
[Specification of manifest.rakuon file](#specification-of-manifestrakuon-file)  
[Currently](#currently)  

----
# Introduction
The `Collection` module makes extensive use of plugins. They need developing and maintaining.

The intention is for this distribution (Collection-Plugin-Development) to be associated with the repository for the files to develop plugins, and the current working copies of plugins.

Another repository (Collection-Plugins) is the source for published / released Collection plugins.

So, the work flow is

*  new plugins are added, modified, developed in `Collection::Plugins`

*  modified plugins are prepared for release & pushed to Collection::Plugins using

```
prepare-plugins
```
It can be called with

*  `-repo` pointing to where the released plugins are kept. The default is `-repo=~/.local/share/Collection` and

*  `-origin` pointing to where the working versions of plugins are kept. The default is `-origin=lib`

Alternatively

```
prepare-plugins :rebuild
```
This creates a `manifest.rakuon` file in the `-repo` default.

The program can be called with `-repo` as specified above.

The program

*  creates a manifest.rakuon file in the root of `:repo`.

*  creates a release version for new / changed plugins in `:repo`

It is left to the developer to git add/commit/push the files.

# Collection plugin specification
All Collection plugins must conform to the following rules

*  The plugin name must:

	*  start with a letter

	*  followed by at least one \w or \-

	*  not contain \_ or \.

	*  thus a name matches / <alpha> <[\w] + [\-] - [\_]>+ /

*  The plugin directory contains

	*  `config.raku`, which is a file that evaluates to a Raku hash.

	*  README.rakudoc

	*  t/01-basic.rakutest

*  The `config.raku` file must contain the following keys

	*  `name`. This is the released name of the plugin. It will be possible for a new plugin to have the same functionality as another, while extending or changing the output. For more detail, see [Collection plugin management system](Collection plugin management system.md). Typically, the name of the plugin will match the name of the sub-directory it is in.

	*  `version`. This point to a Str in the format \d+\.\d+\.\d+ which matches the semantic version conventions.

	*  `auth`. This points to a Str that is consistent with the Raku 'auth' conventions.

	*  `license`. Points to a SPDX license type.

	*  `authors`. This points to a sequence of names of people who are the authors of the plugin.

	*  one or more of `render setup report compilation completion`

		*  If render then

			*  the render key may be a boolean

			*  or the render key is a Str which must

				*  be a filename in the directory

				*  be a raku program that evaluated to a callable

				*  the callable has a signature defined for render callables

			*  the key `custom-raku`

				*  must exist

				*  must either be empty, viz. `custom-raku()`

				*  or must have a Str value

				*  if it has a Str value and the key `:information` does contain `custom-raku` then it is treated as if `custom-raku` is empty

				*  if it has a Str value and the key `:information` does NOT contain `custom-raku` then the Str value should

					*  point to a file name in the current directory

					*  and the filename should contain a Raku program that evaluates to an Array.

			*  the key `template-raku`

				*  must exist

				*  must either be empty, viz. `template-raku()`

				*  or must have a Str value

				*  if it has a Str value and the key `:information` does contain `template-raku` then it is treated as if `template-raku` is empty

				*  if it has a Str value and the key `:information` does NOT contain `template-raku` then the Str value should

					*  point to a file name in the current directory

					*  and the filename should contain a Raku program that evaluates to a Hash.

		*  If not render, then the value must point to a Raku program and evaluate to a callable.

	*  _Other key names_. If other keys are present, they must point to filenames in the current directory.

	*  `information`. This key does not need to exist.

		*  If it exists, then it must contain the names of other keys.

		*  If a key named in the `:information` list contains a Str, the filename will NOT exist in the plugin directory, but will be generated by the plugin itself, or is used as information by the plugin.

		*  This config key is intended only for plugin testing purposes.

# Collection plugin tests
This distribution contains the module `Test::CollectionPlugins` with a single exported subroutine `plugin-ok`. This subroutine verifies that the plugin rules are kept for the plugin.

Additional plugin specific tests should be included.

# Collection-Plugin-Development utilities
Three utilities are provided to add a new plugin, modify an existing plugin's config file (eg. change the version number), run the tests of all plugins, and prepare plugins for release

Each utility assumes the plugin directory is at `lib/<format>/plugins`, where the default format is `html`. An example of another format would be `markdown`.

## add-collection-plugin
The utility adds the necessary files (config.raku, README, a test file, and callables) for a milestone.

Only a plugin name (eg. my-new-plugin) is required, and a new html format plugin with a `render` milestone is set up. Eg.

```
add-collection-plugin my-new-plugin
```
An error will be shown if an existing plugin with the same name is present in the `lib/html/plugins` directory.

The config file will have the defaults of the other mandatory keys. See `modify-collection-plugin-config` for how to get the defaults.

For different milestones set the option `-mile` to the milestone name and a callable stub is also created.

```
add-collection-plugin -mile=setup my-new-plugin
```
The `-mile` option can take a list of milestones and form stubs for each, eg.

```
add-collection-plugin -mile='setup render compilation' my-new-plugin
```
If a new format is being developed, then set `-format` to the chosen format name, eg `markdown`. A plugin will then be added to `lib/markdown/plugins`. Eg. (for the default -mile=render)

```
add-collection-plugin -format=markdown my-new-markdown-plugin
```
## modify-collection-plugin
This utility is intended to modify an existing plugin's config file, such as adding defaults if they are missing.

The utility cannot be used to modify a plugin's `name` key. It will add the directory name if a name key is missing.

To get a list of default attributes use

```
modify-collection-plugin-config -show-defaults
```
To modify a plugin specify the name with the option -plugin, eg.

```
modify-collection-plugin-config -plugin=an-existing-plugin -defaults
```
The plugin will be given defaults to all mandatory attributes, unless they already exist, in which case they are not changed.

To modify a specific attribute for a plugin use, for example,

```
modify-collection-plugin-config -plugin=an-existing-plugin -version=0.1.2
```
To bumps a plugin's _patch_ version number, use

```
modify-collection-plugin-config -plugin=an-existing-plugin -bump
```
To modify the _Major_ and _Minor_ numbers use the `-version` option

To get help

```
modify-collection-plugin-config -help
```
## test-all-collection-plugins
All plugins must have a `t/` directory and one test file. This utility runs all the test files of all the plugins, returning only minimal information if the tests pass, but more information if a test fails.

## sub prepare-plugins( :$from = '../raku-collection-plugins', :$to = 'lib', :$format = 'html' )
The subroutine

*  Moves plugins that have a new version/author to release directory.

*  Verifies that there are no files in a working plugin directory that have newer content than in a release directory.

*  Issues a suggestion to bump version if there is newer content.

*  creates a file `manifest.rakuon` in the release directory (see later for specification of files).

# Naming of released plugin
The name of a working plugin must match `/^ <.alpha> <[\w] + [\-] - [\_]>+ $ /`.

If a plugin `my-plug` has a config file with `:version<1.2.3>, :auth<collection> `, then the released name will be **my-plug_v1_auth_collection**

# Collection plugin management system
It is planned to have GUI and a command line manager.

The local computer may contain

*  More than one collection, eg. a personal website and a Raku documentation collection

*  Each Collection may have more than one Mode, eg., a HTML website, an epub producer.

*  A collection/mode combination may rely on a previous API of a plugin, which may be broken by a later API.

*  A new plugin may have been written as a drop-in replacement for an older version, and the new plugin may have a different name, or auth, or version.

So a plugin manager (whether command line or GUI) must be compliant with the following system:

*  There is a _release_ directory to contain all Collection plugins, probably a clone of the github repository.

*  The semantic versioning scheme is mandated for Collection plugins. A version is `v<major>.<minor>,<patch>`. Changes at the `<patch> ` level do not affect the plugin's functionality. Changes at the `<minor> ` level introduce new functionality, but are backward compatible. Changes at the `<major> ` level break backward compatibility.

*  Each distributed plugin is contained in the release directory in a subdirectory named by the plugin name, the auth field, and the major version number (minor and patch numbers are not included because they should not by definition affect the API).

*  Each Mode configuration only contains the name of the plugin (without the auth, or version names).

*  The developer may define which name/version/auth of a released plugin is to be mapped to the plugin required in the Mode configuration. Thus

	*  changes in API can be frozen to earlier versions of the plugin for some concrete Mode.

	*  different plugin versions can be used for different collection/modes

	*  a differently named plugin can be mapped to a plugin required by a specific collection/mode.

*  Consequently, all released plugins are defined for

	*  a Format (eg. html)

	*  a Major version

	*  an Auth name

*  The mapping information from a released plugin to a Mode is contained in a file in the root of a Collection.

*  When the plugins are updated

	*  all the latest versions for each _relevant_ Format/Name/Version-Major/Auth are downloaded.

	*  a symlink is generated (or if the OS does not allow symlink, the whole directory is copied) from the released version to the directory where each mode expects its plugins to be located.

	*  The meaning of _relevant_ is determined by the PMS. It could be all plugins in the github repository, or only those needed by a specific Collection, or set of Collections.

## System implementation
Each Collection root directory (the directory containing the topmost `config.raku` file) will contain the file `plugins.rakuon`.

*  The plugin management tool (PMT)

	*  runs through the plugins-required

	*  for each distinct plugin verifies whether

		*  the plugin has an entry in `plugins.rakuon`, in which case

			*  the PMT maps the released plugin name/auth/ver to the plugin-required name using the rules of `plugins.rakuon` as given below

		*  the released version matches the plugin version (the full major.minor.patch version)

	*  if a released version has larger minor/patch values, then the new directory is linked (copied) to the Mode's plugin name

The file `plugins.rakuon` contains a hash with the following keys:

*  `METADATA`. Contains a hash with data for the `refresh` functionality.

	*  `collection-plugin-root` This contains the name of a directory reachable from the Collection root directory with the released plugins are downloaded.

	*  `update-behaviour` Defines what happens when a new released plugin has an increased Major number. Possible values are:

		*  _auto_ All relevant plugin names are updated to the new version, a message is issued

		*  _conserve_ Plugins are not updated to the new version, a warning is issued, updating is then plugin by plugin with a `-force` flag set.

*  Every other toplevel key is interpreted as a Mode. It will point to a hash with the keys:

	*  `_mode_format` Each mode may only contain plugins from one Format, eg., _html_.

	*  By the plugin naming rules, a _plugin_ may not be named `_mode_format`.

	*  In a file with sorted keys, `_mode_format` will come first.

	*  Every other key in a mode hash must be a plugin name contained in the Mode's plugins-required configuration.

	*  There may be zero plugin keys

	*  If a plugin in the plugins-required configuration list does not have an entry at this level, then it has not been mapped to a sub-directory of the `released-directory`.

	*  A plugin key that exists must point to a Hash, which must at least contain:

		*  mapped => the name of the released plugin

	*  The plugin hash may also point to one or more of:

		*  name => the name of the alternate released plugin

			*  the default name (if the key is absent) is the plugin-required's name

			*  if a different name is given, a released plugin is mapped to the required directory in the mode sub-directory

		*  major => the major number preceeded by 'v'

			*  the default value (if the key is absent) is the greatest released major value

			*  A major value is the maximum major value of the full version permitted, thus freezing at that version

		*  auth => the auth value

			*  the default value (if the key is absent) is 'collection'

	*  If there is no distributed plugin for a specified `auth | major | name `, then an error is thrown.

Some examples:

*  The Raku-Collection-Raku-Documentation, Website mode, requires the plugin `Camelia`. The plugin exists as a HTML format. It has version 1.0.0, and an auth 'collection'. It is distributed as `html/camelia_v1_auth_collection`. Suppose a version with a new API is created. Then two versions of the plugin will be distributed, including the new one `html/camelia_v2_auth_collection`.

If the key for camelia in the hash for mode Website only contains an empty `version` key, then the defaults will be implied and a link (or copy) will be made between the released directory `html/camelia_v2_auth_collection` and `Website/plugins/camelia`

*  If plugins.rakuon contains the following: `Website =` %( :FORMA"> \{\{\{ contents }}}

, :camelia( %( :major(1), ) ) > then the link will be between `html/camelia_v1_auth_collection` and `Website/plugins/camelia`

*  Suppose there is another valid `auth` string **raku-dev** and there is a distributed plugin _html/camelia_v2_auth_raku-dev_, and suppose `plugins.rakuon` contains the following: `Website =` %( :FORMA"> \{\{\{ contents }}}

, :camelia( %( :auth<raku-dev>, ) ) > then the link will be made between `html/camelia_v2_auth_raku-dev` and `Website/plugins/camelia`

*  Suppose a different icon is developed called `new-camelia` by `auth` **raku-dev**, then `plugins.rakuon` may contain the following: `Website =` %( :FORMA"> \{\{\{ contents }}}

, camelia( %( :name<new-camelia>, :auth<raku-dev>, ) ) > then a link (copy) is made between `html/new-camelia_v2_auth_raku-dev` and `Website/plugins/camelia`

	*  Note how the auth must be given for a renaming if there is not a `collection` version of the plugin

# Specification of manifest.rakuon file
`manifest.rakuon` evaluates to a Hash.

The keys of the Hash match the directory structure until the plugin names. Then there is a full version number. For example,

```
%( plugins => %(
    html => %(
        camelia_V0_auth_collection => %(
            version => '0.1.0'
        ),
    ),
)
```
# Currently
The 'clean' directory structure is

*  plugins-for-release/ # the directory / repository for released plugins

	*  lib/plugins # location of operating plugins

	*  trial/ # the directory in which testing is run

		*  raku-docs/ # a small collection of Raku documentation docs

		*  Website/ # the directory containing the website mode configuration/plugins

			*  plugins/ # a link pointing to /lib/plugins + format

			*  structure-sources/collections-examples.rakudoc # demo file for all user-facing plugins

		*  config.raku # the configuration file for trial/Website/

	*  bin/add-new-plugin # adds a new plugin

	*  bin/test-all-collection-plugins # tests each plugin and the templates

	*  bin/prepare-plugins # moves plugins from operating directory to release directory

	*  updateCSS # a bash file to run SCSS files in selected plugins

The workflow is for changes to be made in Website, run Raku-Doc, inspect the result in `localhost:3000`, and iterate.







----
Rendered from README at 2022-09-21T20:51:19Z