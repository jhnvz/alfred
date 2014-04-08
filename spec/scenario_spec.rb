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

  describe 'FixtureFile' do

    let(:file) { Alfred::Scenario::FixtureFile.new(nil, 'api/v1/users_controller', 'index', 'foo_bar') }

    describe '#path' do

      it 'should return path to save the file based on controller and action' do
        file.path.should == "#{Alfred.fixture_path}/api/v1/users_controller/index"
      end

    end

    describe '#filename' do

      it 'should return the filename based on path' do
        file.filename.should == "#{Alfred.fixture_path}/api/v1/users_controller/index/foo_bar.js"
      end

    end

    describe '#content' do

      let(:request) { Object.new }
      let(:response) { Object.new }

      before(:each) do
        request.stub(:fullpath).and_return('api/1/users')
        request.stub(:method).and_return('GET')

        response.stub(:body).and_return('this is data')
        response.stub(:status).and_return(200)
        response.stub(:content_type).and_return('application/json')
        response.stub(:request).and_return(request)

        file.stub(:response).and_return(response)
      end

      it 'should return hash with data and request meta data' do
        file.content.should == {
          :name     => 'foo_bar',
          :action   => 'api/v1/users_controller/index',
          :meta     => {
            :path     => 'api/1/users',
            :method   => 'GET',
            :status   => 200,
            :type     => 'application/json',
          },
          :response => 'this is data'
        }
      end

      it 'should return #to_js' do
        file.to_js.should include "Alfred.register"
      end

    end

  end

end
