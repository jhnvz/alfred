require 'spec_helper'
require 'alfred_rails/command_line'

module Kernel
  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    return result
  end
end

describe Alfred::CommandLine do

  subject { Alfred::CommandLine }

  before(:each) do
    @log = ""
    STDOUT.stub(:print) { |s| @log << s }
  end

  describe '#initialize' do

    before do
      subject.any_instance.stub(:load_rails!).and_return(true)
    end

    it "should load rails environment and scenario's" do
      subject.any_instance.should_receive(:load_rails!)
      Alfred.should_receive(:load!)
      subject.new
    end

    it "should run scenario's for the files found" do
      subject.any_instance.stub(:parse_options).and_return(["file1", "file2"])
      Alfred::Runner.should_receive(:new).with(["file1", "file2"])
      subject.new
    end

    it "should run all scenario's if no files present" do
      subject.any_instance.stub(:parse_options).and_return([])
      Alfred::Runner.should_receive(:new).with([])
      subject.new
    end

    it "assigns @options and adds the files that were parsed out" do
      subject.any_instance.stub(:parse_options).and_return(["file1", "file2"])
      subject.new.instance_variable_get(:@options).should == { :files => ["file1", "file2"] }
    end

  end

  describe 'opt_parser' do

    it "has --version" do
      suppress_warnings { ARGV = ["--version"] }
      expect { subject.new.parse_options }.to raise_error SystemExit
      expect(@log).to match(/\d+\.\d+\.\d+\.*./)
    end

  end

end
