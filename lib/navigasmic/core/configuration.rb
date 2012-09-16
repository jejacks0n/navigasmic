require 'singleton'

module Navigasmic
  class Configuration
    include Singleton

    cattr_accessor :default_builder
    @@default_builder = Navigasmic::Builder::ListBuilder

    cattr_accessor :builder_configurations
    @@builder_configurations = {}

    cattr_accessor :definitions
    @@definitions = {}

    def self.semantic_navigation(name, &block)
      @@definitions[name] = block
    end

    def self.builder(builder, &block)
      if builder.is_a?(Hash)
        name = builder.keys[0]
        builder = builder[name]
      else
        name = :default
      end
      @@builder_configurations[builder.to_s] ||= {}
      @@builder_configurations[builder.to_s][name] = block
    end
  end

  mattr_accessor :configuration
  @@configuration = Configuration

  def self.setup
    yield @@configuration
  end
end
