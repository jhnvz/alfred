require 'spec_helper'

describe Alfred::ScenarioDSL do

  let!(:scenario) { Alfred::Scenario.new('foo bar') }
  let!(:dsl)      { Alfred::ScenarioDSL.new(scenario) }

  describe '#setup' do

    it 'should add setup blocks to definition' do
      dsl.setup do
        User.new
      end
      scenario.setup.size.should == 1
      scenario.setup.first.should be_kind_of(Proc)

      dsl.setup do
        User.new
      end
      scenario.setup.size.should == 2
    end

  end

  describe '#controller' do

    it 'should set the controller to test' do
      dsl.controller Api::V1::UsersController
      scenario.controller.should == Api::V1::UsersController
    end

  end

  describe 'request methods' do

    it 'should respond to all request methods' do
      dsl.should respond_to(:get)
      dsl.should respond_to(:post)
      dsl.should respond_to(:put)
      dsl.should respond_to(:patch)
      dsl.should respond_to(:head)
      dsl.should respond_to(:delete)
    end

  end

  describe '#setup_request_data' do

    it 'should set method' do
      dsl.setup_request_data(:get, :show, :id => 1)
      scenario.method.should == :get
    end

    it 'should set action' do
      dsl.setup_request_data(:get, :show, :id => 1)
      scenario.action.should == :show
    end

    it 'should set params' do
      dsl.setup_request_data(:get, :show, :id => 1)
      scenario.params.should == { :id => 1 }
    end

  end

end
