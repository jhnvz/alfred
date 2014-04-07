require 'spec_helper'

describe Alfred::Scenario do

  let!(:scenario) { Alfred::Scenario.new('foo bar') }

  it 'should downcase the name on initialize' do
    scenario.name.should == 'foo_bar'
  end

  it 'should initialize with empty setups array' do
    scenario.setups.should == []
  end

  describe '#controller_name' do

    it 'should return underscored controller name' do
      scenario.controller = Api::V1::UsersController
      scenario.controller_name.should == 'api/v1/users_controller'
    end

  end

  describe '#path' do

    it 'should return path to save the file based on controller and action' do
      scenario.controller = Api::V1::UsersController
      scenario.action     = 'index'

      scenario.path.should == "#{Alfred.fixture_path}/api/v1/users_controller/index"
    end

  end

  describe '#format' do

    it 'should return format based on content_type in @response' do
      response = ResponseProxy.new(:content_type => 'application/json')
      scenario.instance_variable_set(:@response, response)
      scenario.format.should == 'json'

      response = ResponseProxy.new(:content_type => 'application/xml')
      scenario.instance_variable_set(:@response, response)
      scenario.format.should == 'xml'

      response = ResponseProxy.new(:content_type => 'application/html')
      scenario.instance_variable_set(:@response, response)
      scenario.format.should == 'html'
    end

  end

  describe '#filename' do

    it 'should return the filename based on path and format' do
      scenario.controller = Api::V1::UsersController
      scenario.action     = 'index'

      response = ResponseProxy.new(:content_type => 'application/json')
      scenario.instance_variable_set(:@response, response)
      scenario.format.should == 'json'

      scenario.filename.should == "#{Alfred.fixture_path}/api/v1/users_controller/index/foo_bar.json"
    end

  end

  describe '#save' do

    it 'should persist @response.body to disk' do

    end

  end

end
