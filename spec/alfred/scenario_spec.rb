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

end
