# Navigasmic

[![Build Status](https://secure.travis-ci.org/jejacks0n/navigasmic.png)](http://travis-ci.org/jejacks0n/navigasmic)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jejacks0n/navigasmic)

Semantic navigation; a semantic way to build beautifully simple navigation structures in Rails views or configuration.


## WOAH! Navigasmic got a HUGE update!

I initially wrote Navigasmic over 3 years ago, primarily because there weren't any navigation helpers at the time.  It
was a project that I'd cobbled together from things that I'd done in a project I was working on at the time and it
wasn't very elegant.

Since then there's been several other navigation gems created, and some of them are really awesome.  For some reason
though I've always found myself back with Navigasmic -- and it doesn't seem to do with the fact that I wrote it.

Honestly, I all but abandoned it for over 2 years, only accepting pull requests, which was a pretty crappy thing for me
to do.  So since I still use it, and like it, it seemed about damn time to give it some much needed updating and love.
And to appologize for being a bad open source maintainer.


## The Story

Most of the navigation styles I've done over the years pretty much boil down to this idea: Use simple markup, and do
the rest with CSS (and Javascript if you need it).  Because of that the default markup is beautifully simple (UL and LI
tags).

Ok, so navigation is easy right?  Until you start managing active, disabled, and hidden states, and more if you may
need them.  This can quickly become a mess, and all too often it just stays in the views with whatever logic tossed on
top of it as people go.  I've seen it too many times, and I wanted to do something about it.

These where the core goals:

- be simple
- be easily customizable
- handle active/highlighted states
- handle disabled states
- be pleasant to use
- uses less code to create than it generates

And working with [gvarela](https://github.com/gvarela) at the time, we wrote a DSL that met those requirements:

    semantic_navigation :primary do |n|
      n.group 'Blog' do
        n.item 'Articles', '/blog/posts', highlights_on: '/my_awesome_blog'
        n.item 'Links', '/blog/links', disabled_if: proc { !logged_in? }
        n.item 'My Portfolio' # auto links to the my_portfolio_path if it exists
      end
    end

Since we wanted something that allowed for customization we ended up using the Builder Pattern -- the way Rails uses
form builders basically.  There are some builders that are provided, and these builders can be configured, extended or
replaced if you need more custom markup -- there's more on how to do that stuff below.


## Installation

Include the gem in your Gemfile and bundle to install the gem.  (Navigasmic requires Ruby 1.9+)

    gem 'navigasmic'

You can also get the initializer by running the install generator.

    rails generate navigasmic:install


## Usage

Navigasmic allows you to define navigation in two ways.  The first is directly in your views (in a partial, or layout
for instance), and the second is via a global configuration (similar to how [simple-navigation](https://github.com/andi/simple-navigation) works).

### View Helper

The `semantic_navigation` method in Navigasmic provides a single name for defining and rendering navigation.  You can
use this method in your layouts, views, and partials to render navigation structures, and can define these structures
in the initializer, or in your views directly.

### Defining Navigation in Initializer

    config.semantic_navigation :primary do |n|
      n.group 'Blog', class: 'blog' do
        '<li>Custom Node</li>'.html_safe
        n.item 'Articles', controller: '/blog/posts'
        n.item 'Links', controller: '/blog/links'
      end
      n.group 'Info' do
        n.item 'Me', '/about', title: 'The Awesomeness That Is'
        n.item 'My Portfolio'
      end
    end

### Rendering Navigation (based on navigation defined in initializer)

    semantic_navigation :primary, class: 'my-navigation'

### Definition Navigation / Rendering in Views

#### ERB

    <%= semantic_navigation :primary, builder: Navigasmic::Builder::ListBuilder, class: 'my-navigation' do |n| %>
      <% n.group 'Blog', class: 'blog' do %>
        <li>Custom Node</li>
        <% n.item 'Articles', controller: '/blog/posts' %>
        <% n.item 'Links', controller: '/blog/links' %>
      <% end %>
      <% n.group 'Info' do
           n.item 'Me', '/about', title: 'The Awesomeness That Is'
           n.item 'My Portfolio'
         end %>
    <% end %>

#### HAML

    = semantic_navigation :primary, config: :bootstrap, class: 'my-navigation' do |n|
      - n.group 'Blog', class: 'blog' do
        %li Custom Node
        - n.item 'Articles', controller: '/blog/posts'
        - n.item 'Links', controller: '/blog/links'

### Configuring

If you ran the install generator you should have a `navigasmic.rb` file in your initializers.  This file has several
examples and some more documentation.  It can be used to define navigation structures as well as create named
configurations for each builder.

When you invoke the `semantic_navigation` method you can provide which builder you want to use, and the named
configuration for that builder.  By defining these builder specific configurations you'll be able to render navigation
differently in different parts of your site using the same builder.  This allows for the greatest flexibility.

### Bootstrap Support

[Twitter Bootstrap](http://twitter.github.com/bootstrap/components.html#navs) is pretty awesome, so it's worth supporting.  There's a configuration that's provided in the
initializer that allows for nice bootstrap support.  It handles nav-pills, nav-tabs, and the [navbar](http://twitter.github.com/bootstrap/components.html#navbar) structure.

### Options

There's several options that you can pass to the `item` method that dictate the state of a given navigation item.  You
can tell it what to highlight on, if it's disabled and when, and if it should be hidden entirely.

All of the options allow for passing a proc.  In the examples below procs are used on anything that needs to happen
within the view scope.  This is especially useful when you define the navigation structure in an initializer.  If you
want to check if a user is logged in, those things need to happen within the view scope, so if you're defining your
navigation in a view scope you don't need to use a proc, but if you're using the initializer you will.

#### Passing Links

You can pass links to the `item` method in a few ways.  You can just provide a controller (and/or action) in the
options, you can pass a first argument, or you can explicitly call out what the link options are.  Here are some
examples:

    n.item 'Articles', controller: '/blog/posts', class: 'featured'
    n.item 'Articles', controller: '/blog/posts', action: 'index', class: 'featured'
    n.item 'Articles', '/blog/posts', class: 'featured'
    n.item 'Articles', {controller: '/blog/posts'}, class: 'featured'
    n.item 'Articles', class: 'featured', link: {controller: '/blog/posts'}

You can take this much further by matching specific url options.  Here's some examples that would match to specific
blog posts (they will also only highlight on the given record):

    n.item 'Article', {controller: '/blog/posts', action: 'show', id: '42'},
    n.item 'Article', class: 'featured', link: {controller: '/blog/posts', action: 'show', id: '42'}

Note that we're passing a string for the posts id.. That's because when the param comes in and is compared against the
link options you provided, the types need to match.

If you don't provide a link, Navigasmic attempts to find a path helper from the label.  In the following example we
only provide the label, but if I've defined a route (eg. `match '/portfolio' => 'portfolio#index', as: 'my_portfolio'`)
it will automatically use the `my_porfolio_path' path helper.

    n.item 'My Portfolio' # Yeah auto link!

#### Setting highlighted / active states

Highlight rules allows for passing an array containing any of/or a Boolean, String, Regexp, Hash or Proc.  The
following examples will highlight:

    n.item 'On the /my_thoughts path, and on Mondays', '/blog/posts', highlights_on: ['/my_thoughts', proc{ Time.now.wday == 1}]
    n.item 'On any action in BlogController', highlights_on: {controller: 'blog'}
    n.item 'On any path beginning with "my_"', highlights_on: /^\/my_/
    n.item 'Only on "/my_thoughts"', highlights_on: '/my_thoughts'
    n.item 'When the highlight param is set', highlights_on: proc{ params[:highlight].present? }

#### Disabling

Disable rules allow for you to pass a Boolean or Proc.  The following examples will be disabled:

    n.item 'On Tuesdays, and when not logged in', disabled_if: proc{ Time.now.wday == 2 || !logged_in? }
    n.item 'Never', disabled_if: false
    n.item 'Always', disabled_if: true

#### Hiding

Hide rules allow for you to pass a Boolean or Proc.  The following examples will be hidden:

    n.group 'On Tuesdays, and when not logged in', hidden_unless: proc{ Time.now.wday != 2 && logged_in? } do
      n.item 'When not logged in', hidden_unless: proc{ logged_in? }
      n.item 'Never', hidden_unless: false
      n.item 'Always', hidden_unless: true
    end


## Builders

Navigasmic comes with a few builders by default.  Here's a breakdown of what's available, and what each one does.

- **Navigasmic::Builder::ListBuilder**<br/>
  Builds an HTML structure of UL and LI tags.  Useful for most navigation structured rendered in markup.
- **Navigasmic::Builder::MapBuilder**<br/>
  Builds an XML structure that use the [Sitemaps XML format](http://www.sitemaps.org/protocol.html)
- **Navigasmic::Builder::CrumbBuilder** (incomplete)<br>
  Builds an HTML structure of A tags based on the first highlighted item it finds and up.  Useful for breadcrumbs.

### ListBuilder Options

The ListBuilder is the default builder (unless otherwise specified in the initializer).  It builds a UL/LI structure
that's pretty easy to style and work with.

  - `excluded_keys` -
    *Array*: Allows specifying keys that are ignored in options (you may want to ignore keys used by other builders.)
    Default: `[:map]`
  - `wrapper_tag` -
    *Symbol (or String)*: Tag used for the top level element.
    Default: `:ul`
  - `group_tag` -
    *Symbol (or String)*: Tag used for wrapping groups.
    Default: `:ul`
  - `item_tag` -
    *Symbol (or String)*: Tag used for wrapping specific items.
    Default: `:li`
  - `wrapper_class` -
    *String*: The classname that will be applied to the top level element.
    Default: `'semantic-navigation'`
  - `has_nested_class` -
    *String*: The classname that will be applied to any group (or item with nested items).
    Default: `'with-group'`
  - `is_nested_class` -
    *String*: The classname that will be applied to any nested items (within a group or item).
    Default: `'with-group'`
  - `disabled_class` -
    *String*: The classname that will be applied to disabled items.
    Default: `'disabled'`
  - `highlighted_class` -
    *String*: The classname that will be applied to items that should be highlighted.
    Default: `'active'`
  - `label_generator` -
    *Proc*: Called when inserting labels into items or groups.
    Default: `proc{ |label, has_link, has_nested| "<span>#{label}</span>" }`
  - `link_generator` -
    *Proc*: Called when generating links.
    Default: `proc{ |label, link, options, is_nested| link_to(label, link, options.delete(:link_html)) }`

### MapBuilder Options

The MapBuilder is used for generate XML sitemaps that follow the protocol laid out by the [Sitemaps XML format](http://www.sitemaps.org/protocol.html).

  - `excluded_keys` -
    *Array*: Allows specifying keys that are ignored in options (you may want to ignore keys used by other builders.)
    Default: `[]`
  - `option_namespace` -
    *Symbol (or String)*: Option key that holds the map specific options (eg. :changefreq, :priority, :lastmod etc.)
    Default: `:map`
  - `wrapper_tag` -
    *Symbol (or String)*: Tag used for the top level element.
    Default: `:urlset`
  - `item_tag` -
    *Symbol (or String)*: Tag used for wrapping specific items (groups are not used in this builder.)
    Default: `:url`

A simple example of using the MapBuilder -- create a `[action].xml.builder` view, and add the following:

    xml.instruct!
    xml << semantic_navigation(:primary, builder: Navigasmic::Builder::MapBuilder)


## License

Licensed under the [MIT License](http://opensource.org/licenses/mit-license.php)

Copyright 2011 [Jeremy Jackson](https://github.com/jejacks0n)


## Enjoy =)
