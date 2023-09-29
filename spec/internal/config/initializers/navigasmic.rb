Navigasmic.setup do |config|
  config.semantic_navigation :primary do |n|
    n.item "Home", "/"
  end

  config.builder bootstrap: Navigasmic::Builder::ListBuilder do |builder|
    builder.wrapper_class = "nav nav-pills"

    builder.has_nested_class = "dropdown"
    builder.is_nested_class = "dropdown-menu"

    builder.label_generator = proc do |label, options, has_link, has_nested|
      if !has_nested || has_link
        "<span>#{label}</span>"
      else
        link_to(%{#{label}<b class="caret"></b>}.html_safe, "#", class: "dropdown-toggle", data: { toggle: "dropdown" })
      end
    end

    builder.link_generator = proc do |label, link, link_options, has_nested|
      if has_nested
        link = "#"
        label << %{<b class="caret"></b>}
        options.merge!(class: "dropdown-toggle", data: { toggle: "dropdown" })
      end
      link_to(label, link, link_options)
    end
  end
end
