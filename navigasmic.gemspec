# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "navigasmic/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "navigasmic"
  s.version     = Navigasmic::VERSION
  s.authors     = ["jejacks0n"]
  s.email       = ["jejacks0n@gmail.com"]
  s.homepage    = "http://github.com/jejacks0n/navigasmic"
  s.summary     = "Navigasmic: Semantic navigation for Rails defined in view or configuration"
  s.description = "Use semantic structures to to build beautifully simple navigation structures in Rails."
  s.license     = "MIT"
  s.files       = Dir["{lib}/**/*"] + ["MIT.LICENSE", "README.md"]

  s.add_development_dependency "appraisal"

  s.required_ruby_version = ">= 2.4"
end
