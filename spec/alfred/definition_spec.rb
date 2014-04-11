require 'spec_helper'

describe Alfred::Definition do

  describe '#define' do

    it 'should run the block through DSL' do
      Alfred::Definition::DSL.should_receive(:run)
      Alfred.define { scenario 'name' }
    end

  end

  describe Alfred::Definition::DSL do

    describe '#define' do

      it 'should register a new scenario' do
        Alfred.define do
          scenario 'foo bar' do
            setup { User.create(:name => 'John') }

            controller Api::V1::UsersController

            patch :update, :id => 1, :user => { :name => 'John Doe' }
          end
        end

        scenario = Alfred.registry.all.first
        scenario.controller.should == Api::V1::UsersController
        scenario.method.should == :patch
        scenario.action.should == :update
        scenario.params.should == { :id => 1, :user => { :name => 'John Doe' } }
        scenario.setups.size.should == 1
        scenario.setups.first.should be_kind_of(Proc)
      end

    end

    describe '#setup' do

      it 'should be able to set setup for multiple scenarios' do
        Alfred.define do
          setup { User.create(:name => 'John') }

          controller Api::V1::UsersController do
            scenario 'foo bar'
            scenario 'foo bar 1'
          end
        end

        scenario = Alfred.registry.all[0]
        scenario.setups.size.should == 1

        scenario = Alfred.registry.all[1]
        scenario.setups.size.should == 1
      end

      it 'should be able to set setup within controller block' do
        Alfred.define do
          controller Api::V1::UsersController do
            setup { User.create(:name => 'John') }

            scenario 'foo bar'
            scenario 'foo bar 1'
          end
        end

        scenario = Alfred.registry.all[0]
        scenario.setups.size.should == 1

        scenario = Alfred.registry.all[1]
        scenario.setups.size.should == 1
      end

      it 'should append setup defined in scenario' do
        Alfred.define do
          setup { User.create(:name => 'John') }

          controller Api::V1::UsersController do
            scenario 'foo bar'
            scenario 'foo bar 1' do
              setup { Post.create(:title => 'Cool post') }
            end
          end
        end

        scenario = Alfred.registry.all[0]
        scenario.setups.size.should == 1

        scenario = Alfred.registry.all[1]
        scenario.setups.size.should == 2
      end

    end

    describe '#controller' do

      it 'should be able to set controller for multiple scenarios' do
        Alfred.define do
          controller Api::V1::UsersController do
            scenario 'foo bar'
            scenario 'foo bar 1'
          end
        end

        scenario = Alfred.registry.all[0]
        scenario.controller.should == Api::V1::UsersController

        scenario = Alfred.registry.all[1]
        scenario.controller.should == Api::V1::UsersController
      end

      it 'should be able overwrite controller per scenario' do
        Alfred.define do
          controller Api::V1::UsersController do
            scenario 'foo bar'
            scenario 'foo bar 1' do
              controller Api::V1::PostsController
            end
          end
        end

        scenario = Alfred.registry.all[0]
        scenario.controller.should == Api::V1::UsersController

        scenario = Alfred.registry.all[1]
        scenario.controller.should == Api::V1::PostsController
      end

    end

  end

end
