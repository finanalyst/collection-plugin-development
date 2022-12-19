# Change log for the Collection-Plugins module
>
## Table of Contents
[2022-08-09 v0.0.2](#2022-08-09-v002)  
[2022-08-11 v0.0.3](#2022-08-11-v003)  
[2022-08-14 v0.0.4](#2022-08-14-v004)  
[2022-08-14 v0.0.5](#2022-08-14-v005)  
[2022-08-30 v0.0.6](#2022-08-30-v006)  
[2022-09-04 v0.0.7](#2022-09-04-v007)  
[2022-09-05 v0.1.0](#2022-09-05-v010)  
[2022-09-08 v0.1.1](#2022-09-08-v011)  
[2022-09-08 v0.1.2](#2022-09-08-v012)  
[2022-09-16 v0.2.0](#2022-09-16-v020)  
[2022-09-23 v0.3.0](#2022-09-23-v030)  
[2022-10-31 v0.4.0](#2022-10-31-v040)  
[2022-11-27 v0.4.1](#2022-11-27-v041)  
[2022-12-13 v0.4.2](#2022-12-13-v042)  
[2022-12-21 v0.4.3](#2022-12-21-v043)  

----
# 2022-08-09 v0.0.2
*  First structural draft.

*  got `LeafletMap` to work

*  added ordering logic to `gather-js`

# 2022-08-11 v0.0.3
*  move plugins to lib/html

*  create symlink to trial/Website

*  remove Website from root

*  new Graphviz plugin

# 2022-08-14 v0.0.4
*  new para quotation plugin

*  remove Graphiz example from TOC

# 2022-08-14 v0.0.5
*  new Latex plugin, uses CodeCogs online facility

*  add-plugin generates README.rakudoc, not .pod6

*  Add Test::CollectionPlugin to simplify testing plugins

*  add transfer callables since Collection changed

# 2022-08-30 v0.0.6
*  completed Test::CollectionPlugin

*  added tests for Test::CollectionPlugin

# 2022-09-04 v0.0.7
*  added add-collection-plugin utility

*  added modify-collection-plugin-config utility

*  added test-all-collection-plugins utility

*  added tests for add/modify utilities

*  changed README

*  eliminated errors found in existing plugins

*  change name of :generated key in config to :information

*  begin work on refresh-collection-plugins

*  implement mile as a list for modify-collection-plugins

*  added -bump option to modify-plugin

# 2022-09-05 v0.1.0
*  rename repo and module to collection-plugin-development

*  change name of path for plugins to plugin/$format

*  change plugin auth default from 'finanalyst' to 'collection', changes to README and modify-collection-plugins

*  added rule for naming of plugin, added tests to add-plugin, added to Test::CollectionPlugin

*  RefreshPlugin added

# 2022-09-08 v0.1.1
*  rename RefreshPlugins to PreparePlugins

*  add code to prepare-plugins in order to compare released and working plugins, and suggest a version bump if files are changed in the working version are later than the released version with the same version number.

*  add tests for compare code

# 2022-09-08 v0.1.2
*  add final message to AddPlugin

*  add manifest.rakon, which is a manifest of the files in the repository.

*  adding to README about manifest.rakon and changing the behaviour of the PMS

*  changing all mentions of `plugins.conf` to `plugins.rakuon`

*  changing xt/9* to only one test after removing all directories.

# 2022-09-16 v0.2.0
*  fix test broken by v0.1.2

*  add file 'manifest.rakuon' to root of released-dir in prepare-plugins

*  add functionality to prepare :rebuild makes new manifest.rakuon

*  add `name` to the list of required key in a plugin's `config.raku`

*  added colour to output of prepare plugins.

*  move all entities used in several modules to Collection::Entities

*  add Camelia images to examples

# 2022-09-23 v0.3.0
*  remove old files/directories from released plugins when deleted from working copies

# 2022-10-31 v0.4.0
*  create a new directory (default `working`) as the source for Collection-Plugins

*  change prepare-plugins to automatically create `working` by cloning from Collection-Plugins

*  if `working` exists, then git pull into directory

*  make consistent with raku-pod-render 4

# 2022-11-27 v0.4.1
*  plugin updates

# 2022-12-13 v0.4.2
*  fix error in TestOnePlug in render requirements.

# 2022-12-21 v0.4.3


*  added secondaries plugin to generate the legacy Secondary files.





----
Rendered from CHANGELOG at 2022-12-19T21:13:32Z