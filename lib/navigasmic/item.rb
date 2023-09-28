module Navigasmic
  class Item
    attr_accessor :link

    def initialize(label, link, visible, options = {})
      @label, @link, @visible = label, link, visible
      @disabled = options.delete(:disabled_if)
      options.delete(:hidden_unless)

      @rules = calculate_highlighting_rules(options.delete(:highlights_on))
    end

    def hidden?
      !@visible
    end

    def disabled?
      @disabled
    end

    def link?
      @link.present? && !disabled?
    end

    def highlights_on?(path, params)
      return false unless @rules.any?
      params = params.except(*unwanted_keys)
      !!@rules.detect do |rule|
        case rule
        when String
          path == rule
        when Regexp
          path.match(rule)
        when TrueClass
          true
        when FalseClass
          false
        when Hash
          rule.except(*unwanted_keys).detect do |key, value|
            value = value.gsub(/^\//, "") if key == :controller
            value == params[key].to_s
          end
        else
          raise ArgumentError, "Highlighting rules should be an array containing any of/or a Boolean, String, Regexp, Hash or Proc"
        end
      end
    end

    private
      def calculate_highlighting_rules(rules)
        [].tap do |highlighting_rules|
          if rules.nil?
            highlighting_rules << @link if link?
          else
            highlighting_rules.concat Array(rules)
          end
        end
      end

      def unwanted_keys
        [:only_path, :use_routes]
      end
  end
end
