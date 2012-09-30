require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/db/"
end

require 'rivendell/import'

require "logger"
Rivendell::Import.logger = ActiveRecord::Base.logger = Logger.new("log/test.log")

Rivendell::Import.establish_connection "db/test.sqlite3"

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

