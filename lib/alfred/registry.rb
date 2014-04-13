module Alfred
  ##
  # Holds all scenario's to run per controller.
  #
  class Registry

    attr_reader :items

    def initialize
      @items = {}
    end

    ##
    # Register a new Scenario.
    #
    # @param controller_name [String] the name of the controller
    # @item [Alfred::Scenario] the scenario instance
    # @example
    #   Alfred.registry.register('api/v1/posts_controller', Alfred::Scenario.new)
    #
    def register(controller_name, item)
      @items[controller_name] ||= []
      @items[controller_name] << item
    end

    ##
    # Check if controller is already registered.
    #
    # @param controller_name [String] the name of the controller
    # @return [true|false] whether there are examples for controller
    # @example
    #   Alred.registry.registered?('api/v1/posts_controller')
    #
    def registered?(controller_name)
      @items.key?(controller_name)
    end

    ##
    # Finds a Scenario by controller_name.
    #
    # @param controller_name [String] the name to lookup
    # @return [Array<Alfred::Scenario>] all scenario's for controller
    # @example
    #   Alfred.registry.find("api/v1/sessions_controller")
    #   #=> [#<Alfred::Scenario:0x007f933a6aaa98>]
    #
    def find(controller_name)
      if registered?(controller_name)
        @items[controller_name]
      end
    end
    alias :[] :find

    ##
    # Returns all the items.
    #
    # @return [Array<Alfred::Scenario>] all scenario's
    #
    def all
      @items.values.flatten
    end

    ##
    # Removes all items from registry.
    #
    def clear!
      @items.clear
    end

  end # Registry
end # Alfred
