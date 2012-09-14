module Rivendell::Import
  class Task

    attr_reader :file

    def initialize(path)
      @file = File.new(path)
    end

    def cart
      @cart ||= Cart.new(self)
    end

    def rdxport
      @rdxport ||= Rivendell::API::Xport.new
    end

    def config(&block)
      Context.new(self).run(&block)
      self
    end

    def run
      puts "Run Task #{self.inspect} with #{file.inspect}"
      cart.create
      cart.import file
      cart.update
      puts "Created Cart #{cart.number}"
    end

  end
end
