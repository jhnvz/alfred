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

    private

      ##
      # Wheter rspec is defined.
      #
      def rspec_defined?
        defined?(RSpec)
      end

      ##
      # Loads defaults based on defined constants.
      # It guesses fixture_path and mocking framework.
      #
      def load_defaults!
        ## Guess fixture_path
        @config[:fixture_path] = if rspec_defined?
          "#{::Rails.root}/spec/javascripts/fixtures"
        else
          "#{::Rails.root}/test/javascripts/fixtures"
        end

        ## Guess test path
        @config[:test_path] = rspec_defined? ? "spec" : "test"

        ## Guess mocking framework
        @config[:mock_with] = if rspec_defined?
          :rspec
        else
          :test_unit
        end
      end

  end # Configuration
end # Alfred
