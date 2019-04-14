require "rails"

module Navigasmic
  class Engine < ::Rails::Engine
    initializer "navigasmic.view_helpers" do
      ActionView::Base.send(:include, ViewHelpers)
    end

    config.to_prepare do
      initializer = Rails.root.join("config", "initializers", "navigasmic")
      require initializer if File.exist?(initializer)
    end
  end
end
