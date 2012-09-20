require 'spec_helper'

describe Rivendell::Import::Tasks do

  let(:file) { Rivendell::Import::File.new "dummy.wav" }

  describe "#pending?" do
    
    it "should be true when a task is pending" do
      subject.create file
      subject.should be_pending
    end

    it "should be false when queue is empty?" do
      subject.should_not be_pending
    end

  end

  describe "#run" do
    
    it "should run each task" do
      task = subject.create(file)
      subject.run rescue nil
      task.reload.status.should_not be_pending
    end

  end

end
