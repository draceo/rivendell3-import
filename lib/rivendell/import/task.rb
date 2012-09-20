module Rivendell::Import
  class Task < ActiveRecord::Base

    def file=(file)
      if file
        @file = file

        self.file_name = file.name
        self.file_path = file.path
      else
        @file = nil

        self.file_name = self.file_path = nil
      end
    end

    def file
      @file ||= File.new(file_name, :path => file_path)
    end

    def raw_tags
      read_attribute :tags
    end

    def tags
      @tags ||= (raw_tags ? raw_tags.split(",") : [])
    end

    def write_tags
      write_attribute :tags, tags.join(',') if @tags
    end

    def tag(tag)
      self.tags << tag
    end

    before_save :write_tags

    # serialize :cart #, JSON

    def raw_cart
      read_attribute :cart
    end

    def cart
      @cast ||= Cart.new(self).tap do |cart|
        cart.from_json raw_cart if raw_cart
      end
    end

    def write_cart
      write_attribute :cart, (cart.present? ? cart.to_json : nil)
    end

    before_save :write_cart

    def define_default_attributes
      self.status ||= "pending"
    end

    after_initialize :define_default_attributes

    def raw_status
      read_attribute(:status)
    end

    def status
      ActiveSupport::StringInquirer.new(raw_status) if raw_status
    end

    def change_status!(status)
      update_attribute :status, status.to_s
    end

    def self.pending
      where :status => "pending"
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
      read_attribute(:destination) or
        write_attribute(:destination, calculate_destination)
    end

    before_save :destination, :on => :create

    def calculate_destination
      if cart.group
        "Cart in group #{cart.group}" 
      elsif cart.number
        "Cart #{cart.number}"
      end
    end

    def run
      change_status! :running

      logger.info "Run Task #{self.inspect} with #{file.inspect}"
      cart.create
      cart.import file
      cart.update

      change_status! :completed
      save

      logger.debug "Completed #{self.inspect}"

      logger.info "Created Cart #{cart.number}"
    ensure
      unless status.completed?
        change_status! :failed 
        logger.info "Task #{self.inspect} failed"
      end
    end

  end
end
