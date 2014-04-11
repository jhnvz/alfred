require 'spec_helper'

describe 'mocking adapter for flexmock' do

  before do
    Alfred.configure do |config|
      config.mock_with :flexmock
    end
    Alfred.configure_mock_framework!
  end

  it 'should include the adapter in Request if Alfred is configured to mock with flexmock' do
    Alfred::Request.should_receive(:include).with(Alfred::MockingAdapters::Flexmock)
    Alfred.configure_mock_framework!
  end

  it 'should be able to stub with Flexmock' do
    Alfred.define do
      scenario 'mock with Flexmock' do
        setup { flexmock(User, :all => ['stubbed_with_flexmock']) }
        controller Api::V1::UsersController
        get :index, :format => :json
      end
    end
    scenario = Alfred.registry.all.first
    scenario.run
    scenario.response.body.should == "[\"stubbed_with_flexmock\"]"
  end

  it 'should teardown mocks for second scenario' do
    Alfred.define do
      scenario 'mock with Flexmock' do
        setup { flexmock(User, :all => ['stubbed_with_flexmock']) }
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
