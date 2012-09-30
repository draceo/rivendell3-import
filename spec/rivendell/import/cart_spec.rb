require 'spec_helper'

describe Rivendell::Import::Cart do

  let(:task) { mock }
  subject { Rivendell::Import::Cart.new task }

  describe "initialization" do

    it "should use the given task" do
      Rivendell::Import::Cart.new(task).task.should == task
    end
    
  end

  describe "#xport" do

    before(:each) do
      task.stub :xport => mock
    end
    
    it "should be task xport" do
      subject.xport.should == subject.task.xport
    end

  end

  describe "#create" do

    before(:each) do
      subject.stub :xport => mock
    end

    it "should use Xport#add_cart with Cart group" do
      subject.group = "dummy"
      subject.xport.should_receive(:add_cart).with(:group => subject.group).and_return(mock(:number => 123))
      subject.create
    end

    it "should use the number returned by Xport#add_cart" do
      subject.xport.stub(:add_cart).and_return(mock(:number => 123))
      subject.group = "dummy"
      subject.create
      subject.number.should == 123
    end

    context "when number is already definied" do

      before(:each) do
        subject.number = 666
      end

      it "should not invoke Xport#add_cart" do
        subject.xport.stub(:add_cart).and_return(mock(:number => 123))
        subject.create
        subject.number.should == 666
      end
                                                
    end

    context "when group isn't defined" do

      it "should raise an error" do
        subject.group = nil
        lambda { subject.create }.should raise_error
      end
                                         
    end

  end

  describe "#cut" do

    it "should return a Cut associated to this Cart" do
      subject.cut.cart.should == subject
    end

  end

  describe "#import" do

    let(:file) { mock :path => "dummy", :exists? => true }

    before(:each) do
      subject.number = 123
      subject.stub :xport => mock(:import => true)
      subject.cut.stub :create => true, :number => 1, :update => true
    end
    
    it "should create Cut" do
      subject.cut.should_receive :create
      subject.import file
    end

    it "should import file via xport with Cart and Cut numbers" do
      subject.xport.should_receive(:import).with(subject.number, subject.cut.number, file.path)
      subject.import file
    end

    it "should update Cut" do
      subject.cut.should_receive :update
      subject.import file
    end

  end

end
