# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rivendell/import/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alban Peignier"]
  gem.email         = ["alban@tryphon.eu"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rivendell-import"
  gem.require_paths = ["lib"]
  gem.version       = Rivendell::Import::VERSION

  gem.add_runtime_dependency 'listen'
  gem.add_runtime_dependency 'httmultiparty'
  gem.add_runtime_dependency 'rivendell-api'

  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rake"
end
