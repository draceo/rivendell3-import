require 'spec_helper'

describe Rivendell::Import::Task do

  let(:file) { Rivendell::Import::File.new("dummy.wav") }
  subject { Rivendell::Import::Task.new file }

  describe "#file" do
   
    it "should return a file with specified path" do
      Rivendell::Import::Task.new(file).file.should == file
    end

  end

  describe "#cart" do
    
    it "should return a Cart associated to the task" do
      subject.cart.task.should == subject
    end

  end

  describe "#xport" do
    
    it "should return a instance of Rivendell::API::Xport" do
      subject.xport.should be_instance_of(Rivendell::API::Xport)
    end

  end

  describe "#prepare" do
    
    it "should return the Task" do
      subject.prepare { |file| } .should == subject
    end

    it "should invoke the specified block with Task file" do
      given_file = nil
      subject.prepare do |file| 
        given_file = file
      end
      given_file.should == subject.file
    end

  end

  describe "#run" do

    before(:each) do
      subject.stub :cart => mock(:create => true, :import => true, :update => true, :number => 123, :destination => "dummy")
    end
    
    it "should create Cart" do
      subject.cart.should_receive(:create)
      subject.run
    end

    it "should import File in Cart" do
      subject.cart.should_receive(:import).with(subject.file)
      subject.run
    end

    it "should update Cart" do
      subject.cart.should_receive(:update)
      subject.run
    end

  end


end
