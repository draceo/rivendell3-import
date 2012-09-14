module Rivendell::Import
  class CLI
    def run(arguments)
      unless arguments.empty?
        import = Rivendell::Import::Base.new

        if arguments.first == "--config"
          arguments.shift
          load arguments.shift
        end

        import.prepare_proc = Rivendell::Import.prepare_proc

        if arguments.first == "--listen"
          listen_mode = true
          arguments.shift
        end

        group = arguments.shift

        config = Proc.new do |file|
          cart.group = group
        end

        path = arguments.shift
        if ::File.directory?(path)
          if listen_mode
            import.listen(path, &config)
          else
            import.directory(path, &config)
          end
        else
          import.file(path,&config)
        end

        import.tasks.each(&:run)
      end
    end
  end
end
