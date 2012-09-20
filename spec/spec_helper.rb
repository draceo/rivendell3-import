require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/db/"
end

require 'rivendell/import'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

require "logger"
Rivendell::Import.logger = ActiveRecord::Base.logger = Logger.new("log/test.log")

Rivendell::Import.establish_connection "db/test.sqlite3"

require 'database_cleaner'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  

end
