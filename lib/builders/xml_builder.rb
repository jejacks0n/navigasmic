module Navigasmic
  class XmlNavigationBuilder

    @@wrapper_tag = :urlset
    @@group_tag = :urlset
    @@item_tag = :url

    attr_accessor :template, :name, :items, :host

    def initialize(template, name, options = {}, &proc)
      @template, @name, @items = template, name.to_s, []
      @host = options[:host] || "http://#{template.request.host_with_port}"
      @changefreq = options[:changefreq] || 'yearly'
      render(options.delete(:xml), &proc)
    end

    def render(options, &proc)
      buffer = template.capture(self, &proc)

      options ||= {}
      options['xmlns'] ||= 'http://www.sitemaps.org/schemas/sitemap/0.9'
      options['xmlns:xsi'] ||= 'http://www.w3.org/2001/XMLSchema-instance'
      options['xsi:schemaLocation'] ||= 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd'

      template.concat(template.content_tag(@@wrapper_tag, buffer, options))
    end

    def group(label = nil, options = {}, &proc)
      raise ArgumentError, "Missing block" unless block_given?

      buffer = template.capture(self, &proc)

      visible = options[:hidden_unless].nil? ? true : options[:hidden_unless].is_a?(Proc) ? template.instance_eval(&options[:hidden_unless]) : options[:hidden_unless]
      visible ? template.concat(template.content_tag(@@group_tag, buffer)) : ''
    end

    def item(label, options = {}, &proc)
      buffer = block_given? ? template.capture(self, &proc) : ''

      item = NavigationItem.new(label, options, template)

      contents = template.content_tag(:loc, @host + template.url_for(item.link))
      contents << template.content_tag(:changefreq, options[:changefreq] || @changefreq)
      contents << template.content_tag(:lastmod, options[:lastmod]) if options[:lastmod]
      contents << template.content_tag(:priority, options[:priority]) if options[:priority]

      item.hidden? ? '' : template.concat(template.content_tag(@@item_tag, contents + buffer, options.delete(:xml)))
    end

  end
end