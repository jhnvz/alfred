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

    it 'should set mocking framework to :rspec if Rspec::Mocks is defined' do
      configuration.mock_with.should == :rspec
    end

    it 'should set mocking framework to nil if Rspec::Mocks is not defined' do
      Alfred::Configuration.any_instance.stub(:rspec_mocks_defined?).and_return(false)
      configuration = Alfred::Configuration.new
      configuration.mock_with.should be_nil
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

  describe '#include' do

    it 'should add modules to include' do
      configuration.include Object
      configuration.includes.size.should == 1
      configuration.includes.first.should == Object
    end

  end

end
