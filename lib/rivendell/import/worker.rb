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
        task.run
      end
    end

  end
end
