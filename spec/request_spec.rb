require 'spec_helper'

describe Alfred::Request do

  let!(:request) { Alfred::Request.new('test') }

  describe '#set_controller' do

    it 'should set @controller' do
      request.set_controller Api::V1::UsersController
      request.instance_variable_get(:@controller).should be_kind_of(Api::V1::UsersController)
    end

    it 'should set @routes' do
      request.set_controller Api::V1::UsersController
      request.instance_variable_get(:@routes).should == Rails.application.routes
    end

  end

  describe '#perform_setup' do

    it 'should execute the given block' do
      request.perform_setup { User.create(:name => 'John Doe') }
      User.count.should == 1
      request.perform_setup { User.create(:name => 'John Doe') }
      User.count.should == 2
    end

  end

end
