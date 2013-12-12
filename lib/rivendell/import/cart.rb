module Rivendell::Import
  class Cart

    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON

    def as_json(options = {})
      super options.merge(:root => false)
    end

    def attributes
      attributes = {}
      %w{number group clear_cuts title default_title import_options}.each do |attribute|
        value = send attribute
        attributes[attribute] = value if value.present?
      end
      if (cut_attributes = cut.attributes).present?
        attributes["cut"] = cut_attributes
      end
      attributes
    end

    def attributes=(attributes)
      attributes.each do |k,v|
        unless k == "cut"
          send "#{k}=", v
        else
          cut.attributes = v
        end
      end
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

    attr_accessor :import_options
    def import_options
      @import_options ||= {}
    end

    def import(file)
      raise "File #{file.path} not found" unless file.exists?

      if clear_cuts?
        Rivendell::Import.logger.debug "Clear cuts of Cart #{number}"
        xport.clear_cuts number
      end
      cut.create

      Rivendell::Import.logger.debug "Import #{file.path} in Cut #{cut.number}"
      xport.import number, cut.number, file.path, import_options
      cut.update
    end

    def find_by_title(string, options = {})
      Rivendell::Import.logger.debug "Looking for a Cart '#{string}'"
      if remote_cart = cart_finder.find_by_title(string, options)
        Rivendell::Import.logger.debug "Found Cart #{remote_cart.number}"
        self.number = remote_cart.number
        self.import_options[:use_metadata] = false
      end
    end

    attr_accessor :clear_cuts
    alias_method :clear_cuts?, :clear_cuts

    def clear_cuts!
      self.clear_cuts = true
    end

    def cart_finder
      @cart_finder ||=
        unless Database.enabled?
          Rivendell::Import::CartFinder::ByApi.new xport
        else
          Rivendell::Import::CartFinder::ByDb.new
        end
    end

  end
end
