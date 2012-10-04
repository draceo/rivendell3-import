require 'spec_helper'

describe Rivendell::Import::Task do

  let(:file) { Rivendell::Import::File.new("dummy.wav") }
  subject { Rivendell::Import::Task.new :file => file }

  describe "#file" do
   
    it "should return a file with specified path" do
      Rivendell::Import::Task.new(:file => file).file.should == file
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
      subject.stub :destination => "test"
      subject.stub :cart => mock(:create => true, :import => true, :update => true, :number => 123, :to_json => '')
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

    it "should change the status to completed" do
      subject.run
      subject.status.should be_completed
    end

    it "should change the status to failed if an error is raised" do
      subject.cart.stub(:create).and_raise("dummy")
      subject.run
      subject.status.should be_failed
    end

  end

  describe "#destination" do
    
    it "should return 'Cart in group :group' if cart#group is defined" do
      subject.cart.group = 'dummy'
      subject.destination.should == "Cart in group dummy"
    end

    it "should return 'Cart :number' if cart#number is defined" do
      subject.cart.number = 123
      subject.destination.should == "Cart 123"
    end

  end

  describe "#tags" do
    
    it "should be empty by default" do
      subject.tags.should be_empty
    end

  end

  describe "#tag" do
    
    it "should add the given tag" do
      subject.tag "dummy"
      subject.tags.should == %w{dummy}
    end
    
  end

  describe "storage" do

    it "should store destination" do
      subject.cart.number = 123
      subject.save
      subject.destination.should == Rivendell::Import::Task.find(subject).destination
    end

    it "should store tags separated with commas" do
      subject.tags << "tag1" << "tag2"
      subject.save
      Rivendell::Import::Task.find(subject).raw_tags.should == "tag1,tag2"
    end

    it "should store cart" do
      subject.cart.number = 123
      subject.save
      Rivendell::Import::Task.find(subject).cart.number.should == 123
    end
    
  end

  describe "#status" do
    
    it "should be include in pending, completed, failed" do
      pending
      # subject.should validate_inclusion_of(:status, :in => %w{pending running completed failed})
    end

    it "should be pending by default" do
      subject.status.should be_pending
    end

  end

  describe "#notifications" do
    
    before(:each) do
      subject.save!
    end

    it "should be empty by default" do
      subject.notifications.should be_empty
    end

  end

  describe "#notifiers" do

    before(:each) do
      subject.save!
    end

    let(:notifier) { Rivendell::Import::Notifier::Test.create! }
    
    it "should create a Notification when a Notifier is added" do
      subject.notifiers << notifier
      subject.notifications.first.notifier.should == notifier
    end

  end

  describe "#notify!" do
    
    before(:each) do
      subject.status = "completed"
      subject.save!
      subject.notifiers << notifier
    end

    let(:notifier) { Rivendell::Import::Notifier::Test.create! }
    
    it "should notify task with all associated notifiers" do
      subject.notify!
      notifier.notified_tasks.should == [ subject ]
    end

    it "should mark notification as sent" do
      subject.notify!
      subject.notifications.first.should be_sent
    end

  end

  describe "#change_status!" do
    
    it "should update_attribute :status" do
      subject.should_receive(:update_attribute).with(:status, "completed")
      subject.change_status! :completed
    end

    it "should notify change when status is completed" do
      subject.should_receive(:notify!)
      subject.change_status! :completed
    end

    it "should notify change when status is failed" do
      subject.should_receive(:notify!)
      subject.change_status! :failed
    end

  end

  describe "#delete_file!" do
    
    it "should set flag delete_file" do
      subject.delete_file!
      subject.delete_file.should be_true
    end

    context "defined" do

      before do
        subject.stub :cart => mock.as_null_object
      end
      

      it "should destroy! file when task is completed" do
        subject.delete_file!
        subject.file.should_receive(:destroy!)
        subject.run
      end
                  
    end

    context "not defined" do

      it "should destroy! file when task is completed" do
        subject.file.should_not_receive(:destroy!)
        subject.run
      end
                  
    end

  end

end
