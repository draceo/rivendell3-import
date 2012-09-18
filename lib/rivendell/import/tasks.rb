module Rivendell::Import
  class Tasks

    include Enumerable

    def initialize()
      @all = []
      @queue = Queue.new
    end

    def push(task)
      all << task
      queue << task
    end
    alias_method :<<, :push

    def pending?
      not queue.empty?
    end

    delegate :pop, :to => :queue
    delegate :each, :to => :all

    attr_reader :all, :queue
    private :all, :queue

    def run
      each(&:run)
    end

    def create(file, &block)
      Rivendell::Import::Task.new(file).tap do |task|
        yield task
        push task
      end
    end

  end
end
