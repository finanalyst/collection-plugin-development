# README
>Plugins for Collection


## Table of Contents
[Tite](#tite)  
[Introduction](#introduction)  
[Currently](#currently)  

----
# TITE

Readme

# Introduction
The `Collection` module makes extensive use of plugins. They need developing and maintaining.

The intention is for this distribution to be the repository for the files to develop plugins, and as a source for completed working plugins.

A major milestone will be to have a GUI / command line utility to be distributed with `Collection` so that updates can be detected for Collection systems. It is planned for a host to have multiple Collections and multiple Modes.

# Currently
The 'clean' directory structure is

*  raku-collection-plugins/ # the root of the module

	*  resources/ # a directory for the Module

	*  Website/ # the directory containing the website mode configuration/plugins

	*  trial/ # the directory in which testing is run

		*  raku-docs/ # a small collection of Raku documentation docs

		*  config.raku # the configuration file for trial/Website/

	*  renew-site # a bash file to zip Website into resources/website

	*  sync-site # a bash file to rsync Website/ to trial/Website/

	*  updateCSS # a bash file to run SCSS files in selected plugins

The workflow is for changes to be made in Website, then to `sync-site`, `cd trial; Raku-Doc`, inspect the result in `localhost:3000`, and iterate.







----
Rendered from README at 2022-08-09T20:53:44Z