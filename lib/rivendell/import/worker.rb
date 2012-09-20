module Rivendell::Import
  class Worker

    attr_reader :import

    def initialize(import)
      @import = import
    end

    def start
      Thread.new do 
        Rivendell::Import.logger.debug "Start Worker"
        run 
      end

      self
    end

    def run
      loop do
        task = import.tasks.pop
        if task
          task.run
        else
          Rivendell::Import.logger.debug "No pending task, sleep 10s"
          sleep 10
        end
      end
    rescue => e
      Rivendell::Import.logger.error "Worker failed : #{e}"
    end

  end
end
