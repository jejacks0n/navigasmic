require "simplecov"
SimpleCov.start("rails") do
  add_filter "lib/navigasmic/version.rb"
end

require 'bundler'

Bundler.require :default, :development

Combustion.initialize! :action_controller, :action_view

require "rspec/rails"
require "navigasmic"

RSpec.configure do |config|
  config.order = "random"
end
