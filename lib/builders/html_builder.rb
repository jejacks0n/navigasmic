module Navigasmic
  class HtmlNavigationBuilder

    attr_accessor :template, :name, :items

    def initialize(template, name, options = {}, &proc)
      @template, @name, @items = template, name.to_s, []
      render(options.delete(:html), &proc)
    end

    def render(options, &proc)
      buffer = template.capture(self, &proc)
      template.concat(template.content_tag(Navigasmic.wrapper_tag, buffer, options))
    end

    def group(label = nil, options = {}, &proc)
      raise ArgumentError, "Missing block" unless block_given?

      options[:html] ||= {}
      options[:html][:class] = template.add_html_class(options[:html][:class], Navigasmic.with_group_class)
      options[:html][:id] ||= label.to_s.gsub(/\s/, '_').underscore unless label.blank? || options[:html].has_key?(:id)

      buffer = template.capture(self, &proc)
      group = template.content_tag(Navigasmic.group_tag, buffer)
      label = label_for_group(label) unless label.blank?

      visible = options[:hidden_unless].nil? ? true : options[:hidden_unless].is_a?(Proc) ? template.instance_eval(&options[:hidden_unless]) : options[:hidden_unless]
      visible ? template.content_tag(Navigasmic.item_tag, (label.to_s + group).html_safe, options.delete(:html)) : ''
    end

    def item(label, options = {}, &proc)
      buffer = block_given? ? template.capture(self, &proc) : ''

      item = NavigationItem.new(label, options, template)

      options[:html] ||= {}
      options[:html][:id] = label.to_s.gsub(/\s/, '_').underscore unless options[:html].has_key?(:id)

      options[:html][:class] = template.add_html_class(options[:html][:class], Navigasmic.disabled_class) if item.disabled?
      options[:html][:class] = template.add_html_class(options[:html][:class], Navigasmic.highlighted_class) if item.highlighted?(template.request.path, template.params, template)

      label = label_for_item(label)
      link = item.link.is_a?(Proc) ? template.instance_eval(&item.link) : item.link

      label = template.link_to(label, link, options.delete(:link_html)) unless !item.link? || item.disabled?

      item.hidden? ? '' : template.content_tag(Navigasmic.item_tag, label + buffer, options.delete(:html))
    end

    def label_for_group(label)
      template.content_tag(Navigasmic.label_tag, label.to_s)
    end

    def label_for_item(label)
      template.content_tag(Navigasmic.label_tag, label.to_s)
    end

  end
end
