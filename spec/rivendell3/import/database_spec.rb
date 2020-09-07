require 'spec_helper'

describe Rivendell3::Import::Database do

  it "should be enabled when url is defined" do
    Rivendell3::Import::Database.url = "dummy"
    Rivendell3::Import::Database.should be_enabled
  end

  after do
    Rivendell3::Import::Database.url = nil
  end

end
