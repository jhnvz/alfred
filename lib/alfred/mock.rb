module Alfred
  class Mock

    ##
    # Initialize mocking framework based on configuration.
    #
    def initialize
      if Alfred.configuration.mock_with == :rspec
        RSpec::Mocks::setup(Object.new)
      end
    end

  end # Mock
end # Alfred
