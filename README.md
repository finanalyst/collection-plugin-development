# Development of Collection Plugins
>
## Table of Contents
[Introduction](#introduction)  
[Collection plugin specification](#collection-plugin-specification)  
[Collection plugin tests](#collection-plugin-tests)  
[Collection utilities](#collection-utilities)  
[add-collection-plugin](#add-collection-plugin)  
[modify-collection-plugin](#modify-collection-plugin)  
[test-all-collection-plugins](#test-all-collection-plugins)  
[sub map-to-repo( :$from = '../raku-collection-plugins', :$to = 'lib', :$format = 'html' )](#sub-map-to-repo-from--raku-collection-plugins-to--lib-format--html-)  
[Naming of released plugin](#naming-of-released-plugin)  
[Collection plugin management system](#collection-plugin-management-system)  
[Currently](#currently)  

----
# Introduction
The `Collection` module makes extensive use of plugins. They need developing and maintaining.

The intention is for this distribution (Collection-Plugin-Development) to be associated with the repository for the files to develop plugins, and the current working copies of plugins.

Another repository (Collection-Plugins) will be the source for published / released Collection plugins.

So, the work flow is

*  new plugins are added, modified, developed in `Collection::Plugins`

*  modified plugins are prepared for release & pushed to Collection::Plugins repo

*  a release is created in git with new plugins

*  a utility in Collection checks for new releases and downloads them, and refreshes a current collection

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

*  The `config.raku` must contain the following keys

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

				*  if it has a Str value and the key `:generate` does NOT contain `custom-raku` then the Str value should

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

	*  `version`. This point to a Str in the format \d+\.\d+\.\d+ which matches the semantic version conventions.

	*  `auth`. This points to a Str that is consistent with the Raku 'auth' conventions.

	*  `license`. Points to a SPDX license type.

	*  `authors`. This points to a sequence of names of people who are the authors of the plugin.

	*  _Other key names_. If other keys are present, they must point to filenames in the current directory.

	*  `information`. This key does not need to exist.

		*  If it exists, then it must contain the names of other keys.

		*  If a key named in the `:information` list contains a Str, the filename will NOT exist in the plugin directory, but will be generated by the plugin itself, or is used as information by the plugin.

		*  This config key is intended only for plugin testing purposes.

# Collection plugin tests
This distribution contains the module `Test::CollectionPlugins` with a single exported subroutine `plugin-ok`. This subroutine verifies that the plugin rules are kept for the plugin.

Additional plugin specific tests should be included.

# Collection utilities
Three utilities are provided to add a new plugin, modify an existing plugin's config file (eg. change the version number, and run the tests of all plugins.

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
This utility is intended to modify an existing plugin's config file, such as adding defaults if they are missing. To get a list of default attributes use

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
To get help

```
modify-collection-plugin-config -help
```
## test-all-collection-plugins
All plugins must have a `t/` directory and one test file. This utility runs all the test files of all the plugins, returning only minimal information if the tests pass, but more information if a test fails.

## sub map-to-repo( :$from = '../raku-collection-plugins', :$to = 'lib', :$format = 'html' )
Moves plugins that have a new version/author to released directory

# Naming of released plugin
The name of a working plugin must match `/^ <.alpha> <[\w] + [\-] - [\_]>+ $ /`.

If a plugin `my-plug` has a config file with `:version<1.2.3>, :auth<collection> `, then the released name will be

```
my-plug_v1_auth_collection
```
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

	*  all the latest versions for each Format/Name/Version/Auth are downloaded.

	*  a symlink is generated (or if the OS does not allow symlink, the whole directory is copied) from the released version to the directory where each mode expects its plugins to be located.

To implement this system

*  Each Collection root directory (the directory containing the topmost `config.raku` file) will contain the file `plugin.conf`.

*  The plugin management tool (PMT)

	*  runs through the plugins-required

	*  for each distinct plugin verifies whether

		*  the plugin has an entry in `plugin.conf`, in which case

			*  the PMT maps the released plugin name/auth/ver to the plugin-required name using the rules of `plugin.conf` as given below

		*  the released version matches the plugin version (the full major.minor.patch version)

	*  if a released version has larger minor/patch values, then the new directory is linked (copied) to the Mode's plugin name

The file `plugin.raku` contains a hash with the following keys:

*  `collection-plugin-root` This contains the name of a directory reachable from the Collection root directory with the released plugins are downloaded.

*  Every other toplevel key is interpreted as a Mode. It will point to a hash with the keys:

	*  `FORMAT` Each mode may only contain plugins from one Format, eg., _html_.

	*  This implies that a _Mode_ may not be named `FORMAT`.

	*  Every other key at this level (meaning within the hash for a Mode and not FORMAT) must be a plugin name contained in the Mode's plugins-required configuration.

	*  There may be zero other keys at this level

	*  If a plugin in the plugins-required configuration list does not have an entry at this level, then the values for that plugin are the defaults.

	*  If a key exists, it must point to a Hash, which must contain at least one of the following keys

		*  Name => the name of the plugin

			*  the default name is the plugin-required's name

			*  if a different name is given, a released plugin is mapped to the required directory in the mode sub-directory

		*  Major => the major number preceeded by 'v'

			*  the default value is the greatest released major value

			*  A Major value is the maximum Major version permitted, thus freezing at that version

		*  Auth => the auth value

			*  the default value is 'collection'

	*  If there is no distributed plugin for a specified `auth`, then an error is thrown.

Some examples:

*  The Raku-Collection-Raku-Documentation, Website mode, requires the plugin `Camelia`. The plugin exists as a HTML format. It has version 1.0.0, and an auth 'collection'. It is distributed as `html/camelia_v_1_auth_collection`. Suppose a version with a new API is created. Then two versions of the plugin will be distributed, including the new one `html/camelia_v_2_auth_collection`.

If no key for camelia is in the hash for mode Website, then the defaults will be implimented and a link (or copy) will be made between the released directory `html/camelia_auth_collection__ver_2` and `Website/plugins/camelia`

*  If plugin.conf contains the following: `Website =` %( :FORMA"> \{\{\{ contents }}}

, :camelia( %( :major(1), ) ) > then the link will be between `html/camelia_auth_collection__ver_1` and `Website/plugins/camelia`

*  Suppose there is another valid `auth` string **raku-dev** and there is a distributed plugin _html/camelia_auth_raku-dev__ver_2_, and suppose `plugin.conf` contains the following: `Website =` %( :FORMA"> \{\{\{ contents }}}

, :camelia( %( :auth<raku-dev>, ) ) > then the link will be made between `html/camelia_auth_raku-dev__ver_2` and `Website/plugins/camelia`

*  Suppose a different icon is developed called `new-camelia` by `auth` **raku-dev**, then the plugin.conf file may contain the following: `Website =` %( :FORMA"> \{\{\{ contents }}}

, camelia( %( :name<new-camelia>, :auth<raku-dev>, ) ) > then a link (copy) is made between `html/new-camelia_auth_raku-dev__ver_2` and `Website/plugins/camelia`

	*  Note how the auth must be given for a renaming if there is not a `collection` version of the plugin

# Currently
The 'clean' directory structure is

*  raku-collection-plugins/ # the root of the module

	*  lib/plugins/html # location of plugin data

	*  resources/ # a directory for the Module

	*  trial/ # the directory in which testing is run

		*  raku-docs/ # a small collection of Raku documentation docs

		*  Website/ # the directory containing the website mode configuration/plugins

			*  plugins/ # a link pointing to /lib/html/plugins

			*  structure-sources/collections-examples.rakudoc # demo file for all user-facing plugins

		*  config.raku # the configuration file for trial/Website/

	*  add-new-plugin # adds a new plugin

	*  test-plugins # tests each plugin and the templates

	*  updateCSS # a bash file to run SCSS files in selected plugins

The workflow is for changes to be made in Website, run Raku-Doc, inspect the result in `localhost:3000`, and iterate.







----
Rendered from README at 2022-09-06T20:15:57Z