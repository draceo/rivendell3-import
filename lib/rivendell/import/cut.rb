module Rivendell::Import
  class Cut

    attr_reader :cart

    attr_accessor :number

    def initialize(cart)
      @cart = cart
    end

    def xport
      cart.xport
    end

    def create
      # xport.delete_cuts # if clean cuts is required
      self.number = xport.add_cut(cart.number).number unless number
    end

    def update
      # xport.edit_cut # to define attributes
    end

  end
end
