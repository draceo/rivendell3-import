module Rivendell::Import
  class Base

    attr_reader :tasks

    def initialize
      @tasks = []
    end

    attr_accessor :prepare_proc

    def listen(directory, options = {}, &block) 
      Listen.to(directory) do |modified, added, removed|
        added.each do |file|
          create_task file, &block
        end
      end      
    end

    def file(file,&block)
      create_task file, &block
    end

    def directory(directory,&block)
      Dir[::File.join(directory, "**/*")].each do |file|
        create_task file, &block
      end
    end

    def create_task(file, &block)
      tasks << prepared_task(Rivendell::Import::Task.new(file), &block)
    end

    def prepared_task(task, &block)
      task.config(&prepare_proc) if prepare_proc
      task.config(&block) if block_given?
      
      task
    end

  end
end
