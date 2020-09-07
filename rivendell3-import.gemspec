# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rivendell3/import/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alban Peignier", "Florent Peyraud"]
  gem.email         = ["info@draceo.fr"]
  gem.description   = %q{Import sound in Rivendell system}
  gem.summary       = %q{Import engine for Rivendell}
  gem.homepage      = "https://github.com/draceo/rivendell3-import/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rivendell3-import"
  gem.require_paths = ["lib"]
  gem.version       = Rivendell3::Import::VERSION

  # 2.0 requires ruby 1.9.3
  gem.add_runtime_dependency 'listen', '~> 3.2.1'
  # 0.12.0 requires ruby 1.9.3
  gem.add_runtime_dependency 'httparty', '0.18.1'
  gem.add_runtime_dependency 'mime-types', '~> 3.3.1'
  gem.add_runtime_dependency 'rivendell3-api', '~> 0.9'
  gem.add_runtime_dependency 'optimist', '~> 3.0.1'
  gem.add_runtime_dependency 'activerecord', '~> 6.0.3'
  gem.add_runtime_dependency 'activesupport', '~> 6.0.3'
  gem.add_runtime_dependency 'mail', '~> 2.7.1'
  gem.add_runtime_dependency 'sqlite3', '~> 1.4.2'
  gem.add_runtime_dependency 'SyslogLogger', '~> 2.0'
  gem.add_runtime_dependency 'taglib-ruby', '~> 1.0.1'

  gem.add_runtime_dependency 'sinatra', '2.1.0'
  gem.add_runtime_dependency 'will_paginate', '~> 3.3.0'

  gem.add_runtime_dependency 'daemons', '~> 1.3.1'

  gem.add_development_dependency "simplecov", "~> 0.19.0"
  gem.add_development_dependency "rspec", '~> 3.9.0'
  gem.add_development_dependency "guard", '~> 2.16.2'
  gem.add_development_dependency "guard-rspec", '~> 4.7.3'
  gem.add_development_dependency "guard-cucumber", "~> 3.0.0"
  gem.add_development_dependency "rake", '~> 13.0.1'
  gem.add_development_dependency "rdoc", '~> 6.2.1'
  gem.add_development_dependency "cucumber", '~> 5.1.1'
  gem.add_development_dependency "database_cleaner", '~> 1.8.5'

  # gem.add_development_dependency "remarkable_activerecord"
end
