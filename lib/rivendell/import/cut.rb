module Rivendell::Import
  class Cut

    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON

    attr_reader :cart

    attr_accessor :number
    attr_accessor :datetime
    attr_accessor :daypart
    attr_accessor :days

    def initialize(cart)
      @cart = cart
    end

    def as_json(options = {})
      super options.merge(:root => false)
    end

    def attributes
      %w{datetime daypart days}.inject({}) do |map, attribute|
        value = send attribute
        map[attribute] = value if value
        map
      end
    end

    def attributes=(attributes)
      attributes.each { |k,v| send "#{k}=", v }
    end

    def xport
      cart.xport
    end

    def create
      Rivendell::Import.logger.debug "Create Cut for Cart #{cart.number}"
      self.number = xport.add_cut(cart.number).number unless number
    end

    def name
      "%06d_%03d" % [cart.number, number]
    end

    def db_attributes?
      [datetime, daypart, days].any? &:present?
    end

    def update
      if db_attributes?
        Rivendell::Import.logger.debug "Save Cut db attributes #{inspect}"
        Database.init

        db_cut = Rivendell::DB::Cut.get(name)
        if datetime
          db_cut.start_datetime, db_cut.end_datetime = datetime.begin, datetime.end
        end
        if daypart
          db_cut.start_daypart, db_cut.end_daypart = daypart.begin, daypart.end
        end
        if days
          db_cut.days = days
        end

        Rivendell::Import.logger.debug "Change Cut #{number} in DB #{db_cut.inspect}"

        db_cut.save
      end
    end

  end
end
