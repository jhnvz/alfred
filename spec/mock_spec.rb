require 'spec_helper'

describe Alfred::Mock do

  describe '#new' do

    it 'should initialize mocking framework based on mock_with in configuration' do
      Alfred.configure do |config|
        config.mock_with :rspec
      end

      RSpec::Mocks.should_receive(:setup)
      Alfred::Mock.new
    end

  end

end
