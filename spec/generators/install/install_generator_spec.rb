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

    let!(:stub_class) { Alfred::Generators::InstallGenerator.any_instance }

    before(:each) do
      stub_class.stub(:mock_with).and_return(:rspec)
      stub_class.stub(:devise_defined?).and_return(false)
      stub_class.stub(:factory_girl_defined?).and_return(false)
    end

    subject { File.read(file('spec/alfred_helper.rb')) }

    it "sets mocking framework if defined" do
      run_generator
      subject.should include('config.mock_with :rspec')
    end

    it "doesn't set mocking framework if not defined" do
      stub_class.stub(:mock_with).and_return(nil)
      run_generator
      subject.should_not include('config.mock_with')
    end

    it 'should include Devise::TestHelpers if Devise is defined' do
      Alfred::Generators::InstallGenerator.any_instance.stub(:devise_defined?).and_return(true)
      run_generator
      subject.should include('config.include Devise::TestHelpers')
    end

    it 'should include FactoryGirl::Syntax::Methods if FactoryGirl is defined?' do
      Alfred::Generators::InstallGenerator.any_instance.stub(:factory_girl_defined?).and_return(true)
      run_generator
      subject.should include('config.include FactoryGirl::Syntax::Methods')
    end

    it 'should require "factory_girl" if FactoryGirl is defined?' do
      Alfred::Generators::InstallGenerator.any_instance.stub(:factory_girl_defined?).and_return(true)
      run_generator
      subject.should include('require "factory_girl"')
    end

  end

end
