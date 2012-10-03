require 'spec_helper'

describe Rivendell::Import::CartsCache do

  let(:carts_cache) { Rivendell::Import::CartsCache.new(xport) }
  subject { carts_cache }

  let(:cart) { mock :title => "dummy" }
  let(:carts) { [ cart ] }

  let(:xport) { mock }

  before do
    subject.stub :xport => xport
  end

  describe "#find_all_by_title" do

    let(:options) { Hash.new }

    before do
      subject.stub(:carts).and_return(carts)
    end
    
    it "should use carts with given options" do
      subject.should_receive(:carts).with(options).and_return(carts)
      subject.find_all_by_title("dummy", options)
    end

    it "should select with given title" do
      subject.find_all_by_title(cart.title).should == [ cart ]
    end

    it "should use the given normalizer" do
      normalizer = Proc.new { |s| s.downcase }
      cart.stub :title => "the Title"
      subject.find_all_by_title("The TITLE", :normalizer => normalizer).should == [ cart ]
    end

  end

  describe "#default_normalizer" do

    subject { carts_cache.default_normalizer }

    it "should downcase string" do
      subject.call("ABC").should == "abc"
    end

    it "should replace no alphanumeric characters by space" do
      subject.call("a'b-c").should == "a b c"
    end

    it "should remove double spaces" do
      subject.call("a  b   c").should == "a b c"
    end
    
  end

  describe "#carts" do

    before do
      subject.xport.stub :list_carts => carts
    end
    
    it "should return Xport#list_carts result" do
      subject.carts.should == carts
    end

    it "should cache the result" do
      subject.xport.should_receive(:list_carts).once.and_return(carts)
      2.times { subject.carts }
    end

    it "should reset cache after delay defined by cache_time_to_live" do
      subject.carts # fill cache
      subject.purged_at = Time.now - subject.time_to_live - 1

      subject.xport.should_receive(:list_carts).and_return(carts)
      subject.carts
    end

  end

  describe "#find_by_title" do

    before do
      subject.stub(:carts).and_return(carts)
    end
    
    it "should try an exact match" do
      subject.find_by_title(cart.title).should == cart
    end

    it "should try a match with default normalizer" do
      subject.find_by_title(cart.title.upcase).should == cart
    end

    it "should return nil when no cart matchs" do
      subject.find_by_title("nothing").should be_nil
    end

    it "should return nil when several carts match" do
      carts << cart
      subject.find_by_title(cart.title).should be_nil
    end

  end

end
