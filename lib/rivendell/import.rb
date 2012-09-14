require "rivendell/import/version"

module Rivendell
  module Import

    @@prepare_block = nil

    def self.prepare(&block)
      @@prepare_block = block
    end

    def self.prepare_proc
      @@prepare_block
    end

  end
end

require 'listen'
require "rivendell/api"

require "rivendell/import/base"
require "rivendell/import/cart"
require "rivendell/import/context"
require "rivendell/import/cut"
require "rivendell/import/file"
require "rivendell/import/task"
