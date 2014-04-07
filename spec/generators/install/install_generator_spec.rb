require 'spec_helper'
require 'generators/alfred/install/install_generator'

describe Alfred::Generators::InstallGenerator do
  destination File.expand_path("../../../../tmp", __FILE__)

  before { prepare_destination }

  it "generates spec/alfred_helper.rb" do
    run_generator
    file('spec/alfred_helper.rb').should exist
  end

  describe 'conditions' do

    before(:each) do
      stub_class = Alfred::Generators::InstallGenerator.any_instance
      stub_class.stub(:mock_with).and_return(:rspec)
      stub_class.stub(:devise_defined?).and_return(false)
      stub_class.stub(:factory_girl_defined?).and_return(false)
    end

    it "sets mocking framework to rspec if defined" do
      run_generator
      File.read(file('spec/alfred_helper.rb')).should include('config.mock_with :rspec')
    end

    it "sets mocking framework to test_unit if rspec is not defined" do
      Alfred::Generators::InstallGenerator.any_instance.stub(:mock_with).and_return(:test_unit)
      run_generator
      File.read(file('spec/alfred_helper.rb')).should include('config.mock_with :test_unit')
    end

    it 'should include Devise::TestHelpers if Devise is defined' do
      Alfred::Generators::InstallGenerator.any_instance.stub(:devise_defined?).and_return(true)
      run_generator
      File.read(file('spec/alfred_helper.rb')).should include('config.include Devise::TestHelpers')
    end

    it 'should include FactoryGirl::Syntax::Methods if FactoryGirl is defined?' do
      Alfred::Generators::InstallGenerator.any_instance.stub(:factory_girl_defined?).and_return(true)
      run_generator
      File.read(file('spec/alfred_helper.rb')).should include('config.include FactoryGirl::Syntax::Methods')
    end

  end

end
