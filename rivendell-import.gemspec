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
  gem.add_runtime_dependency 'trollop'
  gem.add_runtime_dependency 'activerecord', '~> 3.2.8'
  gem.add_runtime_dependency 'activesupport', '~> 3.2.8'
  # gem.add_runtime_dependency 'actionmailer'#, '~> 3.2.8'
  gem.add_runtime_dependency 'mail'
  gem.add_runtime_dependency 'sqlite3'

  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "guard-cucumber"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "cucumber"
  gem.add_development_dependency "database_cleaner"
  # gem.add_development_dependency "remarkable_activerecord"

end
