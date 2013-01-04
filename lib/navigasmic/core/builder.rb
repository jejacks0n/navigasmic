module Navigasmic::Builder
  autoload :ListBuilder,  'navigasmic/builders/list_builder'
  autoload :MapBuilder,   'navigasmic/builders/map_builder'
  autoload :CrumbBuilder, 'navigasmic/builders/crumb_builder'

  class Base
    class Configuration
      attr_accessor :excluded_keys

      def initialize
        @excluded_keys ||= []
        yield self if block_given?
      end
    end

    def initialize(context, name, options, &block)
      @definition = block_given? ? block : Navigasmic.configuration.definitions[name]
      raise ArgumentError, "Missing block or configuration" unless @definition

      @context, @name, @options = context, name, options
      @config = configuration_or_default(@options.delete(:config))
      remove_excluded_options(@options)
    end

    def group(label = nil, options = {}, &block)
      raise "Expected subclass to implement group"
    end

    def item(label = nil, *args, &block)
      raise "Expected subclass to implement item"
    end

    def render
      raise "Expected subclass to implement render"
    end

  private

    def configuration_or_default(config = nil)
      configurations = Navigasmic.configuration.builder_configurations[self.class.to_s]
      proc = configurations.present? ? configurations[config || :default] : nil
      self.class::Configuration.new(&proc)
    end

    def remove_excluded_options(options)
      @config.excluded_keys.each { |key| options.delete(key) }
    end

    def capture(&block)
      (block_given? ? @context.capture(self, &block) : nil).to_s.html_safe
    end

    def eval_in_context(&block)
      @context.instance_eval(&block)
    end

    def method_missing(meth, *args, &block)
      @context.send(meth, *args, &block)
    end

    def flatten_and_eval_options(options)
      remove_excluded_options(options)
      options.inject({}) do |hash, (key, value)|
        if value.is_a?(Array)
          value = value.map{ |v| v.is_a?(Proc) ? eval_in_context(&v) : v }
        elsif value.is_a?(Proc)
          value = eval_in_context(&value)
        end
        hash.update(key => value)
      end
    end

    def visible?(options)
      if options[:hidden_unless].nil?
        true
      elsif options[:hidden_unless].is_a?(Proc)
        eval_in_context(&options[:hidden_unless])
      else
        options[:hidden_unless]
      end
    end

    def extract_and_determine_link(label, options, *args)
      determine_link(label, extract_link(options, *args))
    end

    def extract_link(options, *args)
      if args.length == 1
        args.delete_at(0)
      else
        hash = {controller: options.delete(:controller), action: options.delete(:action)}
        hash = options.delete(:link) || hash
        hash.select{ |key, value| value.present? }
      end
    end

    def determine_link(label, link)
      if link.blank?
        path_helper = "#{label.to_s.underscore.gsub(/\s/, '_')}_path"
        @context.send(path_helper) if @context.respond_to?(path_helper)
      elsif link.is_a?(Proc)
        eval_in_context(&link)
      elsif link.is_a?(String)
        link
      elsif link.is_a?(Hash)
        link
      else
        url_for(link)
      end
    end

  end
end
