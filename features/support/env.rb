$: << File.dirname(__FILE__) + "/../../lib"

require "rivendell/import"

require "logger"
Rivendell::Import.logger = Logger.new("log/cucumber.log")

