require 'thread'

module Rivendell::Import
  class Base

    attr_reader :tasks, :workers

    def initialize
      @tasks = Queue.new
      @workers = []
    end

    attr_accessor :to_prepare

    def listen(directory, options = {})
      workers << Worker.new(self).start unless options[:dry_run]

      Rivendell::Import.logger.info "Listen files in #{directory}"
      Listen.to(directory) do |modified, added, removed|
        added.each do |file|
          Rivendell::Import.logger.debug "Detected file '#{file}'"
          file(file, directory)
        end
      end
    end

    def process(*paths)
      paths.flatten.each do |path|
        method = ::File.directory?(path) ? :directory : :file
        send method, path
      end
    end

    def file(file, base_directory = nil)
      create_task Rivendell::Import::File.new(file, :base_directory => base_directory)
    end

    def directory(directory)
      Dir[::File.join(directory, "**/*")].each do |file|
        file(file, directory) if ::File.file?(file)
      end
    end

    def create_task(file)
      Rivendell::Import.logger.debug "Create task for #{file}"
      tasks << prepared_task(Rivendell::Import::Task.new(file))
    end

    def prepared_task(task)
      task.prepare(&to_prepare) if to_prepare
      Rivendell::Import.logger.debug task
      task
    end

    def run_tasks
      tasks.pop(false).run until tasks.empty?
    end

  end
end
