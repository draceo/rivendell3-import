module Rivendell::Import
  class Cart

    attr_accessor :number, :group
    attr_reader :task

    def initialize(task)
      @task = task
    end

    def rdxport
      task.rdxport
    end

    def create
      unless number
        self.number = rdxport.add_cart(:group => group).number
      end
    end

    def update
      # rdxport.edit_cart # to define title, etc ...
    end
    
    def cut
      @cut ||= Cut.new(self)
    end

    def import(file)
      cut.create
      rdxport.import number, cut.number, file.path
      cut.update
    end

  end
end
  
