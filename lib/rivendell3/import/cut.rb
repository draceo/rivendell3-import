module Rivendell3::Import
  class Cut

    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON

    attr_reader :cart

    attr_accessor :number
    attr_accessor :description, :outcue, :isrc, :isci

    attr_accessor :start_datetime, :end_datetime
    attr_accessor :start_daypart, :end_daypart
    attr_accessor :days, :sun, :mon, :tue, :wed, :thu, :fri, :sat

    def initialize(cart)
      @cart = cart
    end

    # def start_datetime
    #   DateTime.parse @start_datetime
    # end
    #
    # def start_datetime=(arg)
    #   @start_datetime = arg.strftime("%Y-%m-%d %H:%M:%S%z")
    # end
    #
    # def end_datetime
    #   DateTime.parse @end_datetime
    # end
    #
    # def end_datetime=(arg)
    #   @end_datetime = arg.strftime("%Y-%m-%d %H:%M:%S%z")
    # end

    def as_json(options = {})
      super(options.merge(:root => false)).tap do |as_json|
        as_json.each do |k,v|
          #as_json[k] = {"json_class":"Range","data":[v.begin, v.end,false]} if v.is_a?(Range)
          as_json[k] = [v.begin, v.end] if v.is_a?(Range)
          as_json[k] = DateTime.parse(v).strftime("%FT%T%:z") if !v.blank? && %w{start_datetime end_datetime}.include?(k)
        end
      end
    end

    def attributes
      %w{description outcue isrc isci start_datetime end_datetime start_daypart end_daypart days sun mon tue wed thu fri sat}.inject({}) do |map, attribute|
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
      Rivendell3::Import.logger.debug "Create Cut for Cart #{cart.number}"
      self.number = xport.add_cut(cart.number).number unless number
    end

    def name
      "%06d_%03d" % [cart.number, number]
    end

    def api_attributes
      attributes.delete_if { |_,v| v.blank? }
    end

    def api_attributes?
      api_attributes.present?
    end

    def update
      Rivendell3::Import.logger.debug "Change Cut #{number} via API #{api_attributes.inspect}"
      xport.edit_cut cart.number, number, api_attributes
    end

    def datetime
      unless @start_datetime.blank? or @end_datetime.blank?
        DateTime.parse(@start_datetime.to_s)..DateTime.parse(@end_datetime.to_s)
      else
        nil
      end
    end

    def datetime=(datetime)
      datetime = (DateTime.parse datetime.first)..(DateTime.parse datetime.last) if Array === datetime
      #datetime = Time.parse(datetime.begin)..Time.parse(datetime.end) if String === datetime.first
      if Range === datetime
        @start_datetime = datetime.begin
        @end_datetime = datetime.end
      elsif Array === datetime
        @start_datetime = datetime.first
        @end_datetime = datetime.last
      else
        raise ArgumentError, "datetime format not recognized"
      end
    end

    def daypart
      unless @start_daypart.blank? or @end_daypart.blank?
        @start_daypart..@end_daypart
      else
        nil
      end
    end

    def daypart=(daypart)
      daypart = (daypart.first)..(daypart.last) if Array === daypart
      if Range === daypart
        @start_daypart = daypart.begin
        @end_daypart = daypart.end
      elsif Array === daypart
        @start_daypart = daypart.first
        @end_daypart = daypart.last
      else
        raise ArgumentError, "daypart format not recognized"
      end
    end

    def method_missing(name, *arguments)
      underscored_name = name.to_s.underscore
      if respond_to?(underscored_name)
        send underscored_name, *arguments
      elsif %w{mon tue wed thu fri sat sun}.include? name
        @days.include? name if @days === Array
      else
        super
      end
    end

    # def days
    #   d = []
    #   d << "sun" if @sun
    #   d << "mon" if @mon
    #   d << "tue" if @tue
    #   d << "wed" if @wed
    #   d << "thu" if @thu
    #   d << "fri" if @fri
    #   d << "sat" if @sat
    #   d
    # end
    #
    # def days=
    #
    # end

  end
end
