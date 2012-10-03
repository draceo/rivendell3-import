require 'spec_helper'

describe Rivendell::Import::File do

  subject { Rivendell::Import::File.new "/path/to/dummy.wav", :base_directory => "/path/to" }

  describe "initialization" do
    
    it "should use given base_directory to compute relative name" do
      Rivendell::Import::File.new("/path/to/dummy.wav", :base_directory => "/path/to").name.should == "dummy.wav"
    end

  end

  describe "#to_s" do
    
    it "should use name" do
      subject.to_s.should == subject.name
    end

  end

  describe ".relative_filename" do
    
    it "should return '/subdirectory/file' from '/base/subdirectory/file'" do
      Rivendell::Import::File.relative_filename('/base/subdirectory/file', '/base').should == 'subdirectory/file'
    end

  end

  describe "match" do
    
    it "should match a given regexp" do
      subject.stub :name => "dummy"
      subject.should match(/^dum/)
    end

    it "should not return false when not match" do
      subject.stub :name => "dummy"
      subject.should_not match(/other/)
    end

  end

  describe "#basename" do
    
    it "should return 'dummy' for 'path/to/dummy.wav'" do
      subject.stub :name => "path/to/dummy.wav"
      subject.basename.should == "dummy"
    end

  end

  describe "#extension" do
    
    it "should 'wav' for 'path/to/dummy.wav'" do
      subject.stub :name => "path/to/dummy.wav"
      subject.extension.should == "wav"
    end

  end

end
