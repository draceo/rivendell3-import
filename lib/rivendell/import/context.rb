module Rivendell::Import
  class Context

    attr_reader :task

    def initialize(task)
      @task = task
    end

    delegate :file, :cart, :logger, :to => :task

    def with(expression)
      yield if file.match expression
    end

    def run(&block)
      instance_exec file, &block if block_given?
    end

  end
end
