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

  describe '#run' do

    before(:each) do
      Alfred.configure_mock_framework!
      scenario.controller = Api::V1::UsersController
      scenario.method = :get
      scenario.action = :index
      scenario.params = { :format => :json }
    end

    it 'should perform scenario setup' do
      scenario.setups << Proc.new { User.create(:name => 'John Doe Setup') }
      scenario.run
      User.last.name.should == 'John Doe Setup'
    end

    it 'should perform configuration setup' do
      Alfred.configure do |c|
        c.setup do
           User.create(:name => 'John Doe Setup from config')
        end
      end
      scenario.run
      User.last.name.should == 'John Doe Setup from config'
    end

  end

end
