require 'spec_helper'

describe 'test' do

  before do

    RobinRails.define do
      robin 'update post by manager' do
        setup do
          User.create(:name => 'John Doe', :permissions => { :manager => true })
          Post.create(:title => 'Robin is awesome', :body => 'It saves me time')
        end

        get 'api/v1/posts#update', :id => 1
      end
    end

  end

  it 'should' do
    RobinRails.registry.items.values.first.inspect
  end

end
