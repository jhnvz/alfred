module Alfred
  class Configuration

    attr_accessor :config

    ##
    # Initialize a new configuration.
    #
    def initialize
      @config = {
        :includes => {
          :controller => [],
          :base       => []
        },
        :before    => []
      }
    end

    ##
    # Set before methods for whole suite.
    #
    # === Example
    #
    #   before
    #     User.create(:name => 'John Doe')
    #   end
    #
    def before(&block)
      @config[:before] << block
    end

    ##
    # Include modules.
    #
    # === Params
    #
    # [mod (Module)] the module to include
    # [type (Sym)] where to include
    #
    # === Example
    #
    #   include Devise::TestHelpers, :controller
    #
    def include(mod, type=:base)
      @config[:includes][type] << mod
    end

    def includes_for(type)
      @config[:includes][type]
    end

    def mock_with(framework=nil)

    end

    def load_defaults
      if @config[:mock_with].nil? && defined?(Rspec)
        require 'rspec/mocks'
        @config[:mock_with] = :rspec
      elsif @config[:mock_with].nil? && defined?(Test::Unit)
        require 'test/unit/double'
        @config[:mock_with] = :test_unit
      end
    end

  end # Configuration
end # Alfred
