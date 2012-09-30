module Rivendell::Import::Tasking
  module Status

    def define_default_status
      self.status ||= "pending"
    end

    def self.included(base)
      base.class_eval do
        after_initialize :define_default_status
      end
    end

    def raw_status
      read_attribute(:status)
    end

    def status
      ActiveSupport::StringInquirer.new(raw_status) if raw_status
    end

    def change_status!(status)
      logger.debug "Change status to #{status}"
      update_attribute :status, status.to_s
      notify! if ran?
    end

  end
end
