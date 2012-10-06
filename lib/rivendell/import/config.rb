module Rivendell::Import
  class Config

    def to_prepare(&block)
      if block_given?
        @prepare = block
      else
        @prepare
      end
    end

    def rivendell
      @rivendell ||= Rivendell.new
    end
    alias_method :xport_options, :rivendell

    class Rivendell

      def host=(host)
        Task.default_xport_options[:host] = host
      end

      def login_name=(login_name)
        Task.default_xport_options[:login_name] = login_name
      end
      alias_method :user=, :login_name=

      def password=(password)
        Task.default_xport_options[:password] = password
      end

    end

  end
end
