module Navigasmic::Builder
  class ListBuilder < Base
    class Configuration < Base::Configuration

      attr_accessor :wrapper_class, :with_group_class, :disabled_class, :highlighted_class
      attr_accessor :wrapper_tag, :group_tag, :item_tag, :label_generator

      def initialize
        # which keys (for other builder) should be removed from options
        @excluded_keys = [:map]

        # tag configurations
        @wrapper_tag = :ul
        @group_tag = :ul
        @item_tag = :li
        @label_generator = proc{ |label| "<span>#{label}</span>" }

        # class configurations
        @wrapper_class = 'semantic-navigation'
        @with_group_class = 'with-group'
        @disabled_class = 'disabled'
        @highlighted_class = 'active'

        super
      end
    end

    def initialize(context, name, options, &block)
      super
      @options[:id] ||= name.to_s.underscore unless @options.has_key?(:id)
      @options[:class] = merge_classes!(@options, @config.wrapper_class)
    end

    def render
      content_tag(@config.wrapper_tag, capture(&@definition), @options)
    end

    def group(label = nil, options = {}, &block)
      raise ArgumentError, "Missing block for group" unless block_given?
      return '' unless visible?(options)

      merge_classes!(options, @config.with_group_class)

      concat(structure_for(label, false, options, &block))
    end

    def item(label, *args, &block)
      options = args.extract_options!
      options = flatten_and_eval_options(options)
      return '' unless visible?(options)

      item = Navigasmic::Item.new(self, label, extract_and_determine_link(label, options, *args), options)

      merge_classes!(options, @config.disabled_class) if item.disabled?
      merge_classes!(options, @config.highlighted_class) if item.highlights_on?(@context.request.path, @context.params)

      concat(structure_for(label, item.link? ? item.link : false, options, &block))
    end

    private

    def structure_for(label, link = false, options = {}, &block)
      label = label_for(label, link, options)
      content = block_given? ? content_tag(@config.group_tag, capture(&block)) : ''
      content_tag(@config.item_tag, "#{label}#{content}".html_safe, options)
    end

    def label_for(label, link, options)
      label = label.present? ? @config.label_generator.call(label).html_safe : ''
      label = link_to(label, link, options.delete(:link_html)) if link
      label
    end

    def merge_classes!(hash, classname)
      hash[:class] = (hash[:class] ? "#{hash[:class]} " : '') << classname
    end

  end
end
