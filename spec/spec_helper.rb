require "simplecov"
require "simplecov_json_formatter"
SimpleCov.start "rails" do
  add_filter "lib/navigasmic/version.rb"
  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::JSONFormatter
    ]
  )
end

require "bundler"

Bundler.require :default, :development

Combustion.initialize! :action_controller, :action_view

require "rspec/rails"
require "navigasmic"

RSpec.configure do |config|
  config.order = "random"
end
