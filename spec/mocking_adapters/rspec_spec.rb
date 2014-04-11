require 'spec_helper'

describe 'mocking adapter for rspec' do

  before do
    Alfred.configure do |config|
      config.mock_with :rspec
    end
    Alfred.configure_mock_framework!
  end

  it 'should include the adapter in Request if Alfred is configured to mock with rspec' do
    Alfred::Request.should_receive(:include).with(Alfred::MockingAdapters::RSpec)
    Alfred.configure_mock_framework!
  end

  it 'should be able to stub with RSpec' do
    Alfred.define do
      scenario 'mock with RSpec' do
        setup { User.stub(:all).and_return(['stubbed_with_rspec']) }
        controller Api::V1::UsersController
        get :index, :format => :json
      end
    end
    scenario = Alfred.registry.all.first
    scenario.run
    scenario.response.body.should == "[\"stubbed_with_rspec\"]"
  end

  it 'should teardown mocks for second scenario' do
    Alfred.define do
      scenario 'mock with RSpec' do
        setup { User.stub(:all).and_return(['stubbed_with_rspec']) }
        controller Api::V1::UsersController
        get :index, :format => :json
      end
      scenario 'teardown' do
        controller Api::V1::UsersController
        get :index, :format => :json
      end
    end
    Alfred.registry.all[0].run
    scenario = Alfred.registry.all[1]
    scenario.run
    scenario.response.body.should == "[]"
  end

end
