module Rivendell3::Import
  module Database

    mattr_accessor :url

    def self.enabled?
      url.present?
    end

    @@initialized = false
    def self.init
      raise "Database not enabled (no config.rivendell.db_url defined)" unless enabled?

      unless @@initialized
        Rivendell3::DB.establish_connection(url)
        @@initialized = true
      end
    end

  end
end
