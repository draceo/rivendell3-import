module Rivendell3::Import
  class Notification < ActiveRecord::Base

    belongs_to :task
    belongs_to :notifier, :class_name => "Rivendell3::Import::Notifier::Base"

    def sent?
      sent_at.present?
    end

    def self.pending
      where :sent_at => nil
    end

  end
end
