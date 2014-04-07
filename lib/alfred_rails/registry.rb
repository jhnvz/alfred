module Alfred
  class Registry

    attr_accessor :items

    def initialize
      @items = {}
    end

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
    #   Alfred.registry.register('api/v1/posts_controller', #Alfred::Scenario:0x007f933a6aaa98>)
    #
    def register(identifier, item)
      @items[identifier] ||= []
      @items[identifier] << item
    end

    ##
    # Check if controller and action are already registered.
    #
    # === Params
    #
    # [identifier (String)] the scenario identifier
    #
    # === Example
    #
    #   Scenario.registry.registered?('api/v1/posts_controller')
    #
    # === Returns
    #
    # [found (TrueClass|FalseClass)] wheter found or not
    #
    def registered?(identifier)
      @items.key?(identifier)
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
    #   Alfred.registry.find("api/v1/sessions_controller")
    #   #=> [#<Alfred::Scenario:0x007f933a6aaa98>]
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
    # Returns all the items.
    #
    def all
      @items.values.flatten
    end

    ##
    # Removes al items from registry.
    #
    def clear!
      @items.clear
    end

  end # Registry
end # Alfred
