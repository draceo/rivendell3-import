require 'thread'

module Rivendell::Import
  class Base

    attr_reader :tasks, :workers

    def initialize
      @tasks = Tasks.new
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

    def file(path, base_directory = nil)
      file = Rivendell::Import::File.new(path, :base_directory => base_directory)
      create_task file
    end

    def directory(directory)
      Dir[::File.join(directory, "**/*")].each do |file|
        file(file, directory) if ::File.file?(file)
      end
    end

    def create_task(file)
      Rivendell::Import.logger.debug "Create task for #{file}"
      tasks.create(file) do |task|
        prepare_task task
      end
    end

    def prepare_task(task)
      task.prepare(&to_prepare) if to_prepare
    end

  end
end
