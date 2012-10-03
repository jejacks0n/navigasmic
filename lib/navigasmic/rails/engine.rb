require 'rails'

module Navigasmic
  class Engine < ::Rails::Engine
    initializer "navigasmic.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end

    config.to_prepare do
      if File.exists?(Rails.root.join('config', 'initializers', 'navigasmic'))
        require Rails.root.join('config', 'initializers', 'navigasmic')
      end
    end
  end
end
