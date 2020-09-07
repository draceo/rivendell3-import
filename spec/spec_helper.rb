require 'simplecov-default'

require 'rivendell3/import'

require "logger"
Rivendell3::Import.logger = ActiveRecord::Base.logger = Logger.new("log/test.log")

require 'tmpdir'
require 'active_support'

Rivendell3::Import.establish_connection "db/test.sqlite3"

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}
