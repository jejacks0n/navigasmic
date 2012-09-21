class Navigasmic::Item

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
    params = clean_unwanted_keys(params)
    result = false

    @rules.each do |rule|
      highlighted = true

      case rule
        when String then highlighted &= path == rule
        when Regexp then highlighted &= path.match(rule)
        when TrueClass then highlighted &= rule
        when FalseClass then highlighted &= rule
        when Hash
          clean_unwanted_keys(rule).each do |key, value|
            value.gsub!(/^\//, '') if key == :controller
            highlighted &= value == params[key].to_s
          end
        else raise 'highlighting rules should be an array containing any of/or a Boolean, String, Regexp, Hash or Proc'
      end

      result |= highlighted
    end

    result
  end

  private

  def calculate_highlighting_rules(rules)
    highlighting_rules = []
    highlighting_rules << @link if link?

    return [] if highlighting_rules.blank?
    highlighting_rules += Array(rules)
  end

  def clean_unwanted_keys(hash)
    ignored_keys = [:only_path, :use_route]
    hash.dup.delete_if { |key, value| ignored_keys.include?(key) }
  end

end
