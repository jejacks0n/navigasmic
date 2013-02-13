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
    return false unless @rules.any?
    params = clean_unwanted_keys(params)
    @rules.each do |rule|
      case rule
      when String
        return false unless path == rule
      when Regexp
        return false unless path.match(rule)
      when TrueClass
        # no-op
      when FalseClass
        return false
      when Hash
        clean_unwanted_keys(rule).each do |key, value|
          value.gsub(/^\//, '') if key == :controller
          return false unless value == params[key].to_s
        end
      else
        raise ArgumentError, 'Highlighting rules should be an array containing any of/or a Boolean, String, Regexp, Hash or Proc'
      end
    end
    true
  end

  private

  def calculate_highlighting_rules(rules)
    [].tap do |highlighting_rules|
      if rules
        highlighting_rules.concat Array(rules)
      else
        highlighting_rules << @link if link?
      end
    end
  end

  def clean_unwanted_keys(hash)
    ignored_keys = [:only_path, :use_route]
    hash.dup.delete_if { |key, value| ignored_keys.include?(key) }
  end

end
