require 'rivendell/import/tasking/file'
require 'rivendell/import/tasking/tags'
require 'rivendell/import/tasking/cart'
require 'rivendell/import/tasking/status'
require 'rivendell/import/tasking/destination'

module Rivendell::Import
  class Task < ActiveRecord::Base
    include Rivendell::Import::Tasking::File
    include Rivendell::Import::Tasking::Tags
    include Rivendell::Import::Tasking::Cart
    include Rivendell::Import::Tasking::Status
    include Rivendell::Import::Tasking::Destination
    
    def self.pending
      where :status => "pending"
    end

    def self.ran
      where :status => %w{completed failed}
    end

    def ran?
      status.completed? or status.failed?
    end

    @@default_xport_options = {}
    cattr_accessor :default_xport_options

    def xport_options
      @xport_options ||= default_xport_options.dup
    end

    def xport
      @xport ||= Rivendell::API::Xport.new(xport_options)
    end

    def prepare(&block)
      begin
        Context.new(self).run(&block)
      rescue => e
        logger.error "Task preparation failed : #{e}"
      end
      self
    end

    def logger
      Rivendell::Import.logger
    end

    def to_s
      "Import '#{file}' in #{destination}"
    end

    has_many :notifications
    has_many :notifiers, :through => :notifications

    def notify!
      notifiers.each do |notifier|
        notifier.notify
      end
    end
    after_status_changed :notify!, :on => [:completed, :failed]

    def destroy_file!
      file.destroy! if delete_file?
    end

    def run
      logger.debug "Run #{self.inspect}"
      change_status! :running

      reset_destination!

      cart.create
      cart.import file
      cart.update

      destroy_file!
      change_status! :completed

      logger.info "Imported Cart #{cart.number}"
    rescue Exception => e
      logger.error "Task failed : #{e}"
    ensure
      unless status.completed?
        change_status! :failed 
      end
      save!
    end

  end
end
