module Alfred
  ##
  # DSL to setup all scenario information.
  #
  class ScenarioDSL

    # @return [Alfred::Scenario] the scenario instance
    attr_accessor :scenario

    ##
    # Initialize dsl for existing scenario object.
    #
    # @param scenario [Alfred::Scenario] the scenario
    #
    def initialize(scenario)
      @scenario = scenario
    end

    ##
    # Store setup blocks in Scenario instance.
    #
    # @param block [Proc] the block to perform
    # @example
    #   dsl.setup do
    #     User.create(:name => 'John Doe')
    #   end
    #
    def setup(&block)
      scenario.setups << block
    end

    ##
    # Set the controller to test.
    #
    # @param controller [ActionController::Base] the controller to test
    #
    def controller(controller)
      scenario.controller = controller
    end

    ##
    # Respond to request methods.
    #
    # @example
    #   post :create, :post => { :title => 'Some title' }
    #   get  :show, :id => 1
    #
    [
      :get,
      :post,
      :patch,
      :put,
      :delete,
      :head
    ].each do |method|
      define_method(method) do |*args|
        setup_request_data(method, *args)
      end
    end

    ##
    # Setup request data.
    #
    # @param method [Symbol] the request method
    # @param action [Symbol] the controller action
    # @param params [Hash] optional params hash
    # @example
    #   setup_request(:get, :show, :id => 1)
    #
    def setup_request_data(method, action, params={})
      scenario.method = method
      scenario.action = action
      scenario.params = params
    end

  end # ScenarioDSL
end # Alfred
