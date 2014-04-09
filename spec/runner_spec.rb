require 'spec_helper'

describe Alfred::Runner do

  before do
    @log = ""
    STDOUT.stub(:print) { |s| @log << s }
  end

  after(:each) { Alfred.registry.clear! }

  describe '#initialize' do

    describe 'with files supplied' do

      before(:each) { Alfred::Runner.any_instance.stub(:run).and_return(true) }
      subject       { Alfred::Runner.new(['spec/alfreds/api/v1/users_controller.rb', 'spec/alfreds/non_existing.rb']) }

      it 'should assign @files with files' do
        subject.files.should == ['spec/alfreds/api/v1/users_controller.rb', 'spec/alfreds/non_existing.rb']
      end

      it 'should assign @controllers with controller names' do
        subject.controllers.should == ['api/v1/users_controller', 'non_existing']
      end

      it 'should assign @matches with matching alfred definitions' do
        Alfred.define do
          controller Api::V1::UsersController do
            scenario 'foo'
          end
          controller Api::V1::PostsController do
            scenario 'bar'
          end
        end
        subject.matches.should == ["spec/alfreds/api/v1/users_controller.rb"]
      end

      it "should assign @scenarios with the scenarios for a controller" do
        Alfred.define do
          controller Api::V1::UsersController do
            scenario 'foo'
            scenario 'bar'
          end
          controller Api::V1::PostsController do
            scenario 'bar'
          end
        end
        subject.scenarios.size.should == 2
      end

    end

  end

  describe 'without files supplied' do

    before(:each) { Alfred::Runner.any_instance.stub(:run).and_return(true) }
    after(:each)  { Alfred.registry.clear! }

    subject { Alfred::Runner.new }

    it '@files should be empty' do
      subject.files.should be_empty
    end

    it '@controllers should be nil' do
      subject.controllers.should be_nil
    end

    it '@matches should be nil' do
      Alfred.define do
        controller Api::V1::UsersController do
          scenario 'foo'
        end
        controller Api::V1::PostsController do
          scenario 'bar'
        end
      end
      subject.matches.should be_nil
    end

    it "should assign @scenarios with all scenario's" do
      Alfred.define do
        controller Api::V1::UsersController do
          scenario 'foo'
          scenario 'bar'
        end
        controller Api::V1::PostsController do
          scenario 'bar'
        end
      end
      subject.scenarios.size.should == 3
    end

  end

  describe '#run' do

    before do
      Alfred::Scenario.any_instance.stub(:run).and_return(true)
      ProgressBar.stub(:create).and_return(ProgressBar.new)
      ProgressBar.any_instance.stub(:increment).and_return(true)
    end

    subject { Alfred::Runner.new(['spec/alfreds/api/v1/users_controller.rb', 'spec/alfreds/non_existing.rb']) }

    context 'with matching files' do

      before(:each) do
        Alfred.define do
          controller Api::V1::UsersController do
            scenario 'foo'
            scenario 'bar'
          end
          controller Api::V1::PostsController do
            scenario 'bar'
          end
        end
      end

      it 'should notify about matches' do
        subject
        @log.should include('spec/alfreds/api/v1/users_controller.rb')
        @log.should_not include('spec/alfreds/non_existing.rb')
      end

    end

    context 'without matching files' do

      before(:each) do
        Alfred.define do
          controller Api::V1::UsersController do
            scenario 'foo'
            scenario 'bar'
          end
          controller Api::V1::PostsController do
            scenario 'bar'
          end
        end
      end

      it 'should not run' do
        Alfred.define do
          controller Api::V1::PostsController do
            scenario 'bar'
          end
        end
        subject.should_not_receive(:run)
      end

    end

    context 'without files' do

      subject { Alfred::Runner.new }

      before(:each) do
        Alfred.define do
          controller Api::V1::UsersController do
            scenario 'foo'
            scenario 'bar'
          end
          controller Api::V1::PostsController do
            scenario 'bar'
          end
        end
      end

      it 'should notify about running all files' do
        subject
        @log.should include("Running all scenario's")
      end
    end

  end

end
