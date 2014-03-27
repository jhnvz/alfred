module RobinRails
  class Registry

    attr_accessor :items

    ##
    # Initializes a new registry
    #
    def initialize
      @items = {}
    end

    ##
    # Removes al items from registry
    #
    def clear
      @items.clear
    end

    ##
    #
    #
    def each(&block)
      @items.values.uniq.each(&block)
    end

    ##
    #
    #
    def find(identifier)
      if registered?(identifier)
        @items[identifier]
      else
        raise ArgumentError, "not registered: #{identifier}"
      end
    end

    alias :[] :find

    def register(identifier, item)
      @items[identifier] = item
    end

    def registered?(identifier)
      @items.key?(identifier)
    end

  end # Registry
end # RobinRails
