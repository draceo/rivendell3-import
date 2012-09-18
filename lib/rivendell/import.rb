require "rivendell/import/version"

require "null_logger"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/module/delegation"

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

  end
end

require 'listen'
require "rivendell/api"

require "rivendell/import/worker"
require "rivendell/import/task"
require "rivendell/import/tasks"
require "rivendell/import/base"
require "rivendell/import/cart"
require "rivendell/import/context"
require "rivendell/import/cut"
require "rivendell/import/file"
