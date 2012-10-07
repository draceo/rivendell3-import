require 'spec_helper'

require 'rivendell/import/cli'

describe Rivendell::Import::CLI do

  describe "#config_file" do
    
    it "should return file specified with --config" do
      subject.arguments << "--config" << "dummy"
      subject.config_file.should == "dummy"
    end

  end

  describe "listen_mode?" do

    it "should return true when --listen is specified" do
      subject.arguments << "--listen"
      subject.should be_listen_mode
    end
    
  end

  describe "dry_run?" do
    
    it "should return true when --dry-run is specified" do
      subject.arguments << "--dry-run"
      subject.should be_dry_run
    end

  end

  describe "debug?" do
    
    it "should return true when --debug is specified" do
      subject.arguments << "--debug"
      subject.should be_debug
    end

  end

  describe "syslog?" do
    
    it "should return true when --syslog is specified" do
      subject.arguments << "--syslog"
      subject.should be_syslog
    end

  end

  describe "#import" do

    it "should return a Rivendell::Import::Base instance" do
      subject.import.should be_instance_of(Rivendell::Import::Base)
    end

  end

  describe "#paths" do
    
    it "should return arguments after options" do
      subject.arguments << "--listen"
      subject.arguments << "file1" << "file2"
      subject.paths.should == %w{file1 file2}
    end

  end

  describe "#database" do
    
    it "should return file specified with --dabase" do
      subject.arguments << "--database" << "tasks.sqlite3"
      subject.database.should == "tasks.sqlite3"
    end

  end

  describe "#run" do

    before(:each) do
      subject.stub :paths => %w{file1 file2}
      subject.stub :start_webserver
      subject.import.tasks.stub :run => true
    end

    it "should setup logger" do
      subject.should_receive(:setup_logger)
      subject.run
    end

    it "should load config_file" do
      subject.stub :config_file => "dummy.rb"
      subject.should_receive(:load).with(subject.config_file)

      subject.run
    end

    it "should establish_connection with specified database" do
      subject.stub :database => "tasks.sqlite3"
      Rivendell::Import.should_receive(:establish_connection).with("tasks.sqlite3")

      subject.run
    end

    context "in listen_mode" do

      let(:directory) { "directory" }

      before(:each) do
        subject.stub :listen_mode? => true
        subject.stub :paths => [directory]
      end
  
      it "should use listen import" do
        subject.import.should_receive(:listen).with(directory, {})
        subject.run
      end

      context "when dry_run" do
        before(:each) do
          subject.stub :dry_run? => true
        end

        it "should use dry_run listen option" do
          subject.import.should_receive(:listen).with(anything, hash_including(:dry_run => true))
          subject.run
        end
      end

    end

    context "without listen_mode" do

      before(:each) do
        subject.stub :listen_mode? => false
      end
  
      it "should use process import" do
        subject.import.should_receive(:process).with(subject.paths)
        subject.run
      end

      it "should run tasks" do
        subject.import.tasks.should_receive(:run)
        subject.run
      end

      context "when dry_run" do
        before(:each) do
          subject.stub :dry_run? => true
        end

        it "should not run tasks" do
          subject.import.tasks.should_not_receive(:run)
          subject.run
        end
      end

    end
    
  end

  describe "#setup_logger" do
    
    context " with syslog option" do

      before do
        subject.stub :syslog? => true
      end

      it "should use a SyslogLogger" do
        Rivendell::Import.should_receive(:logger=).with(kind_of(Syslog::Logger))
        subject.setup_logger
      end

    end

  end

end
