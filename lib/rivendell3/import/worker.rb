module Rivendell3::Import
  class Worker

    attr_reader :import

    def initialize(import)
      @import = import
    end

    def start
      Thread.new do
        Rivendell3::Import.logger.debug "Start Worker"
        run
      end

      self
    end

    def run
      loop do
        begin
          task = import.tasks.pop
          if task
            task.run
          else
            # Rivendell::Import.logger.debug "No pending task, sleep 10s"
            sleep 10
          end
        rescue Exception => e
          Rivendell3::Import.logger.error "Worker failed : #{e}"
          sleep 10
        end
      end
    end

  end
end
