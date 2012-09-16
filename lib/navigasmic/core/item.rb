class Navigasmic::Item

  attr_accessor :link
  def initialize(builder, label, link, options = {})
    @label, @link = label, link
    @disabled = options.delete(:disabled_if)
    @visible = builder.send(:visible?, options)
    options.delete(:hidden_unless)

    highlighting_from(options.delete(:highlights_on))
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

    @highlights_on.each do |highlight|
      highlighted = true

      case highlight
        when String then highlighted &= path == highlight
        when Regexp then highlighted &= path.match(highlight)
        when TrueClass then highlighted &= highlight
        when FalseClass then highlighted &= highlight
        when Hash
          clean_unwanted_keys(highlight).each do |key, value|
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

  def highlighting_from(rules)
    @highlights_on = []
    @highlights_on << @link if link?

    return if rules.blank?
    @highlights_on += rules.kind_of?(Array) ? rules : [rules]
  end

  def clean_unwanted_keys(hash)
    ignored_keys = [:only_path, :use_route]
    hash.dup.delete_if { |key, value| ignored_keys.include?(key) }
  end

end
