module Robin
  class Registry

    attr_accessor :items

    ##
    # Initializes a new registry.
    #
    def initialize
      @items = {}
    end

    ##
    # Removes al items from registry.
    #
    def clear
      @items.clear
    end

    ##
    # Returns all the items.
    #
    def all
      @items.values.flatten
    end

    ##
    # Finds a Scenario by its identifier.
    #
    # === Params
    #
    # [identifier (String)] unique identifier
    #
    # === Examples
    #
    #   Robin.registry.find("api/v1/sessions_controller")
    #   #=> [#<Robin::Scenario:0x007f933a6aaa98>]
    #
    # === Returns
    #
    # [items (Array)] returns all the items for identifier
    #
    def find(identifier)
      if registered?(identifier)
        @items[identifier]
      end
    end
    alias :[] :find

    ##
    # Register a new Scenario.
    #
    # === Params
    #
    # [identifier (String)] the scenario identifier
    # [item (Scenario)] the scenario object
    #
    # === Example
    #
    #   Robin.registry.register('api/v1/posts_controller', #<Robin::Scenario:0x007f933a6aaa98>)
    #
    def register(identifier, item)
      @items[identifier] ||= []
      @items[identifier] << item
    end

    ##
    # Check if Scenario is already registered.
    #
    # === Params
    #
    # [identifier (String)] the scenario identifier
    #
    # === Example
    #
    #   Scenario.registry.registered?('as_manager/get/posts/show')
    #
    # === Returns
    #
    # [found (TrueClass|FalseClass)] wheter found or not
    #
    def registered?(identifier)
      @items.key?(identifier)
    end

  end # Registry
end # Robin
