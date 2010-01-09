module Navigasmic
  class HtmlNavigationBuilder

    @@classnames = {
      :with_group => 'with-group',
      :group => 'group',
      :disabled => 'disabled',
      :highlighted => 'highlighted'
    }

    attr_accessor :template, :name, :items

    def initialize(template, name, options = {}, &proc)
      @template, @name, @items = template, name.to_s, options, []
      render(options.delete(:html), &proc)
    end

    def render(options, &proc)
      buffer = template.capture(self, &proc)
      template.concat(template.content_tag(:ul, buffer, options))
    end

    def group(label = nil, options = {}, &proc)
      raise ArgumentError, "Missing block" unless block_given?

      options[:html] ||= {}
      options[:html][:class] = template.add_class(options[:html][:class], @@classnames[:with_group])
      options[:html][:id] ||= label.to_s.gsub(/\s/, '_').underscore

      buffer = template.capture(self, &proc)
      group = template.content_tag(:ul, buffer)
      label = label_for_group(label) unless label.blank?

      template.content_tag(:li, label.to_s + group, options.delete(:html))
    end

    def item(label, options = {}, &proc)
      buffer = block_given? ? template.capture(self, &proc) : ''

      item = NavigationItem.new(label, options)

      options[:html] ||= {}
      options[:html][:id] ||= label.to_s.gsub(/\s/, '_').underscore

      options[:html][:class] = template.add_class(options[:html][:class], @@classnames[:disabled]) if item.disabled?
      options[:html][:class] = template.add_class(options[:html][:class], @@classnames[:highlighted]) if item.highlighted?(template.request.path, template.params)

      label = label_for_item(label)
      label = template.link_to(label, item.link) unless item.link.empty?

      template.content_tag(:li, label + buffer, options.delete(:html))
    end

    def label_for_group(label)
      template.content_tag(:span, label.to_s)
    end

    def label_for_item(label)
      template.content_tag(:span, label.to_s)
    end

  end
end