require 'spec_helper'


describe 'test' do

  before do

    RobinRails.define do

      robin 'update user by manager' do
        controller Api::V1::UsersController

        setup do
          User.create(:name => 'John Doe', :email => 'johan@vzonneveld.nl')
        end

        get :index
      end
    end

  end

  it 'should' do
    # raise RobinRails::Response.new.methods.inspect
    RobinRails.registry.items.values.first.run
  end

end
