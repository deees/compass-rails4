# -*- encoding: utf-8 -*-
require File.expand_path('../lib/compass-rails4/version', __FILE__)

Gem::Specification.new do |spec|
  spec.authors       = ["Tomas Brazys"]
  spec.email         = ["tomas.brazys@gmail.com"]
  spec.description   = %q{Integrate Compass into Rails 4.0.}
  spec.summary       = %q{Adaptation of original compass-rails to work with Rails 4.}
  spec.homepage      = "https://github.com/deees/compass-rails4"

  # spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.files         = `git ls-files`.split("\n")
  # spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  spec.name          = "compass-rails4"
  spec.require_paths = ["lib"]
  spec.version       = CompassRails4::VERSION
  spec.license       = "MIT"

  spec.add_dependency 'compass', '~> 0.13.alpha.12'
  spec.add_dependency 'railties', '~> 4.0.0'
  spec.add_dependency 'sprockets', '<= 2.11.0'

  spec.add_development_dependency 'rake'
end
