module Rivendell::Import
  class Cart

    attr_accessor :number, :group
    attr_reader :task

    def initialize(task = nil)
      @task = task
    end

    def xport
      task.xport
    end

    def create
      unless number
        self.number = xport.add_cart(:group => group).number
      end
    end

    def update
      # xport.edit_cart # to define title, etc ...
    end
    
    def cut
      @cut ||= Cut.new(self)
    end

    def import(file)
      cut.create
      xport.import number, cut.number, file.path
      cut.update
    end

  end
end
  
