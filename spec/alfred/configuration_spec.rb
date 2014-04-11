require 'spec_helper'

describe Alfred::Configuration do

  let!(:configuration) { Alfred::Configuration.new }

  it 'should initialize with an empty setup array' do
    configuration.setup.should == []
  end

  it 'should initialize with an empty includes array' do
    configuration.includes.should == []
  end

  describe '#load_defaults' do

    it 'should set fixture_path to rspec directory if rspec is defined' do
      configuration.fixture_path.should == "#{Rails.root}/spec/javascripts/fixtures"
    end

    it 'should set fixture path to test directory if rspec is not defined' do
      Alfred::Configuration.any_instance.stub(:rspec_defined?).and_return(false)
      configuration = Alfred::Configuration.new
      configuration.fixture_path.should == "#{Rails.root}/test/javascripts/fixtures"
    end

    it 'should set mocking framework to :rspec if Rspec is defined' do
      configuration.mock_with.should == :rspec
    end

    it 'should set mocking framework to :mocha if Mocha is defined and Rspec is not' do
      Alfred::Configuration.any_instance.stub(:rspec_defined?).and_return(false)
      Alfred::Configuration.any_instance.stub(:mocha_defined?).and_return(true)
      configuration = Alfred::Configuration.new
      configuration.mock_with.should == :mocha
    end

    it 'should set mocking framework to :ff if Mocha is defined and Mocha and Rspec are not' do
      Alfred::Configuration.any_instance.stub(:rspec_defined?).and_return(false)
      Alfred::Configuration.any_instance.stub(:mocha_defined?).and_return(false)
      Alfred::Configuration.any_instance.stub(:rr_defined?).and_return(true)
      configuration = Alfred::Configuration.new
      configuration.mock_with.should == :rr
    end

    it 'should set mocking framework to :flexmock if Flexmock is defined and RR, Mocha and Rspec are not' do
      Alfred::Configuration.any_instance.stub(:rspec_defined?).and_return(false)
      Alfred::Configuration.any_instance.stub(:mocha_defined?).and_return(false)
      Alfred::Configuration.any_instance.stub(:rr_defined?).and_return(false)
      Alfred::Configuration.any_instance.stub(:flexmock_defined?).and_return(true)
      configuration = Alfred::Configuration.new
      configuration.mock_with.should == :flexmock
    end

  end

  describe '#setup' do

    it 'should add procs to the setup array if block given' do
      configuration.setup { User.create(:name => 'John Doe') }
      configuration.setup.size.should == 1
      configuration.setup.first.should be_kind_of(Proc)
    end

  end

  describe '#mock_with' do

    it 'should set mock_with if argument is given' do
      configuration.mock_with :something
      configuration.mock_with.should == :something
    end

  end

  describe '#fixture_path' do

    it 'should set fixture_path if argument is given' do
      configuration.fixture_path 'some/path'
      configuration.fixture_path.should == "#{Rails.root}/some/path"
    end

  end

  describe '#test_path' do

    it 'should set test_path if argument is given' do
      configuration.test_path 'some/path'
      configuration.test_path.should == "some/path"
    end

  end

  describe '#mock_adapter' do

    it 'should return the correct mock adapter module' do
      configuration.mock_with :rspec
      configuration.mock_adapter.should == Alfred::MockingAdapters::RSpec

      configuration.mock_with :rr
      require 'alfred/mocking_adapters/rr'
      configuration.mock_adapter.should == Alfred::MockingAdapters::RR

      configuration.mock_with :flexmock
      require 'alfred/mocking_adapters/flexmock'
      configuration.mock_adapter.should == Alfred::MockingAdapters::Flexmock
    end

  end

  describe '#include' do

    it 'should add modules to include' do
      configuration.include Object
      configuration.includes.size.should == 1
      configuration.includes.first.should == Object
    end

  end

end
