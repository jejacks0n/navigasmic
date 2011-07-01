# coding: utf-8
require 'builders/html_builder'
require 'builders/xml_builder'

module Navigasmic #:nodoc:

  # Semantic navigation helper methods
  #
  # Example Usage:
  #
  #   <% semantic_navigation :primary, :html => {:class => 'primary'} do |n| %>
  #     <%= n.item 'Blog Posts', :link => {:controller => 'posts'} %>
  #   <% end %>
  #
  #   <% semantic_navigation :primary, :builder => MyCustomBuilder do |n| %>
  #     <%= n.group 'My Thoughts' do %>
  #       <%= n.item 'Blog Posts', :link => {:controller => 'posts'} %>
  #     <% end %>
  #   <% end %>
  #
  #   <% semantic_navigation :primary do |n| %>
  #     <%= n.group 'My Thoughts' do %>
  #       <%= n.item 'Blog Posts', :link => {:controller => 'posts'} do %>
  #         <ul>
  #           <%= n.item 'Recent Posts', :link => {:controller => 'posts', :action => 'recent'} %>
  #         </ul>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  module SemanticNavigationHelper

    @@builder = ::Navigasmic::HtmlNavigationBuilder
    mattr_accessor :builder

    def semantic_navigation(name, *args, &proc)
      raise ArgumentError, "Missing block" unless block_given?

      options = args.extract_options!

      options[:html] ||= {}
      options[:html][:class] = add_html_class(options[:html][:class], 'semantic-navigation')
      options[:html][:id] ||= name.to_s.underscore  unless options[:html].has_key?(:id)

      builder = options.delete(:builder) || @@builder
      builder.new(self, name, options, &proc)
    end

    def add_html_class(classnames, classname)
      out = (classnames.is_a?(String) ? classnames.split(' ') : []) << classname
      out.join(' ')
    end

  end

  #
  #
  #
  #
  #
  class NavigationItem

    attr_accessor :label, :link

    def initialize(label, options = {}, template = nil)
      @label = label

      if options[:link]
        @link = options[:link]
      elsif template.present?
        method = "#{label.to_s.underscore.gsub(/\s/, '_')}_path"
        @link = template.send(method) if template.respond_to? method
      end
      @link ||= {}

      @disabled_conditions = options[:disabled_if] || proc { false }
      @visible = options[:hidden_unless].nil? ? true : options[:hidden_unless].is_a?(Proc) ? template.instance_eval(&options[:hidden_unless]) : options[:hidden_unless]

      options[:highlights_on] = [options[:highlights_on]] if options[:highlights_on].kind_of?(Hash) || options[:highlights_on].kind_of?(String)
      @highlights_on = options[:highlights_on] || []

      if link?
        if @link.is_a?(Proc)
          @highlights_on << template.instance_eval(&@link)
        else
          @highlights_on << @link if link?
        end
      end
    end

    def link?
      @link && !@link.blank?
    end

    def disabled?
      @disabled_conditions.call
    end

    def hidden?
      !@visible
    end

    def highlighted?(path, params = {}, template = nil)
      params = clean_unwanted_keys(params)
      result = false

      @highlights_on.each do |highlight|
        highlighted = true

        case highlight
        when String
          highlighted &= path == highlight
        when Proc
          h = template.instance_eval(&highlight)
          raise 'proc highlighting rules must evaluate to TrueClass or FalseClass' unless (h.is_a?(TrueClass) || h.is_a?(FalseClass))
          highlighted &= h
        when Regexp
          highlighted &= path.match(highlight)
        when Hash
          h = clean_unwanted_keys(highlight)
          h.each_key do |key|
            h_key = h[key].to_s.dup
            h_key.gsub!(/^\//, '') if key == :controller
            highlighted &= h_key == params[key].to_s
          end
        else
          raise 'highlighting rules should be a String, Proc, Regexp or a Hash'
        end

        result |= highlighted
      end

      return result
    end

    private

    # removes unwanted keys from a Hash and returns a new hash
    def clean_unwanted_keys(hash)
      ignored_keys = [:only_path, :use_route]
      hash.dup.delete_if { |key, value| ignored_keys.include?(key) }
    end

  end

end

ActionController::Base.helper Navigasmic::SemanticNavigationHelper
