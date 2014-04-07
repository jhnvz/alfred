module Alfred
  class ScenarioDSL

    attr_accessor :scenario

    def initialize(scenario)
      @scenario = scenario
    end

    ##
    # Apply setup to Scenario instance.
    #
    # === Params
    #
    # [block (Block)] the block to perform.
    #
    # === Example
    #
    #   setup do
    #     User.create(:name => 'John Doe')
    #   end
    #
    def setup(&block)
      scenario.setup << block
    end

    ##
    # Set the controller to test.
    #
    # === Params
    #
    # [controller (ActionController::Base)] the controller to test
    #
    # === Example
    #
    #   controller(ActionController::Base)
    #
    def controller(controller)
      scenario.controller = controller
    end

    ##
    # Respond to request methods
    #
    # === Examples
    #
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
    # === Params
    #
    # [method (Sym)] request method
    # [action (Sym)] controller and action
    # [params (Hash)] request params
    #
    # === Example
    #
    #   setup_request(:get, :show, :id => 1)
    #
    def setup_request_data(method, action, params={})
      scenario.method = method
      scenario.action = action
      scenario.params = params
    end

  end # ScenarioDSL
end # Alfred
