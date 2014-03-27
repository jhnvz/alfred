module RobinRails
  class Robin

    ## Attributes

    attr_accessor :name, :setup, :method, :controller, :action, :params, :identifier

    ##
    # Initialize a new Robin.
    #
    # === Params
    #
    # [name (String)] name of the definition
    # [options (Hash)] optional options
    #
    # === Example
    #
    # Robin.new('admin permissions')
    #
    def initialize(name, options={})
      @name = name
    end

    ##
    # Runs the example
    #
    def run

    end

  end # Robin
end # RobinRails
