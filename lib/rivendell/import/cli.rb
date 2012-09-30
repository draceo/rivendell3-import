require 'trollop'
require 'logger'

module Rivendell::Import
  class CLI

    attr_reader :arguments
    attr_accessor :options_count

    def initialize(arguments = [])
      @arguments = arguments
    end

    def config_file
      @config_file ||= options[:config]
    end

    def listen_mode?
      options[:listen]
    end

    def dry_run?
      options[:dry_run]
    end

    def debug?
      options[:debug]
    end

    def database
      options[:database]
    end

    def parser
      @parser ||= Trollop::Parser.new do
        opt :config, "Configuration file", :type => String
        opt :listen, "Wait for files in given directory"
        opt :dry_run, "Just create tasks without executing them"
        opt :debug, "Enable debug messages (in stderr)"
        opt :database, "The database file used to store tasks", :type => String
      end
    end

    def options
      @options ||= Trollop::with_standard_exception_handling(parser) do
        raise Trollop::HelpNeeded if ARGV.empty? # show help screen
        parser.parse arguments
      end
    end
    alias_method :parse, :options

    def parsed_parser
      parse
      parser
    end

    def import
      @import ||= Rivendell::Import::Base.new
    end

    def paths
      parsed_parser.leftovers
    end

    def run
      Rivendell::Import.logger = Logger.new($stderr) if debug?

      if database
        Rivendell::Import.establish_connection database
      else
        Rivendell::Import.establish_connection
      end

      if config_file
        load config_file 
        import.to_prepare = Rivendell::Import.config.to_prepare
      end

      if listen_mode?
        listen_options = {}
        listen_options[:dry_run] = true if dry_run?

        import.listen paths.first, listen_options
      else
        import.process paths
        import.tasks.run unless dry_run?
      end
    end
  end
end
