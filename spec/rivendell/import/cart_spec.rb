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

    context "when number is already defined" do

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
      subject.stub :cut => mock.as_null_object, :xport => mock.as_null_object
    end

    it "should create Cut" do
      subject.cut.should_receive :create
      subject.import file
    end

    it "should import file via xport with Cart and Cut numbers" do
      subject.xport.should_receive(:import).with(subject.number, subject.cut.number, file.path, {})
      subject.import file
    end

    it "should use import options if specified" do
      subject.import_options[:dummy] = true
      subject.xport.should_receive(:import).with(subject.number, subject.cut.number, file.path, subject.import_options)
      subject.import file
    end

    it "should update Cut" do
      subject.cut.should_receive :update
      subject.import file
    end

    context "clear_cuts has been defined" do
      before do
        subject.clear_cuts!
      end

      it "should invoke Xport#clear_cuts before create a new cut" do
        subject.xport.should_receive(:clear_cuts).ordered.with(subject.number)
        subject.xport.should_receive(:import).ordered
        subject.import file
      end
    end

    context "clear_cuts hasn't been defined" do
      it "should not invoke Xport#clear_cuts" do
        subject.xport.should_not_receive(:create_cuts).with(subject.number)
        subject.import file
      end
    end

  end

  describe "#find_by_title" do

    let(:cart) { mock :title => "The Title of the Cart", :number => 123 }

    before(:each) do
      subject.stub_chain("xport.list_carts").and_return([cart])
    end

    it "should find an exact title" do
      subject.find_by_title(cart.title)
      subject.number.should == cart.number
    end

    it "should find with a 'matching' filename ('the-title_of_the Cart' for 'The Title of the Cart')" do
      subject.find_by_title("the-title_of_the Cart")
      subject.number.should == cart.number
    end

    it "should use specified options to find carts" do
      subject.xport.should_receive(:list_carts).with(:group => "TEST").and_return([cart])
      subject.find_by_title("dummy", :group => "TEST")
    end

    it "should add the import option :use_metadata => false" do
      subject.find_by_title(cart.title)
      subject.import_options[:use_metadata].should be_false
    end

  end

  describe "#clear_cuts!" do

    before do
      subject.number = 123
    end

    it "should set flag clear_cuts" do
      subject.clear_cuts!
      subject.clear_cuts.should be_true
    end

  end

end
