module Rivendell::Import
  class Tasks

    def pop
      Task.pending.first
    end

    def run
      Task.pending.find_each(&:run)
    end

    def create(file, &block)
      Rivendell::Import::Task.create({:file => file}, {}, &block).tap do |task|
        Rivendell::Import.logger.debug "Created task #{task.inspect}"
      end
    end

  end
end
