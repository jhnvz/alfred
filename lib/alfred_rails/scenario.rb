module Alfred
  class Scenario

    ## Attributes

    attr_accessor :name, :setup, :method, :controller, :action, :params, :identifier

    ##
    # Initialize a new Alfred scenario.
    #
    # === Params
    #
    # [name (String)] name of the scenario
    # [options (Hash)] optional options
    #
    # === Example
    #
    #   Scenario.new('admin permissions')
    #
    def initialize(name, options={})
      @name  = name.downcase.gsub(' ', '_')
      @setup = []
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
      RSpec::Mocks::setup(Object.new)

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

      ## Run setup blocks for scenario's
      setup.each { |setup| request._setup(&setup) }

      ## Perform request
      request.send(method, action, params)

      ## Set response
      @response = request.response

      ## Persist response to disk
      save!
    end

    ##
    # Returns the path name to save the fixture.
    #
    def path
      "#{Alfred.fixture_path}/#{controller_name}/#{action}"
    end

    ##
    # Returns the folder name to save the fixture.
    #
    def filename
      "#{path}/#{name}.#{format}"
    end

    ##
    # Returns the file format for response content type.
    #
    def format
      case @response.content_type
      when 'application/json' then 'json'
      when 'application/html' then 'html'
      when 'application/xml'  then 'xml'
      end
    end

    ##
    # Persist the response on disk.
    #
    def save
      FileUtils.mkdir_p(path)

      File.open(filename, 'w') do |fixture|
        fixture.write(@response.body)
      end
    end
    alias :save! :save

  end # Scenario
end # Alfred
