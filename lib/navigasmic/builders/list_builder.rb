module Navigasmic::Builder
  class ListBuilder < Base
    class Configuration < Base::Configuration

      attr_accessor :wrapper_class, :item_class, :has_nested_class, :is_nested_class, :disabled_class, :highlighted_class
      attr_accessor :wrapper_tag, :group_tag, :item_tag
      attr_accessor :link_generator, :label_generator, :item_generator

      def initialize
        # which keys (for other builder) should be removed from options
        @excluded_keys = [:map]

        # tag configurations
        @wrapper_tag = :ul
        @group_tag = :ul
        @item_tag = :li

        # class configurations
        @wrapper_class = 'semantic-navigation'
        @item_class = nil
        @has_nested_class = 'has-nested'
        @is_nested_class = 'is-nested'
        @disabled_class = 'disabled'
        @highlighted_class = 'active'

        # generator callbacks
        @link_generator = proc{ |label, link, options, is_nested| link_to(label, link, options) }
        @label_generator = proc{ |label, is_linked, is_nested| "<span>#{label}</span>" }
        @item_generator = proc{ |label, link, content, options, tag| content_tag(tag,"#{label}#{content}".html_safe,options)}
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

    def group(label_or_options = nil, options = {}, &block)
      raise ArgumentError, "Missing block for group" unless block_given?
      if label_or_options.is_a?(Hash)
        options = label_or_options
        label_or_options = nil
      end
      return '' unless visible?(options)

      concat(structure_for(label_or_options, false, options, &block))
    end

    def item(label, *args, &block)
      options = args.extract_options!
      options = flatten_and_eval_options(options)
      return '' unless visible?(options)

      item = Navigasmic::Item.new(label, extract_and_determine_link(label, options, *args), visible?(options), options)

      merge_classes!(options, @config.item_class)
      merge_classes!(options, @config.disabled_class) if item.disabled?
      merge_classes!(options, @config.highlighted_class) if item.highlights_on?(@context.request.path, @context.params)

      concat(structure_for(label, item.link? ? item.link : false, options, &block))
    end

    private

    def structure_for(label, link = false, options = {}, &block)
      label = label_for(label, link, block_given?, options)

      content = ''
      if block_given?
        merge_classes!(options, @config.has_nested_class)
        content = content_tag(@config.group_tag, capture(&block), {class: @config.is_nested_class})
      end
      
      @context.instance_exec(label, link, content, options, @config.item_tag, &@config.item_generator).html_safe
    end

    def label_for(label, link, is_nested = false, options = {})
      if label.present?
        label = @context.instance_exec(label, options, !!link, is_nested, &@config.label_generator).html_safe
      end
      label = @context.instance_exec(label, link, options.delete(:link_html) || {}, is_nested, &@config.link_generator).html_safe if link
      label
    end

    def merge_classes!(hash, classname)
      return if classname.blank?
      hash[:class] = (hash[:class] ? "#{hash[:class]} " : '') << classname
    end

  end
end
