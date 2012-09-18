module Rivendell::Import
  class Task

    attr_reader :file

    def initialize(file = nil)
      @file = file
    end

    def cart
      @cart ||= Cart.new(self)
    end

    def xport
      @xport ||= Rivendell::API::Xport.new
    end

    def prepare(&block)
      Context.new(self).run(&block)
      self
    end

    def logger
      Rivendell::Import.logger
    end

    def to_s
      "Import '#{file}' in #{destination}"
    end

    def destination
      "Cart in group #{cart.group}" if cart.group
    end

    def run
      logger.info "Run Task #{self.inspect} with #{file.inspect}"
      cart.create
      cart.import file
      cart.update
      logger.info "Created Cart #{cart.number}"
    end

  end
end
