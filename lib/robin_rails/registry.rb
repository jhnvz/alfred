module RobinRails
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
    # Iterate over unique values.
    #
    def each(&block)
      @items.values.uniq.each(&block)
    end

    ##
    # Finds a Robin by its identifier.
    #
    # === Params
    #
    # [identifier (String)] unique identifier
    #
    # === Examples
    #
    # RobinRails.registry.find("as_manager/get/posts/show")
    # => #<RobinRails::Robin:0x007f933a6aaa98>
    #
    # === Returns
    #
    # [robin (Robin)] returns the robin if one found
    #
    def find(identifier)
      if registered?(identifier)
        @items[identifier]
      else
        raise ArgumentError, "not registered: #{identifier}"
      end
    end
    alias :[] :find

    ##
    # Register a new Robin.
    #
    # === Params
    #
    # [identifier (String)] the robin identifier
    # [item (Robin)] the robin object
    #
    # === Example
    #
    # RobinRails.registry.register('as_manager/get/posts/show', #<RobinRails::Robin:0x007f933a6aaa98>)
    #
    def register(identifier, item)
      @items[identifier] = item
    end

    ##
    # Check if Robin is already registered.
    #
    # === Params
    #
    # [identifier (String)] the robin identifier
    #
    # === Example
    #
    # RobinRails.registry.registered?('as_manager/get/posts/show')
    #
    # === Returns
    #
    # [found (TrueClass|FalseClass)] wheter found or not
    #
    def registered?(identifier)
      @items.key?(identifier)
    end

  end # Registry
end # RobinRails
