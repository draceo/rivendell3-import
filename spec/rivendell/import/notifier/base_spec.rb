require 'spec_helper'

describe Rivendell::Import::Notifier::Base do

  subject { Rivendell::Import::Notifier::Test.new }

  describe "#notify" do

    let(:to_sent_notifications) { [mock(:task => mock)] }

    before(:each) do
      subject.stub_chain("notifications.to_sent").and_return(to_sent_notifications)
      to_sent_notifications.stub :includes => to_sent_notifications, :update_all => true 
    end

    it "should notify! tasks of notifications#to_sent" do
      subject.should_receive(:notify!).with to_sent_notifications.map(&:task)
      subject.notify
    end

    let(:now) { Time.now }

    before(:each) do
      Time.stub :now => now
    end

    it "should mark notifications as sent" do
      to_sent_notifications.should_receive(:update_all).with(:sent_at => now)
      subject.notify
    end
    
  end

  describe ".notify" do

    describe "'recipient@domain', :by => :email" do

      subject { Rivendell::Import::Notifier::Base.notify 'recipient@domain', :by => :email }

      it { should be_instance_of(Rivendell::Import::Notifier::Mail) }
      
    end

    it "should reuse an existing Notifier" do
      notifier = Rivendell::Import::Notifier::Base.notify 'recipient@domain', :by => :email
      other_notifier = Rivendell::Import::Notifier::Base.notify 'recipient@domain', :by => :email
      other_notifier.should == notifier
    end

  end

  describe "#key" do
    
    it "should be defined with parameters hash by default" do
      subject.key = nil
      subject.stub :parameters => { :dummy => true }
      subject.save!
      subject.key.should == subject.parameters.hash
    end

  end

end
