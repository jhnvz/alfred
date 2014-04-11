module Alfred
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
    # === Params
    #
    # [block (Block)] the block to perform
    #
    # === Example
    #
    #   setup
    #     User.create(:name => 'John Doe')
    #   end
    #
    #   setup #=> [Proc]
    #
    # === Returns
    #
    # [setup (Array)] array with blocks
    #
    def setup(&block)
      return @config[:setup] unless block_given?
      @config[:setup] << block
    end

    ##
    # Include modules.
    #
    # === Params
    #
    # [mod (Module)] the module to include
    #
    # === Example
    #
    #   include Devise::TestHelpers
    #
    def include(mod)
      @config[:includes] << mod
    end

    ##
    # Returns array of the modules to include.
    #
    # === Returns
    #
    # [modules (Array)] the modules to include
    #
    def includes
      @config[:includes]
    end

    ##
    # Set or get the fixture path.
    #
    # === Params
    #
    # [path (String)] the path to set
    #
    # === Examples
    #
    #   fixture_path('spec/javascript/fixtures')
    #   fixture_path #=> 'spec/javascript/fixtures'
    #
    # === Returns
    #
    # [path (String)] the fixture path
    #
    def fixture_path(path=nil)
      return config[:fixture_path] if path.nil?
      config[:fixture_path] = "#{::Rails.root}/#{path}"
    end

    ##
    # Set or get the test path.
    #
    # === Params
    #
    # [path (String)] the path to set
    #
    # === Examples
    #
    #   test_path('spec')
    #   test_path #=> 'spec'
    #
    # === Returns
    #
    # [path (String)] the fixture path
    #
    def test_path(path=nil)
      return config[:test_path] if path.nil?
      config[:test_path] = path
    end

    ##
    # Set or get the mocking framework.
    #
    # === Params
    #
    # [framework (Symbol)] the mocking framework
    #
    # === Examples
    #
    #   mock_with :rspec
    #   mock_with #=> :rspec
    #
    # === Returns
    #
    # [framework (Symbol)] mocking framework
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
    # === Example
    #
    #   configuration.mock_with :rspec
    #   configuration.mock_adapter #=> Alfred::MockingAdapters::RSpec
    #
    # === Returns
    #
    #   [module (Module)] the adapter
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
