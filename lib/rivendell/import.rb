require "rivendell/import/version"

require "null_logger"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/module/delegation"
require "active_support/core_ext/enumerable"

require "rivendell/import/config"

module Rivendell
  module Import

    @@config = Config.new
    def self.config(&block)
      yield @@config if block_given?
      @@config
    end

    @@logger = NullLogger.instance
    mattr_accessor :logger

    def self.establish_connection(file = "db.sqlite3")
      ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => file
      ActiveRecord::Migrator.migrate(::File.expand_path("../../../db/migrate/", __FILE__), nil)
    end

  end
end

require 'listen'

require 'active_record'
ActiveRecord::Base.include_root_in_json = false

require "rivendell/api"

require "rivendell/import/worker"
require "rivendell/import/task"
require "rivendell/import/tasks"
require "rivendell/import/base"
require "rivendell/import/cart"
require "rivendell/import/context"
require "rivendell/import/cut"
require "rivendell/import/file"
require "rivendell/import/notification"
require "rivendell/import/notifier/base"
require "rivendell/import/notifier/mail"
