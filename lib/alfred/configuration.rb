module Alfred
  ##
  # Holds global configuration.
  #
  class Configuration

    attr_accessor :config

    def initialize
      @config = {
        :includes => [],
        :setup    => []
      }

      load_defaults!
    end

    ##
    # Set or get setup for each scenario.
    #
    # @param block [Proc] The block to perform
    # @return [Array<Proc>] blocks to perform
    # @example
    #   setup do
    #     User.create(:name => 'John Doe')
    #   end
    #
    #   setup #=> [Proc]
    #
    # === Returns
    #
    # [setup (Array<Proc)] array with blocks
    #
    def setup(&block)
      return @config[:setup] unless block_given?
      @config[:setup] << block
    end

    ##
    # Modules to include.
    #
    # @param mod [Module] the module to include
    # @example
    #   include Devise::TestHelpers
    #
    def include(mod)
      @config[:includes] << mod
    end

    ##
    # Returns array of the modules to include.
    #
    # @return (Array<Module>) the modules to include
    #
    def includes
      @config[:includes]
    end

    ##
    # Set or get the fixture path.
    #
    # @param path [String] the fixture path
    # @return [String] the fixture path
    # @example
    #   fixture_path('spec/javascript/fixtures')
    #   fixture_path #=> 'spec/javascript/fixtures'
    #
    def fixture_path(path=nil)
      return config[:fixture_path] if path.nil?
      config[:fixture_path] = "#{::Rails.root}/#{path}"
    end

    ##
    # Set or get the test path.
    #
    # @param path [String] the test path
    # @return [String] the test path
    # @example
    #   test_path('spec')
    #   test_path #=> 'spec'
    #
    def test_path(path=nil)
      return config[:test_path] if path.nil?
      config[:test_path] = path
    end

    ##
    # Set or get the mocking framework.
    #
    # @param framework [Symbol] the mocking framework
    # @return [Symbol] the mocking framework
    # @example
    #   mock_with :rspec
    #   mock_with #=> :rspec
    #
    def mock_with(framework=nil)
      return config[:mock_with] if framework.nil?
      config[:mock_with] = framework
    end

    MOCKING_ADAPTERS = {
      :rspec    => :RSpec,
      :flexmock => :Flexmock,
      :rr       => :RR,
      :mocha    => :Mocha
    }

    ##
    # Returns the mocking adapter module.
    #
    # @return [Module] the adapter
    # @example
    #   configuration.mock_with :rspec
    #   configuration.mock_adapter #=> Alfred::MockingAdapters::RSpec
    #
    def mock_adapter
      adapter = MOCKING_ADAPTERS[mock_with]
      "Alfred::MockingAdapters::#{adapter}".constantize
    end

    private

      ##
      # Wheter module is defined.
      #
      # :nocov:
      def rspec_defined?
        defined?(RSpec)
      end

      def mocha_defined?
        defined?(Mocha)
      end

      def rr_defined?
        defined?(RR)
      end

      def flexmock_defined?
        defined?(Flexmock)
      end
      # :nocov:

      ##
      # Loads defaults based on defined constants.
      # It guesses fixture_path and mocking framework.
      #
      def load_defaults!
        ## Guess test path
        @config[:test_path] = rspec_defined? ? "spec" : "test"

        ## Guess fixture_path
        @config[:fixture_path] = "#{::Rails.root}/#{test_path}/javascripts/fixtures"

        ## Guess mocking framework
        @config[:mock_with] = if rspec_defined?
          :rspec
        elsif mocha_defined?
          :mocha
        elsif rr_defined?
          :rr
        elsif flexmock_defined?
          :flexmock
        end
      end

  end # Configuration
end # Alfred
