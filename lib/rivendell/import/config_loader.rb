module Rivendell::Import
  class ConfigLoader

    attr_accessor :file, :auto_reload
    alias_method :auto_reload?, :auto_reload

    def initialize(file, auto_reload = false)
      self.file = file
      self.auto_reload = auto_reload

      listen_file if auto_reload?
    end

    def load
      Kernel.load file
    end

    def listen_file
      callback = Proc.new do |modified, added, removed|
        if modified.include? absolute_path
          Rivendell::Import.logger.info "Configuration changed, reload it"
          load 
        end
      end

      Rivendell::Import.logger.info "Listen to config file changes (#{file})"
      Listen.to(directory).filter(/^#{basename}$/).change(&callback).start(false)
    end

    def absolute_path
      ::File.expand_path(file)
    end

    def basename
      ::File.basename(file)
    end

    def directory
      ::File.dirname(file)
    end

  end
end
