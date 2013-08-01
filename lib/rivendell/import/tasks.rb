module Rivendell::Import
  class Tasks

    def pop
      ready_tasks.first
    end

    def run
      ready_tasks.each(&:run)
    end

    def ready_tasks
      Task.ready
    end

    def create(file, &block)
      Rivendell::Import::Task.create({:file => file}, {}, &block).tap do |task|
        Rivendell::Import.logger.debug "Created task #{task.inspect}"
      end
    end

  end
end
