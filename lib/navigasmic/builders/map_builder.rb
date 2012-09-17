module Navigasmic::Builder
  class MapBuilder < Base
    class Configuration < Base::Configuration

      attr_accessor :option_namespace
      attr_accessor :wrapper_tag, :group_tag, :item_tag, :label_generator

      def initialize
        # where you want the changefreq and other options to be looked for
        @option_namespace = :map

        # tag configurations
        @wrapper_tag = :urlset
        @item_tag = :url

        super
      end
    end

    def initialize(context, name, options, &block)
      super
      @options['xmlns'] ||= 'http://www.sitemaps.org/schemas/sitemap/0.9'
      @options['xmlns:xsi'] ||= 'http://www.w3.org/2001/XMLSchema-instance'
      @options['xsi:schemaLocation'] ||= 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd'
      @options[:changefreq] ||= 'yearly'
    end

    def render
      content_tag(@config.wrapper_tag, capture(&@definition), @options)
    end

    def group(label = nil, options = {}, &block)
      raise ArgumentError, "Missing block for group" unless block_given?
      return '' unless visible?(options)

      concat(capture(&block))
    end

    def item(label, *args, &block)
      options = args.extract_options!
      options = flatten_and_eval_options(options)
      return '' unless visible?(options)

      item = Navigasmic::Item.new(self, label, extract_and_determine_link(label, options, *args), options)

      concat(capture(&block)) if block_given?
      return '' unless item.link?

      concat(structure_for(label, item.link, options))
    end

    private

    def structure_for(label, link, options, &block)
      content = content_tag(:loc, link_for(link, options))
      content << content_tag(:name, label)
      if opts = options.delete(@config.option_namespace)
        content << content_tag(:changefreq, opts[:changefreq] || 'yearly')
        content << content_tag(:lastmod, opts[:lastmod]) if opts.has_key?(:lastmod)
        content << content_tag(:priority, opt[:priority]) if opts.has_key?(:priority)
      end

      content_tag(@config.item_tag, content.html_safe)
    end

    def link_for(link, options)
      host = options.delete(:host) || @context.request.host
      if link.is_a?(Hash)
        link[:host] ||= host
      else
        link = "#{@context.request.protocol}#{host}#{@context.request.port}#{link}"
      end
      url_for(link)
    end

  end
end
