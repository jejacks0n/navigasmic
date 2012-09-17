Navigasmic.setup do |config|

  # Defining Navigation Structures:
  #
  # You can begin by defining your navigation structures here.  You can also define them directly in the view if you'd
  # like, but it's recommended to eventually move them here to clean help up your views.  You can read about Navigasmic
  # at https://github.com/jejacks0n/navigasmic
  #
  # When you're defining navigation here, it's basically the same as if you were doing it in the view but the scope is
  # different.  It's important to understand that -- and use procs where you want things to execute in the view scope.
  #
  # Once you've defined some navigation structures and configured your builders you can render navigation in your views
  # using the `semantic_navigation` view helper.  You can also use the same syntax to define your navigation structures
  # in your views, and eventually move them here (it's handy to prototype navigation/css by putting them in the views
  # first).
  #
  # <%= semantic_navigation :primary %>
  #
  # You can optionally provided a :builder and :config option to the semantic_navigation view helper.
  #
  # <%= semantic_navigation :primary, config: :blockquote %>
  # <%= semantic_navigation :primary, builder: Navigasmic::Builder::MapBuilder %>
  #
  # When defining navigation in your views just pass it a block (the same as here basically).
  #
  # <%= semantic_navigation :primary do |n| %>
  #   <% n.item 'About Me' %>
  # <% end %>
  #
  # Here's a basic example:
  config.semantic_navigation :primary do |n|

    n.item 'Home', '/'

    # Groups and Items:
    #
    # You can create a structure using `group`, and `item`.  You can nest items inside groups or items.  In the
    # following example, the "Articles" item will always highlight on the blog/posts controller, and the nested article
    # items will only highlight when on those specific pages.  The "Links" item will be disabled unless the user is
    # logged in.
    #
    #n.group 'Blog' do
    #  n.item 'Articles', controller: '/blog/posts' do
    #    n.item 'First Article', '/blog/posts/1'
    #    n.item 'Second Article', '/blog/posts/2', map: {changefreq: 'weekly'}
    #  end
    #  n.item 'Links', controller: '/blog/links', disabled_if: proc{ !logged_in? }
    #end
    #
    # You can hide specific specific items or groups.  Here we specify that the "About" section of navigation should
    # only be displayed if the user is logged in.
    #
    #n.group 'About', hidden_unless: proc{ logged_in? } do
    #  n.item 'About Me', class: 'featured', link_html: {class: 'about-me'}
    #end
    #
    # Scoping:
    #
    # Scoping is different than in the view here, so we've provided some nice things for you to get around that.  In
    # the above example we just provide '/' as what the home page is, but that may not be correct.  You can also access
    # the path helpers, using a proc, or by proxying them through the navigation object.  Any method called on the
    # navigation scope will be called within the view scope.
    #
    #n.item 'Home', proc{ root_path }
    #n.item 'Home', n.root_path
    #
    # This proxy behavior can be used for I18n as well.
    #
    #n.item n.t('hello'), '/'

  end


  # Setting the Default Builder:
  #
  # By default the Navigasmic::Builder::ListBuilder is used unless otherwise specified.
  #
  # You can change this here:
  #config.default_builder = MyCustomBuilder


  # Configuring Builders:
  #
  # You can change various builder options here by specifying the builder you want to configure and the options you
  # want to change.
  #
  # Changing the default ListBuilder options:
  config.builder Navigasmic::Builder::ListBuilder do |builder|
    builder.wrapper_class = 'semantic-navigation'
  end


  # Naming Builder Configurations:
  #
  # If you want to define a named configuration for a builder, just provide a hash with the name, and the builder to
  # configure.  The named configurations can then be used during rendering by specifying a `:config => :blockquote`
  # option to the `semantic_navigation` view helper.
  #
  # A blockquote alternative for navigation:
  config.builder blockquote: Navigasmic::Builder::ListBuilder do |builder|
    builder.wrapper_tag = :blockquote
    builder.group_tag = :blockquote
    builder.item_tag = :blockquote
  end


  # A Twitter Bootstrap Configuration:
  #
  # You can read more about twitter bootstrap: http://twitter.github.com/bootstrap/
  #config.builder bootstrap: Navigasmic::Builder::ListBuilder do |builder|
  #  builder.highlighted_class = 'active'
  #end

end
