#!/usr/bin/env raku
use v6.d;
use JSON::Fast;
my @data = from-json($=finish);
my $search-order = -> $pre, $pos {
    if $pre.<category> ne 'Language' and $pos.<category> eq 'Language' { Order::More }
    elsif $pos.<category> ne 'Language' and $pre.<category> eq 'Language' { Order::Less }
    elsif $pre.<url>.contains('5to6') and ! $pos.<url>.contains('5to6') { Order::More }
    elsif $pos.<url>.contains('5to6') and ! $pre.<url>.contains('5to6') { Order::Less }
    elsif $pre.<category> ne 'Composite' and $pos.<category> eq 'Composite' { Order::More }
    elsif $pos.<category> ne 'Composite' and $pre.<category> eq 'Composite' { Order::Less }
    elsif $pre.<category> ne 'Indexed' and $pos.<category> eq 'Indexed' { Order::Less }
    elsif $pos.<category> ne 'Indexed' and $pre.<category> eq 'Indexed' { Order::More }
    elsif $pre.<category> ne 'Heading' and $pos.<category> eq 'Heading' { Order::Less }
    elsif $pos.<category> ne 'Heading' and $pre.<category> eq 'Heading' { Order::More }
    elsif $pre.<category> ne $pos.<category> { $pre.<category> leg $pos.<category> }
    else { $pre.<value> leg $pos.<value> }
}
for @data.sort( $search-order ) {
    say "Category: ", .<category>.fmt("%-12.10s"), "value: ", .<value>.fmt("%-15.10s"), "url: ", .<url>.fmt("%-30.28s")
}
=finish
[
{
    "category": "Class",
    "value": "class Metamodel::EnumHOW",
    "url": "/type/Metamodel/EnumHOW",
    "info": "<i>Metaobject representing a Raku enum.</i>"
  },
  {
    "category": "Class",
    "value": "class Uni",
    "info": "<i>A string of Unicode codepoints</i>",
    "url": "/type/Uni"
  },
  {
    "url": "/language/syntax#Single-line_comments",
    "value": "# single-line comment",
    "category": "Syntax"
  },
  {
    "value": "#` multi-line comment",
    "url": "/language/syntax#Multi-line_/_embedded_comments",
    "category": "Syntax"
  },
  {
    "value": "class X::Syntax::Comment::Embedded",
    "category": "Class",
    "url": "/type/X/Syntax/Comment/Embedded",
    "info": "<i>Compilation error due to a malformed inline comment</i>"
  },
  {
    "info": "<i>Rakudo-specific class that wraps around code in other languages (generally NQP)</i>",
    "value": "class ForeignCode",
    "url": "/type/ForeignCode",
    "category": "Class"
  },
  {
    "value": "class CallFrame",
    "category": "Class",
    "info": "<i>Captures the current frame state</i>",
    "url": "/type/CallFrame"
  },
  {
    "url": "/type/Proc/Async",
    "value": "class Proc::Async",
    "category": "Class",
    "info": "<i>Running process (asynchronous interface)</i>"
  },
  {
    "url": "/type/X/Augment/NoSuchType",
    "category": "Class",
    "info": "<i>Compilation error due to augmenting a non-existing type</i>",
    "value": "class X::Augment::NoSuchType"
  },
  {
    "category": "Language",
    "info": "<i>Functions and functional programming in Raku</i>",
    "value": "Functions",
    "url": "/language/functions"
  },
  {
    "url": "/language/list",
    "category": "Language",
    "info": "<i>Positional data constructs</i>",
    "value": "Lists, sequences, and arrays"
  },
  {
    "info": "<i>Parsing and interpreting text</i>",
    "value": "Grammars",
    "url": "/language/grammars",
    "category": "Language"
  },
  {
    "category": "Language",
    "value": "Brackets",
    "info": "<i>Valid opening/closing paired delimiters</i>",
    "url": "/language/brackets"
  },
  {
    "url": "/language/statement-prefixes",
    "info": "<i>Prefixes that alter the behavior of a statement or a set of them</i>",
    "value": "Statement prefixes",
    "category": "Indexed"
  },
  {
    "info": "<i>Learning Raku from Haskell, in a nutshell: what do I already know?</i>",
    "category": "Language",
    "value": "Haskell to Raku - nutshell",
    "url": "/language/haskell-to-p6"
  },
  {
    "url": "/language/contexts",
    "category": "Language",
    "info": "<i>What are contexts and how to switch into them</i>",
    "value": "Contexts and contextualizers"
  },
  {
    "category": "Language",
    "value": "Command line interface",
    "url": "/language/create-cli",
    "info": "<i>Creating your own CLI in Raku</i>"
  },
  {
    "category": "Language",
    "url": "/language/5to6-perlfunc",
    "info": "<i>Builtin functions in Perl to Raku</i>",
    "value": "Perl to Raku guide - functions"
  },
  {
    "value": "Perl to Raku guide - in a nutshell",
    "category": "Language",
    "info": "<i>How do I do what I used to do? (Raku in a nutshell)</i>",
    "url": "/language/5to6-nutshell"
  },
  {
    "value": "Sets, bags, and mixes",
    "info": "<i>Unordered collections of unique and weighted objects in Raku</i>",
    "category": "Language",
    "url": "/language/setbagmix"
  },
  {
    "category": "Language",
    "url": "/language/testing",
    "value": "Testing",
    "info": "<i>Writing and running tests in Raku</i>"
  },
  {
    "category": "Language",
    "value": "Native calling interface",
    "info": "<i>Call into dynamic libraries that follow the C calling convention</i>",
    "url": "/language/nativecall"
  },
  {
    "info": "<i>Operators in Perl to Raku: equivalencies and variations</i>",
    "value": "Perl to Raku guide - operators",
    "url": "/language/5to6-perlop",
    "category": "Language"
  },
  {
    "info": ": section in <b>class X::Redeclaration</b>",
    "category": "Heading",
    "url": "/type/X/Redeclaration#Methods",
    "value": "Methods"
  },
  {
    "url": "/type/X/Redeclaration#method_symbol",
    "info": ": section in <b>class X::Redeclaration</b>",
    "value": "method symbol",
    "category": "Heading"
  },
  {
    "value": "method what",
    "category": "Heading",
    "url": "/type/X/Redeclaration#method_what",
    "info": ": section in <b>class X::Redeclaration</b>"
  },
  {
    "category": "Heading",
    "info": ": section in <b>class X::Redeclaration</b>",
    "url": "/type/X/Redeclaration#method_postfix",
    "value": "method postfix"
  },
  {
    "info": ": section in <b>Module development utilities</b>",
    "category": "Heading",
    "value": "Module builder and authoring tools",
    "url": "/language/modules-extra#Module_builder_and_authoring_tools"
  },
  {
    "value": "Tests",
    "info": ": section in <b>Module development utilities</b>",
    "url": "/language/modules-extra#Tests",
    "category": "Heading"
  },
  {
    "value": "NativeCall",
    "info": ": section in <b>Module development utilities</b>",
    "url": "/language/modules-extra#NativeCall",
    "category": "Indexed"
  },
  {
    "url": "/language/modules-extra#Sample_modules",
    "value": "Sample modules",
    "category": "Heading",
    "info": ": section in <b>Module development utilities</b>"
  },
  {
    "info": "",
    "url": "/syntax/with",
    "category": "Composite",
    "value": "with"
  },
  {
    "info": "",
    "category": "Composite",
    "url": "/routine/target-name",
    "value": "target-name"
  },
  {
    "url": "/routine/block",
    "value": "block",
    "category": "Composite",
    "info": ""
  },
  {
    "url": "/routine/stderr",
    "value": "stderr",
    "category": "Composite",
    "info": ""
  },
  {
    "url": "/routine/let",
    "info": "",
    "value": "let",
    "category": "Composite"
  },
  {
    "value": "method_table",
    "info": "",
    "category": "Composite",
    "url": "/routine/method_table"
  },
  {
    "url": "/routine/chars",
    "category": "Composite",
    "info": "",
    "value": "chars"
  },
  {
    "url": "/routine/twigil",
    "category": "Composite",
    "value": "twigil",
    "info": ""
  },
  {
    "category": "Composite",
    "url": "/routine/infix%3A%C2%AB%3D%3D%C2%BB",
    "value": "infix:«==»",
    "info": ""
  },
  {
    "url": "/routine/ast",
    "value": "ast",
    "info": "",
    "category": "Composite"
  },
  {
    "category": "Composite",
    "value": "from-list",
    "info": "",
    "url": "/routine/from-list"
  },
  {
    "value": "infix",
    "url": "/routine/infix",
    "info": "",
    "category": "Composite"
  },
  {
    "value": ".=",
    "info": "",
    "category": "Composite",
    "url": "/routine/.%3D"
  },
  {
    "category": "Composite",
    "value": "ne",
    "info": "",
    "url": "/routine/ne"
  },
  {
    "info": "",
    "category": "Composite",
    "url": "/syntax/Perl",
    "value": "Perl"
  },
  {
    "value": "[ ]",
    "category": "Composite",
    "info": "",
    "url": "/routine/%5B%20%5D"
  }
]