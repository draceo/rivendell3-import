module Rivendell::Import
  class Context

    attr_reader :task

    def initialize(task)
      @task = task
    end

    def file
      task.file
    end

    def cart
      task.cart
    end

    def run(&block)
      instance_exec file, &block if block_given?
    end
  end
end
