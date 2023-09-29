Navigasmic.setup do |config|
  config.semantic_navigation :testing do |n|
    n.item "Home", proc { root_path }
    n.item "Site Map", proc { root_path(format: "xml") }
    n.item "Blog", class: "blog", highlights_on: [{ controller: "/blog/posts" }, { controller: "/blog/links" }] do
      n.item "Articles", controller: "/blog/posts"
      n.item "Links", "/blog/links"
      n.item "Specific Article", link: { controller: "/blog/posts", action: "show", id: "2" }
      n.item "Not Linked"
    end
  end
end
