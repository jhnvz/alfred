module Alfred
  class Scenario

    ## Attributes

    attr_accessor :name, :setups, :method, :controller, :action, :params, :identifier

    ##
    # Initialize a new Alfred scenario.
    #
    # === Params
    #
    # [name (String)] name of the scenario
    #
    # === Example
    #
    #   Scenario.new('admin permissions')
    #
    def initialize(name)
      @name   = name.downcase.gsub(' ', '_')
      @setups = []
    end

    ##
    # Returns the controller name based on controller.
    #
    # === Examples
    #
    #   scenario = Scenario.new('test')
    #   scenario.controller = Api::V1::UserController
    #
    #   scenario.controller_name #=> 'api/v1/users_controller'
    #
    def controller_name
      controller.name.underscore
    end

    ##
    # Runs the scenario.
    #
    def run
      controller.send(:include, ::Rails.application.routes.url_helpers)

      ## Initialize mocking framework
      Alfred::Mock.new

      ## Include modules from configuration
      Alfred.configuration.includes.each do |mod|
        Request.send(:include, mod)
      end

      ## Setup request
      request = Request.new(name)
      request.set_controller(controller)
      request.setup_controller_request_and_response

      ## Run global setup before example
      Alfred.configuration.setup.each do |setup|
        request._setup(&setup)
      end

      ## Run setup blocks for scenario
      setups.each { |setup| request._setup(&setup) }

      ## Perform request
      request.send(method, action, params)

      ## Set response
      @response = request.response

      ## Persist response to disk
      save!
    end

    def file
      @file ||= FixtureFile.new(@response, controller_name, action, name)
    end

    ##
    # Persist the response on disk.
    #
    def save
      file.save
    end
    alias :save! :save

  end # Scenario
end # Alfred
