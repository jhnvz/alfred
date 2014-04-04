require 'spec_helper'


describe 'test' do

  before do

    Robin.define do

      scenario 'update user by manager' do
        controller Api::V1::UsersController

        setup do
          User.create(:name => 'John Doe', :email => 'johan@vzonneveld.nl')
        end

        get :index, :format => :json
      end
    end

  end

  it 'should' do
    Robin.registry.items.values.first.run
  end

end
