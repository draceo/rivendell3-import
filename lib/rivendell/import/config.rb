module Rivendell::Import
  class Config

    def to_prepare(&block)
      if block_given?
        @prepare = block
      else
        @prepare
      end
    end

  end
end
