# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swrve/version'

Gem::Specification.new do |gem|
  gem.name          = "swrve"
  gem.version       = Swrve::VERSION
  gem.authors       = ["John O'Gara"]
  gem.email         = ["johnogara@radiatorhead.com"]
  gem.description   = %q{Simple Client for Swrve API}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/johnogara/swrve"

  gem.add_dependency 'faraday', ['~> 0.8', '< 0.10']
  gem.add_dependency 'multi_json', '~> 1.0'

  gem.add_development_dependency "rspec"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
