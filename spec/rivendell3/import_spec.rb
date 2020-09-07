require 'spec_helper'

describe Rivendell3::Import do

  describe ".config" do

    context "without argument" do

      it "should return Rivendell3::Import::Config instance" do
        Rivendell3::Import.config.should be_instance_of(Rivendell3::Import::Config)
      end

    end

    context "with a block" do

      it "should yield block with Config instance" do
        config_instance = Rivendell3::Import.config
        Rivendell3::Import.should_receive(:config).and_yield(config_instance)
        Rivendell3::Import.config { |config| }
      end

      it "should return Config instance" do
        Rivendell3::Import.config { |config| }.should == Rivendell3::Import.config
      end

    end

  end

  describe ".establish_connection" do

    before do
      ActiveRecord::Base.stub :establish_connection
      ActiveRecord::Migrator.stub :migrate
    end

    context "when a file is given" do

      let(:file) { '/srv/rivendell/tmp/db.sqlite3' }

      it "should initialize a sqlite database" do
        ActiveRecord::Base.should_receive(:establish_connection).with({ :adapter => "sqlite3", :database => file })
        Rivendell3::Import.establish_connection file
      end

    end

    context "when an url is given" do

      let(:url) { 'mysql://import:import@localhost/import' }

      it "should initialize database with given url" do
        ActiveRecord::Base.should_receive(:establish_connection).with(url)
        Rivendell3::Import.establish_connection url
      end

    end

    it "should migrate database" do
      migrator = double("migrator")
      allow(migrator).to receive(:migrate)
      expect(ActiveRecord::Migrator).to receive(:new).with(:up, anything, anything, nil).and_return(migrator)
      expect(migrator).to receive(:migrate)
      Rivendell3::Import.establish_connection '/srv/rivendell/tmp/db.sqlite3'
    end

  end

end
