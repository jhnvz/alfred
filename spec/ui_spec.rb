require 'spec_helper'

describe Alfred::UI do

  before(:each) do
    Time.stub(:now).and_return(Time.parse('08-04-2014 11:00:01'))
    @log = ""
    STDOUT.stub(:print) { |s| @log << s }
  end

  describe '#initialize' do

    it 'should add en empty line before message if options[:empty_line_before] is true' do
      message = Alfred::UI.new(:empty_line_before => true)
      message.queue 'foo'
      message.queue 'bar'
      message.display
      @log.should == "\nfoo\nbar\n"
    end

    it 'should add en empty line after message if options[:empty_line_after] is true' do
      message = Alfred::UI.new(:empty_line_after => true)
      message.queue 'foo'
      message.queue 'bar'
      message.display
      @log.should == "foo\nbar\n\n"
    end

  end

  describe '#queue' do

    it 'should add item to the queue with a timestamp if options[:timestamp] is true' do
      message = Alfred::UI.new
      message.queue('foo', :timestamp => true)
      message.queue('bar')
      message.display
      @log.should == "11:00:01 - INFO - foo\nbar\n"
    end

    it 'should add item before if options[:before] is true' do
      message = Alfred::UI.new
      message.queue('foo')
      message.queue('bar', :before => true)
      message.display
      @log.should == "bar\nfoo\n"
    end

  end

  describe '#display' do

    it 'should display a message' do
      message = Alfred::UI.new
      message.queue('foo')
      message.queue('bar')
      message.display
      @log.should == "foo\nbar\n"
    end

  end

  describe '#info' do

    it 'should display a message with timestamp' do
      Alfred::UI.info 'foo!'
      @log.should == "11:00:01 - INFO - foo!\n"
    end

  end

end
