require "rivendell3/import/version"

require "null_logger"
require "active_support/core_ext/enumerable"
require "active_support/core_ext/hash/except"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/module/delegation"
require "active_support/hash_with_indifferent_access"
require 'taglib'

require "rivendell3/import/config"

class Range
  def to_json(*a)
    {
      'json_class'   => self.class.name, # = 'Range'
      'data'         => [ first, last, exclude_end? ]
    }.to_json(*a)
  end
end

class Range
  def self.json_create(o)
    new(*o['data'])
  end
end

module Rivendell3
  module Import

    @@config = Config.new
    def self.config(&block)
      yield @@config if block_given?
      @@config
    end

    @@logger = NullLogger.instance
    mattr_accessor :logger

    def self.schema_migrations
      ActiveRecord::SchemaMigration.tap do |sm|
        sm.create_table
      end
    end

    def self.establish_connection(file_or_uri)

      database_spec =
        if [nil, "file"].include? URI.parse(file_or_uri).scheme
          { :adapter => "sqlite3", :database => file_or_uri }
        else
          file_or_uri
        end

      ActiveRecord::Base.establish_connection database_spec
      migration_directory = ::File.expand_path("../../../db/migrate/", __FILE__)
      migrator = ActiveRecord::MigrationContext.new(migration_directory, schema_migrations)
      migrator.migrate
    end

    class GroupMissing < ArgumentError; end
  end
end

require 'listen'

require 'active_record'
ActiveRecord::Base.include_root_in_json = false

require "rivendell3/api"

require "rivendell3/import/config"
require "rivendell3/import/config_loader"
require "rivendell3/import/worker"
require "rivendell3/import/task"
require "rivendell3/import/tasks"
require "rivendell3/import/base"
require "rivendell3/import/database"
require "rivendell3/import/cart_finder"
require "rivendell3/import/cart"
require "rivendell3/import/context"
require "rivendell3/import/cut"
require "rivendell3/import/file"
require "rivendell3/import/notification"
require "rivendell3/import/notifier/base"
require "rivendell3/import/notifier/mail"

# TODO Rivendell3::Import::CartFinder::ByDb should be optional
#require 'rivendell3/db'
#require 'rivendell3/import/cart_finder_by_db'
