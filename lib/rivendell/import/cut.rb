module Rivendell::Import
  class Cut

    attr_reader :cart

    attr_accessor :number

    def initialize(cart)
      @cart = cart
    end

    def rdxport
      cart.rdxport
    end

    def create
      # rdxport.delete_cuts # if clean cuts is required
      self.number = rdxport.add_cut(cart.number).number unless number
    end

    def update
      # rdxport.edit_cut # to define attributes
    end

  end
end
