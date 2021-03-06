require "singleton"

module Navigasmic
  class Configuration
    include Singleton

    cattr_accessor(*[
      :default_builder,
      :definitions,
      :builder_configurations,
    ])

    @@default_builder = Navigasmic::Builder::ListBuilder
    @@definitions = {}
    @@builder_configurations = {}

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

  def self.configure
    yield @@configuration
  end

  singleton_class.send(:alias_method, :setup, :configure)
end
