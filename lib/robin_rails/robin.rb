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
    # Set the identifier so we can lookup robins.
    #
    def set_identifier
      identifier_name = name.downcase.gsub(' ', '_')

      self.identifier = "#{identifier_name}/#{method}/#{controller.name.underscore}/#{action}"
    end

    ##
    # Returns the folder name to save the fixture.
    #
    def folder
      "#{controller}/#{action}"
    end

    ##
    # Runs the example.
    #
    def run
      controller.send(:include, Rails.application.routes.url_helpers)

      response = Response.new(name)
      response.setup(&setup)
      response.set_controller(controller.new)
      response.setup_controller_request_and_response
      response.send(method, action, params)

      raise response.response.body.inspect
    end

  end # Robin
end # RobinRails
