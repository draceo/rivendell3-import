require 'spec_helper'

describe Rivendell::Import::Tasks do

  let(:task) { mock }

  describe "#push" do
    
    it "should add task to queue" do
      subject.push task
      subject.pop.should == task
    end

    it "should add task to list" do
      subject.push task
      subject.to_a.should == [ task ]
    end

  end

  describe "#pending?" do
    
    it "should be true when queue is not empty?" do
      subject.push task
      subject.should be_pending
    end

    it "should be false when queue is empty?" do
      subject.should_not be_pending
    end

  end

  describe "#run" do
    
    it "should run each task" do
      task.should_receive(:run)
      subject.push task
      
      subject.run
    end

  end

end
