module Navigasmic::ViewHelpers
  # Semantic navigation view helper method
  #
  # Example Usage:
  #
  #   <%= semantic_navigation :primary, class: 'primary-nav', builder: MyCustomBuilder do |n| %>
  #     <% n.group 'My Thoughts' do %>
  #       <% n.item 'Blog Posts', controller: 'posts', class: 'featured', id: 'blog_posts' %>
  #     <% end %>
  #   <% end %>
  def semantic_navigation(name, options = {}, &block)
    if name.is_a?(Hash)
      options = name
      options[:id] ||= nil
      name = ""
    end
    builder = options.delete(:builder) || Navigasmic.configuration.default_builder
    builder.new(self, name, options, &block).render
  end
end
