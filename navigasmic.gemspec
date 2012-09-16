# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'navigasmic/version'

Gem::Specification.new do |s|

  # General Gem Information
  s.name        = 'navigasmic'
  s.date        = '2012-09-14'
  s.version     = Navigasmic::VERSION
  s.authors     = ['Jeremy Jackson']
  s.email       = ['jejacks0n@gmail.com']
  s.homepage    = 'http://github.com/jejacks0n/navigasmic'
  s.summary     = %Q{Navigasmic: Semantic navigation for Rails}
  s.description = %Q{Use semantic structures to to build beautifully simple navigation structures in Rails}
  s.licenses    = ['MIT']

  # Testing dependencies
  s.add_dependency 'railties', '~> 3.2'

  # Testing dependencies
  s.add_development_dependency 'rspec-rails'

  # Gem Files
  s.extra_rdoc_files  = %w(LICENSE)
  # = MANIFEST =
  s.files             = Dir['lib/**/*']
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # = MANIFEST =
  s.require_paths     = %w(lib)

end
