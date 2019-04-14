ENV["RAILS_ENV"] ||= "test"
ENV["RAILS_ROOT"] = File.expand_path("../dummy", __FILE__)

require "simplecov"
SimpleCov.start("rails") do
  add_filter "lib/navigasmic/version.rb"
end

require_relative "dummy/config/environment"
require "rspec/rails"
require "navigasmic"

RSpec.configure do |config|
  config.order = "random"
end
