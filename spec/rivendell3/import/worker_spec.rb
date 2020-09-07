require 'spec_helper'

describe Rivendell3::Import::Worker do

  let(:import) { Rivendell3::Import::Base.new }
  subject { Rivendell3::Import::Worker.new import }

  let(:file) { Rivendell3::Import::File.new "dummy.wav" }

  describe "initialization" do

    it "should use the given Import" do
      Rivendell3::Import::Worker.new(import).import.should == import
    end

  end

  it "should run Import tasks in a separated Thread" do
    pending "Transaction masks changes for Worker"
    import.tasks.create file
    subject.start
    sleep 0.5
    import.tasks.should_not be_pending
  end

end
