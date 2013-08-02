module Rivendell::Import
  class Cart

    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON

    def attributes
      %w{number group clear_cuts? title default_title}.inject({}) do |map, attribute|
        value = send attribute
        map[attribute] = value if value
        map
      end
    end

    def attributes=(attributes)
      attributes.each { |k,v| send "#{k}=", v }
    end

    delegate :blank?, :to => :attributes

    attr_accessor :number, :group, :title, :default_title
    attr_reader :task

    def initialize(task = nil)
      @task = task
    end

    def xport
      task.xport
    end

    def create
      unless number
        raise "Can't create Cart, Group isn't defined" unless group.present?
        self.number = xport.add_cart(:group => group).number
      end
    end

    def update
      update_attributes = attributes.dup

      if default_title
        current_cart = xport.list_cart(number)
        unless current_cart.has_title?
          update_attributes[:title] = default_title
        end
      end

      xport.edit_cart number, update_attributes
    end

    def cut
      @cut ||= Cut.new(self)
    end

    def import(file)
      raise "File #{file.path} not found" unless file.exists?

      cut.create
      xport.clear_cuts number if clear_cuts?
      xport.import number, cut.number, file.path
      cut.update
    end

    def find_by_title(string, options = {})
      if remote_cart = cart_finder.find_by_title(string, options)
        self.number = remote_cart.number
      end
    end

    attr_accessor :clear_cuts
    alias_method :clear_cuts?, :clear_cuts

    def clear_cuts!
      self.clear_cuts = true
    end

    @db_url = nil
    cattr_accessor :db_url

    def cart_finder
      @cart_finder ||=
        begin
          unless db_url
            Rivendell::Import::CartFinder::ByApi.new xport
          else
            Rivendell::DB.establish_connection(db_url)
            Rivendell::Import::CartFinder::ByDb.new
          end
        end
    end

  end
end
