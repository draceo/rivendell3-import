require 'spec_helper'

describe Rivendell::Import::Config do

  describe "#to_prepare" do

    let(:user_block) { Proc.new {} }
    
    it "should define to_prepare proc with given block" do
      subject.to_prepare(&user_block)
      subject.to_prepare.should == user_block
    end

  end

end
