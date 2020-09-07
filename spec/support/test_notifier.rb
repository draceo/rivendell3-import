module Rivendell3::Import::Notifier
  class Test < Rivendell3::Import::Notifier::Base

    attr_reader :notified_tasks

    def notified_tasks
      @tasks ||= []
    end

    def notify!(tasks)
      notified_tasks.push *tasks
    end

  end
end
