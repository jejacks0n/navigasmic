module Navigasmic
  module Builder
    class CrumbBuilder < Base
      class Configuration < Base::Configuration
        attr_accessor :item_class
        attr_accessor :link_generator, :label_generator

        def initialize
          # which keys (for other builder) should be removed from options
          @excluded_keys = [:map]

          # class configurations
          @item_class = nil

          # generator callbacks
          @link_generator = proc { |label, link, options, is_nested| link_to(label, link, options.delete(:link_html)) }
          @label_generator = proc { |label, is_linked, is_nested| "<span>#{label}</span>" }

          super
        end
      end

      def initialize(context, name, options, &block)
        super
        @path = []
        @crumb_path = []
      end

      def render
        capture(&@definition)
        @path.join(" ").html_safe
      end

      def group(label = nil, options = {}, &block)
        if block_given?
          @crumb_path << label_for(label, false, false, options) if label
          capture(&block)
        end
      end

      def item(label, *args, &block)
        options = args.extract_options!
        options = flatten_and_eval_options(options)
        return "" unless visible?(options)

        merge_classes!(options, @config.item_class)
        item = Navigasmic::Item.new(label, extract_and_determine_link(label, options, *args), visible?(options), options)

        if item.highlights_on?(@context.request.path, @context.params)
          @crumb_path << label_for(label, false, false, options)
          @path += @crumb_path
          @crumb_path = []
        end

        if block_given?
          @crumb_path << label_for(label, item.link? ? item.link : false, false, options) if label
          capture(&block)
        end
      end

      private

        def label_for(label, link, is_nested = false, options = {})
          if label.present?
            label = @context.instance_exec(label, options, !!link, is_nested, &@config.label_generator).html_safe
          end
          label = @context.instance_exec(label, link, options.delete(:link_html) || {}, is_nested, &@config.link_generator).html_safe if link
          label
        end

        def merge_classes!(hash, classname)
          return if classname.blank?
          hash[:class] = (hash[:class] ? "#{hash[:class]} " : "") << classname
        end
    end
  end
end
