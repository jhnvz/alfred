module RobinRails
  class RobinProxy

    attr_accessor :definition

    def initialize(definition)
      @definition = definition
    end

    ##
    # Apply setup to Robin instance.
    #
    # === Params
    #
    # [block (Block)] the block to perform.
    #
    # === Example
    #
    # setup do
    #   User.create(:name => 'John Doe')
    # end
    #
    def setup(&block)
      definition.setup = block
    end

    ##
    # Respond to request methods
    #
    # === Examples
    #
    # post 'posts#create', :post => { :title => 'Some title' }
    # get  'posts#show', :id => 1
    #
    [
      :get,
      :post,
      :patch,
      :put,
      :delete
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
    # [controller_and_action (String)] controller and action
    # [params (Hash)] request params
    #
    # === Example
    #
    # setup_request(:get, 'posts#show', :id => 1)
    #
    def setup_request_data(method, controller_and_action, params={})
      controller, action = controller_and_action.split('#')

      definition.method     = method
      definition.controller = controller
      definition.action     = action
      definition.params     = params

      name = definition.name.downcase.gsub(' ', '_')

      definition.identifier = "#{name}/#{method}/#{controller}/#{action}"
    end

  end # RobinProxy
end # RobinRails
