require 'rails'

module Navigasmic
  class Engine < ::Rails::Engine
    initializer "navigasmic.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end
