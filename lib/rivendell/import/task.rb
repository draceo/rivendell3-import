module Rivendell::Import
  class Task

    attr_reader :file, :tags

    def initialize(file = nil)
      @file = file
      @tags = []
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
      if cart.group
        "Cart in group #{cart.group}" 
      elsif cart.number
        "Cart #{cart.number}"
      end
    end

    def run
      logger.info "Run Task #{self.inspect} with #{file.inspect}"
      cart.create
      cart.import file
      cart.update
      logger.info "Created Cart #{cart.number}"
    end

    def tag(tag)
      self.tags << tag
    end

  end
end
