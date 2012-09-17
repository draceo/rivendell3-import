require 'spec_helper'

describe Rivendell::Import do

  describe "#config" do
    
    context "without argument" do

      it "should return Rivendell::Import::Config instance" do
        Rivendell::Import.config.should be_instance_of(Rivendell::Import::Config)
      end
                                 
    end

    context "with a block" do
      
      it "should yield block with Config instance" do
        config_instance = Rivendell::Import.config
        Rivendell::Import.should_receive(:config).and_yield(config_instance)
        Rivendell::Import.config { |config| }
      end

      it "should return Config instance" do
        Rivendell::Import.config { |config| }.should == Rivendell::Import.config
      end

    end


  end

end
